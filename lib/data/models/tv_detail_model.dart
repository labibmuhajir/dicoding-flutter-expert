import 'package:ditonton/data/models/genre_model.dart';
import 'package:equatable/equatable.dart';

class TvDetailModel extends Equatable {
  final int id;
  final String name;
  final List<GenreModel> genres;
  final String posterPath;
  final double voteAverage;
  final String overview;
  final int numberOfSeasons;
  final int numberOfEpisodes;

  TvDetailModel(
      {required this.id,
      required this.name,
      required this.genres,
      required this.posterPath,
      required this.voteAverage,
      required this.overview,
      required this.numberOfEpisodes,
      required this.numberOfSeasons});

  factory TvDetailModel.fromJson(Map<String, dynamic> json) => TvDetailModel(
      id: json['id'],
      name: json['name'],
      genres: List<GenreModel>.from(
          json["genres"].map((x) => GenreModel.fromJson(x))),
      posterPath: json['poster_path'],
      voteAverage: json['vote_average'],
      overview: json['overview'],
      numberOfEpisodes: json['number_of_episodes'],
      numberOfSeasons: json['number_of_seasons']);

  @override
  List<Object?> get props => [
        id,
        name,
        genres,
        posterPath,
        voteAverage,
        overview,
        numberOfEpisodes,
        numberOfSeasons
      ];
}
