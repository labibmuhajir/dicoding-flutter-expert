// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/id_poster_title_overview.dart';
import 'package:ditonton/domain/usecases/get_popular_tv_series.dart';
import 'package:equatable/equatable.dart';

part 'popular_tv_series_event.dart';
part 'popular_tv_series_state.dart';

class PopularTvSeriesBloc extends Bloc<PopularTvSeriesEvent, PopularTvSeriesState> {
  PopularTvSeriesBloc(GetPopularTvSeries getPopularTvSeries) : super(PopularTvSeriesInitial()) {
    on<PopularTvSeriesEvent>((event, emit) {
      if (event is OnPopulartTvSeriesDataRequested) {
        onPopularTvSeriesDataRequested(getPopularTvSeries);
      }
    });
  }

  Future<void> onPopularTvSeriesDataRequested(GetPopularTvSeries getPopularTvSeries) async {
    emit(PopularTvSeriesLoading());

    final result = await getPopularTvSeries.execute();

    result.fold((failure) {
      final state = PopularTvSeriesError(failure.message, retry: () {
        add(OnPopulartTvSeriesDataRequested());
      });

      emit(state);
    }, (data) {
      final tvSeries = data.map((e) => IdPosterTitleOverview.fromTvSeries(e)).toList();
      final state = PopularTvSeriesSuccess(tvSeries);

      emit(state);
    });
  }

}

