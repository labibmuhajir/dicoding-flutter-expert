import 'package:ditonton/data/models/tv_detail_model.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/id_poster_title_overview.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:equatable/equatable.dart';

class ContentData extends Equatable {
  final int id;
  final String title;
  final List<Genre> genres;
  final String runtime;
  final String posterPath;
  final double voteAverage;
  final String overview;
  final DataType dataType;

  ContentData(
      {required this.id,
      required this.title,
      required this.genres,
      required this.runtime,
      required this.posterPath,
      required this.voteAverage,
      required this.overview,
      required this.dataType});

  factory ContentData.fromMovie(MovieDetail movie) => ContentData(
      id: movie.id,
      title: movie.title,
      genres: movie.genres,
      runtime: '${movie.runtime}',
      posterPath: movie.posterPath,
      voteAverage: movie.voteAverage,
      overview: movie.overview,
      dataType: DataType.Movie);

  factory ContentData.fromTvSeries(TvDetailModel tvSeries) => ContentData(
      id: tvSeries.id,
      title: tvSeries.name,
      genres:
          tvSeries.genres.map((e) => Genre(id: e.id, name: e.name)).toList(),
      runtime:
          '${tvSeries.numberOfEpisodes} episode(s) ${tvSeries.numberOfSeasons} season(s)',
      posterPath: tvSeries.posterPath,
      voteAverage: tvSeries.voteAverage.toDouble(),
      overview: tvSeries.overview,
      dataType: DataType.TvSeries);

  @override
  List<Object?> get props =>
      [id, title, genres, runtime, posterPath, voteAverage, overview];
}
