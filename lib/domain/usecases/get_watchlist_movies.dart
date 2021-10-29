import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/id_poster_title_overview.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/repositories/watch_list_repository.dart';

class GetWatchlist {
  final WatchlistRepository repository;

  GetWatchlist(this.repository);

  Future<Either<Failure, List<IdPosterTitleOverview>>> execute() {
    return repository.getWatchlist();
  }
}
