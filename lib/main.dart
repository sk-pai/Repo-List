// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'package: github_api/models/repo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class Repo {
  String? name;
  String? htmlUrl;
  String? description;
  Repo({
      this.name,
      this.htmlUrl,
      this.description
  });

  factory Repo.fromJson(Map<String, dynamic> json) {
    return Repo(
      name: json['name'],
      htmlUrl: json['html_url'],
      description: json['description'],
    );
  }
}

class All {
  List<Repo> repos;

  All({required this.repos});
  factory All.fromJson(List<dynamic> json) {
    // ignore: prefer_collection_literals
    List<Repo> repos = List<Repo>.empty(growable: true);
    

    repos = json.map((r) => Repo.fromJson(r)).toList();
   
    return All(repos: repos);
  }
}

Future<All> fetchRepos() async {
  
  
  final response1 = await http.get(Uri.parse('https://api.github.com/users/freeCodeCamp/repos'));
  
  if (response1.statusCode == 200) {
    //print(response.body);
    return All.fromJson(json.decode(response1.body));
  } else {
    throw Exception('Failed to Fetch repos!');
  }
}




class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  late Future<All> futureRepo;
  
  @override
  void initState() {
    super.initState();
    futureRepo=fetchRepos();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
        appBar: AppBar(
        
          title: const Text('Github Repo List'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder<All>(
            future: futureRepo,
            builder: (context, snapshot) {
              print(snapshot.hasData);
              if (snapshot.hasData) {
                List<Repo> repos = List<Repo>.empty(growable: true);

                for (int i = 0; i < snapshot.data!.repos.length; i++) {
                  repos.add(
                    Repo(
                      name: snapshot.data!.repos[i].name,
                      htmlUrl: snapshot.data!.repos[i].htmlUrl,
                      description: snapshot.data!.repos[i].description,
                      
                    ),
                  );
                }
              
                return ListView(
                  children: repos.map((r) => Card(
                    child: Container(
                      height: 60,
                      color: Colors.blue[100],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(r.name ?? '',
                          style: const TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold,height: 1.0),
                          ),
                          Text(r.description ?? '',
                          style: const TextStyle(fontSize: 13.0,height: 1.0),
                          ),
                          Text(r.htmlUrl ?? '',
                          style: const TextStyle(fontSize: 12.0,fontStyle: FontStyle.italic,height: 1.0)
                          ),
                          //Text(r.stargazersCount.toString())
                        ],
                      ),
                      
                    )
                    
                  )).toList(),
                );
              } else if (snapshot.hasError) {
                print(snapshot.error);
                return const Center(
                  child: Text('Error'),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        )
        
      );
  }
}
