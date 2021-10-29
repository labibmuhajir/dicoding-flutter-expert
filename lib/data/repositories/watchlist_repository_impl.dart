import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/datasources/movie_local_data_source.dart';
import 'package:ditonton/data/models/movie_table.dart';
import 'package:ditonton/domain/entities/content_data.dart';
import 'package:ditonton/domain/entities/id_poster_title_overview.dart';
import 'package:ditonton/common/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/repositories/watch_list_repository.dart';

class WatchlistRepositoryImpl extends WatchlistRepository {
  final WatchlistLocalDataSource localDataSource;

  WatchlistRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, List<IdPosterTitleOverview>>> getWatchlist() async {
    final result = await localDataSource.getWatchlistMovies();
    return Right(result.map((data) => data.toIdPosterTitleOverview()).toList());
  }

  @override
  Future<bool> isAddedToWatchlist(int id, int dataType) async {
    final result = await localDataSource.getMovieById(id, dataType);
    return result != null;
  }

  @override
  Future<Either<Failure, String>> removeWatchlist(int id, int dataType) async {
    try {
      final result = await localDataSource.removeWatchlist(id, dataType);
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> saveWatchlist(ContentData contentData) async {
    try {
      final data = WatchlistTable.fromContentData(contentData);
      final result = await localDataSource.insertWatchlist(data);
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      throw e;
    }
  }
}
