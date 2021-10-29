import 'package:ditonton/domain/entities/content_data.dart';
import 'package:ditonton/domain/entities/id_poster_title_overview.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:equatable/equatable.dart';

class WatchlistTable extends Equatable {
  final int id;
  final String? title;
  final String? posterPath;
  final String? overview;
  final int dataType;

  WatchlistTable(
      {required this.id,
      required this.title,
      required this.posterPath,
      required this.overview,
      required this.dataType});

  factory WatchlistTable.fromMovieDetail(MovieDetail movie) => WatchlistTable(
      id: movie.id,
      title: movie.title,
      posterPath: movie.posterPath,
      overview: movie.overview,
      dataType: DataType.Movie.index);

  factory WatchlistTable.fromMap(Map<String, dynamic> map) => WatchlistTable(
      id: map['id'],
      title: map['title'],
      posterPath: map['posterPath'],
      overview: map['overview'],
      dataType:
          map['dataType'] is Enum ? map['dataType'].index : map['dataType']);

  factory WatchlistTable.fromContentData(ContentData data) => WatchlistTable(
      id: data.id,
      title: data.title,
      posterPath: data.posterPath,
      overview: data.overview,
      dataType: data.dataType.index);

  factory WatchlistTable.fromIdPosterTitleOverview(
          IdPosterTitleOverview idPosterTitleOverview) =>
      WatchlistTable(
          id: idPosterTitleOverview.id,
          title: idPosterTitleOverview.title,
          posterPath: idPosterTitleOverview.poster,
          overview: idPosterTitleOverview.overview,
          dataType: idPosterTitleOverview.dataType.index);

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'posterPath': posterPath,
        'overview': overview,
        'dataType': dataType
      };

  Movie toEntity() => Movie.watchlist(
        id: id,
        overview: overview,
        posterPath: posterPath,
        title: title,
      );

  DataType _intToDataType() =>
      dataType == DataType.TvSeries.index ? DataType.TvSeries : DataType.Movie;

  IdPosterTitleOverview toIdPosterTitleOverview() => IdPosterTitleOverview(
      id, posterPath ?? "", title ?? "No Title", overview ?? "No Overview",
      dataType: _intToDataType());

  @override
  List<Object?> get props => [id, title, posterPath, overview, dataType];
}
