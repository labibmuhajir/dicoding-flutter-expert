import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/content_data.dart';
import 'package:ditonton/domain/entities/id_and_data_type.dart';
import 'package:ditonton/domain/entities/id_poster_title_overview.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:flutter/foundation.dart';

class WatchlistNotifier extends ChangeNotifier {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  var _watchlist = <IdPosterTitleOverview>[];
  List<IdPosterTitleOverview> get watchlist => _watchlist;

  var _watchlistState = RequestState.Empty;
  RequestState get watchlistState => _watchlistState;

  bool _isAddedtoWatchlist = false;
  bool get isAddedToWatchlist => _isAddedtoWatchlist;

  String _message = '';
  String get message => _message;

  WatchlistNotifier(
      {required this.getWatchlist,
      required this.getWatchListStatus,
      required this.saveWatchlist,
      required this.removeWatchlist});

  final GetWatchlist getWatchlist;
  final GetWatchListStatus getWatchListStatus;
  final SaveWatchlist saveWatchlist;
  final RemoveWatchlist removeWatchlist;

  Future<void> fetchWatchlistMovies() async {
    _watchlistState = RequestState.Loading;
    notifyListeners();

    final result = await getWatchlist.execute();
    result.fold(
      (failure) {
        _watchlistState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (moviesData) {
        _watchlistState = RequestState.Loaded;
        _watchlist = moviesData;
        notifyListeners();
      },
    );
  }

  Future<void> addWatchlist(ContentData contentData) async {
    final result = await saveWatchlist.execute(contentData);

    await result.fold(
      (failure) async {
        _message = failure.message;
      },
      (successMessage) async {
        _message = successMessage;
      },
    );

    await loadWatchlistStatus(
        IdAndDataType(contentData.id, contentData.dataType));
  }

  Future<void> removeFromWatchlist(IdAndDataType idAndDataType) async {
    final result = await removeWatchlist.execute(idAndDataType);

    await result.fold(
      (failure) async {
        _message = failure.message;
      },
      (successMessage) async {
        _message = successMessage;
      },
    );

    await loadWatchlistStatus(idAndDataType);
  }

  Future<void> loadWatchlistStatus(IdAndDataType idAndDataType) async {
    final result = await getWatchListStatus.execute(
        idAndDataType.id, idAndDataType.dataType.index);
    _isAddedtoWatchlist = result;

    fetchWatchlistMovies();
  }
}
