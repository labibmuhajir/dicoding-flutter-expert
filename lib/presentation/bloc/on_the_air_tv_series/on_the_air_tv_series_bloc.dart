// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/id_poster_title_overview.dart';
import 'package:ditonton/domain/usecases/get_on_the_air_tv_series.dart';
import 'package:equatable/equatable.dart';

part 'on_the_air_tv_series_event.dart';
part 'on_the_air_tv_series_state.dart';

class OnTheAirTvSeriesBloc extends Bloc<OnTheAirTvSeriesEvent, OnTheAirTvSeriesState> {
  OnTheAirTvSeriesBloc(GetOnTheAirTvSeries getOnTheAirTvSeries) : super(OnTheAirTvSeriesInitial()) {
    on<OnTheAirTvSeriesEvent>((event, emit) async {
      if (event is OnTheAirTvSeriesDataRequested) {
        await onTheAirTvSeriesDataRequested(getOnTheAirTvSeries);
      }
    });
  }

  Future<void> onTheAirTvSeriesDataRequested(GetOnTheAirTvSeries getOnTheAirTvSeries) async {
    emit(OnTheAirTvSeriesLoading());

    final result = await getOnTheAirTvSeries.execute();
    result.fold((failure) {
      final state = OnTheAirTvSeriesError(failure.message, retry: () {
        add(OnTheAirTvSeriesDataRequested());
      });

      emit(state);
    }, (data) {
      final result = data.map((e) => IdPosterTitleOverview.fromTvSeries(e)).toList();
      final state = OnTheAirTvSeriesSuccess(result);

      emit(state);
    });
  }
}
