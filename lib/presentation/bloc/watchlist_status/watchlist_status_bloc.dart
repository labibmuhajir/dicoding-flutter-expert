// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/content_data.dart';
import 'package:ditonton/domain/entities/id_and_data_type.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:ditonton/presentation/bloc/watchlist/watchlist_bloc.dart';
import 'package:equatable/equatable.dart';

part 'watchlist_status_event.dart';
part 'watchlist_status_state.dart';

class WatchlistStatusBloc
    extends Bloc<WatchlistStatusEvent, WatchlistStatusState> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  WatchlistStatusBloc(
      WatchlistBloc watchlistBloc,
      GetWatchListStatus getWatchListStatus,
      SaveWatchlist saveWatchlist,
      RemoveWatchlist removeWatchlist)
      : super(WatchlistStatusInitial()) {
    on<WatchlistStatusEvent>((event, emit) async {
      if (event is OnWatchlistAdded) {
        await onWatchlistAdded(watchlistBloc, saveWatchlist, event.contentData);
      } else if (event is OnWatchlistRemoved) {
        await onWatchListRemoved(
            watchlistBloc, removeWatchlist, event.idAndDataType);
      } else if (event is OnWatchlistStatusChecked) {
        await onWatchListStatusChecked(getWatchListStatus, event.idAndDataType);
      }
    });
  }

  Future<void> onWatchListStatusChecked(GetWatchListStatus getWatchListStatus,
      IdAndDataType idAndDataType) async {
    final isAdded = await getWatchListStatus.execute(
        idAndDataType.id, idAndDataType.dataType.index);

    emit(WatchlistStatusLoaded(isAdded));
  }

  Future<void> onWatchListRemoved(WatchlistBloc watchlistBloc,
      RemoveWatchlist removeWatchlist, IdAndDataType idAndDataType) async {
    emit(WatchlistStatusLoading());
    final result = await removeWatchlist.execute(idAndDataType);

    result.fold((failure) {
      final state = WatchlistStatusError(failure.message, retry: () {
        add(OnWatchlistRemoved(idAndDataType));
      });

      emit(state);
    }, (data) {
      final state = WatchlistStatusSuccess('Success Removed');
      emit(state);

      add(OnWatchlistStatusChecked(idAndDataType));

      watchlistBloc.add(OnWatchlistDataRequested());
    });
  }

  Future<void> onWatchlistAdded(WatchlistBloc watchlistBloc,
      SaveWatchlist saveWatchlist, ContentData contentData) async {
    emit(WatchlistStatusLoading());
    final result = await saveWatchlist.execute(contentData);

    result.fold((failure) {
      final state = WatchlistStatusError(failure.message, retry: () {
        add(OnWatchlistAdded(contentData));
      });

      emit(state);
    }, (data) {
      final state = WatchlistStatusSuccess(
          'Success Added ${contentData.title} to watchlist');
      emit(state);

      add(OnWatchlistStatusChecked(
          IdAndDataType(contentData.id, contentData.dataType)));
      watchlistBloc.add(OnWatchlistDataRequested());
    });
  }
}
