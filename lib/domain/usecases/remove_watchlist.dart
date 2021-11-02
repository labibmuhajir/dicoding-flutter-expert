import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/id_and_data_type.dart';
import 'package:ditonton/domain/repositories/watch_list_repository.dart';

class RemoveWatchlist {
  final WatchlistRepository repository;

  RemoveWatchlist(this.repository);

  Future<Either<Failure, String>> execute(IdAndDataType idAndDataType) {
    return repository.removeWatchlist(
        idAndDataType.id, idAndDataType.dataType.index);
  }
}
