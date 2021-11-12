// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/id_poster_title_overview.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv_series.dart';
import 'package:equatable/equatable.dart';

part 'top_rated_tv_series_event.dart';
part 'top_rated_tv_series_state.dart';

class TopRatedTvSeriesBloc extends Bloc<TopRatedTvSeriesEvent, TopRatedTvSeriesState> {
  TopRatedTvSeriesBloc(GetTopRatedTvSeries getTopRatedTvSeries) : super(TopRatedTvSeriesInitial()) {
    on<TopRatedTvSeriesEvent>((event, emit) {
      if (event is OnTopRatedTvSeriesDataRequested) {
        onTopRatedTvSeriesDataRequested(getTopRatedTvSeries);
      }
    });
  }

  Future<void> onTopRatedTvSeriesDataRequested(GetTopRatedTvSeries getTopRatedTvSeries) async {
    emit(TopRatedTvSeriesLoading());
    final result = await getTopRatedTvSeries.execute();

    result.fold((failure) {
      final state = TopRatedTvSeriesError(failure.message, retry: () {
        add(OnTopRatedTvSeriesDataRequested());
      });

      emit(state);
    }, (data) {
      final result = data.map((e) => IdPosterTitleOverview.fromTvSeries(e)).toList();
      final state = TopRatedTvSeriesSuccess(result);

      emit(state);
    });
  }
}
