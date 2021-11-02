import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/content_data.dart';
import 'package:ditonton/domain/entities/id_poster_title_overview.dart';

abstract class WatchlistRepository {
  Future<Either<Failure, String>> saveWatchlist(ContentData contentData);
  Future<Either<Failure, String>> removeWatchlist(int id, int dataType);
  Future<bool> isAddedToWatchlist(int id, int dataType);
  Future<Either<Failure, List<IdPosterTitleOverview>>> getWatchlist();
}
