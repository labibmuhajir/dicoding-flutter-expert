// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/id_poster_title_overview.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:equatable/equatable.dart';

part 'watchlist_event.dart';
part 'watchlist_state.dart';

class WatchlistBloc extends Bloc<WatchlistEvent, WatchlistState> {
  WatchlistBloc(GetWatchlist getWatchlist) : super(WatchlistInitial()) {
    on<WatchlistEvent>((event, emit) async {
      if (event is OnWatchlistDataRequested) {
        await onWatchListDataRequested(getWatchlist);
      }
    });
  }

  Future<void> onWatchListDataRequested(GetWatchlist getWatchlist) async {
    emit(WatchlistLoading());
    final result = await getWatchlist.execute();

    result.fold((failure) {
      final state = WatchlistError(failure.message, retry: () {
        add(OnWatchlistDataRequested());
      });

      emit(state);
    }, (data) {
      if (data.isEmpty) {
        emit(WatchlistEmpty());
        return;
      }

      emit(WatchlistHasData(data));
    });
  }
}
