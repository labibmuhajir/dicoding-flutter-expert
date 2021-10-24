import 'package:ditonton/data/models/tv_series_model.dart';
import 'package:ditonton/domain/entities/id_poster_title_overview.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:equatable/equatable.dart';

class IdPosterDataType extends Equatable {
  final int id;
  final String poster;
  final DataType dataType;

  IdPosterDataType(this.id, this.poster, this.dataType);

  factory IdPosterDataType.fromMovie(Movie movie) =>
      IdPosterDataType(movie.id, movie.posterPath ?? "", DataType.Movie);

  factory IdPosterDataType.fromTvSeries(TvSeriesModel tvSeries) =>
      IdPosterDataType(
          tvSeries.id, tvSeries.posterPath ?? "", DataType.TvSeries);

  @override
  List<Object?> get props => [id, poster];
}
