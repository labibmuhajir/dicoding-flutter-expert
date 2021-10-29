import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/content_data.dart';
import 'package:ditonton/domain/repositories/watch_list_repository.dart';

class SaveWatchlist {
  final WatchlistRepository repository;

  SaveWatchlist(this.repository);

  Future<Either<Failure, String>> execute(ContentData contentData) {
    return repository.saveWatchlist(contentData);
  }
}
