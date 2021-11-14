import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/id_poster_title_overview.dart';
import 'package:ditonton/domain/usecases/search_tv_series.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

part 'tv_series_search_event.dart';
part 'tv_series_search_state.dart';

class TvSeriesSearchBloc
    extends Bloc<TvSeriesSearchEvent, TvSeriesSearchState> {
  TvSeriesSearchBloc(SearchTvSeries searchTvSeries)
      : super(TvSeriesSearchInitial()) {
    on<TvSeriesSearchEvent>((event, emit) async {
      if (event is OnQueryTvSeriesChanged) {
        final query = event.query;

        if (query.isEmpty) {
          emit(TvSeriesSearchInitial());
          return;
        }

        emit(TvSeriesSearchLoading());

        final result = await searchTvSeries.execute(query);

        result.fold((failure) {
          final resultState = TvSeriesSearchError('Server Failure', retry: () {
            add(OnQueryTvSeriesChanged(query));
          });

          emit(resultState);
        }, (data) async {
          if (data.isNotEmpty) {
            final result =
                data.map((e) => IdPosterTitleOverview.fromTvSeries(e)).toList();
            final resultState = TvSeriesSearchHasData(result);

            emit(resultState);
          } else {
            emit(TvSeriesSearchEmpty('No Tv Series Found $query'));
          }
        });
      }
    }, transformer: debounce(const Duration(milliseconds: 500)));
  }

  EventTransformer<TvSeriesSearchEvent> debounce<TvSeriesSearchEvent>(
      Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }
}
