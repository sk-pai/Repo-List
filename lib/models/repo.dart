// ignore_for_file: deprecated_member_use, unnecessary_new

class Repo{
  String name;
  String htmlUrl;
  int stargazersCount;
  String description;
  Repo({required this.name,required this.htmlUrl,required this.stargazersCount,required this.description});

  factory Repo.fromJson(Map<String, dynamic> json ){
    return Repo(
      name : json['name'],
      htmlUrl : json['htmlUrl'],
      stargazersCount : json['stargazers_count'],
      description : json['description'],
    );
  }
}

class All{
  List<Repo> repos;
  All({required this.repos});
  factory All.fromJson(List<dynamic> json){
    // ignore: prefer_collection_literals
    List<Repo> repos = new List<Repo>.filled(0,0 as Repo, growable:true);
    repos = json.map((r) => Repo.fromJson(r)).toList();
    return All(repos:repos);

  }
}
