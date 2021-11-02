import 'package:ditonton/domain/repositories/watch_list_repository.dart';

class GetWatchListStatus {
  final WatchlistRepository repository;

  GetWatchListStatus(this.repository);

  Future<bool> execute(int id, int dataType) async {
    return repository.isAddedToWatchlist(id, dataType);
  }
}
