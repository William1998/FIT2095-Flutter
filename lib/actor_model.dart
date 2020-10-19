import 'dart:convert';

Actor actorFromJson(String str) => Actor.fromJson(json.decode(str));

String actorToJson(Actor data) => json.encode(data.toJson());

class Actor {
  Actor({
    this.movies,
    this.name,
    this.bYear,
    this.id,
    this.v,
  });

  List<dynamic> movies;
  String name;
  int bYear;
  String id;
  int v;

  factory Actor.fromJson(Map<String, dynamic> json) => Actor(
        movies: List<dynamic>.from(json["movies"].map((x) => x)),
        name: json["name"],
        bYear: json["bYear"],
        id: json["_id"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "movies": List<dynamic>.from(movies.map((x) => x)),
        "name": name,
        "bYear": bYear,
        "_id": id,
        "__v": v,
      };
}
