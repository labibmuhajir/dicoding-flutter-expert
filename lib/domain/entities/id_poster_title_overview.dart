import 'package:ditonton/data/models/tv_series_model.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:equatable/equatable.dart';

enum DataType { Movie, TvSeries }

class IdPosterTitleOverview extends Equatable {
  final int id;
  final String poster;
  final String title;
  final String overview;
  final DataType dataType;

  IdPosterTitleOverview(this.id, this.poster, this.title, this.overview,
      {required this.dataType});

  factory IdPosterTitleOverview.fromMovie(Movie movie) => IdPosterTitleOverview(
      movie.id,
      movie.posterPath ?? "",
      movie.title ?? "No Title",
      movie.overview ?? "No Overview",
      dataType: DataType.Movie);

  factory IdPosterTitleOverview.fromMovieDetail(MovieDetail movieDetail) =>
      IdPosterTitleOverview(movieDetail.id, movieDetail.posterPath,
          movieDetail.title, movieDetail.overview,
          dataType: DataType.Movie);

  factory IdPosterTitleOverview.fromTvSeries(TvSeriesModel tvSeries) =>
      IdPosterTitleOverview(tvSeries.id, tvSeries.posterPath ?? "",
          tvSeries.name, tvSeries.overview,
          dataType: DataType.TvSeries);

  @override
  List<Object?> get props => [id, poster, title, overview];
}
