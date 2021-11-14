// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/id_poster_title_overview.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:equatable/equatable.dart';

part 'top_rated_movie_event.dart';
part 'top_rated_movie_state.dart';

class TopRatedMovieBloc extends Bloc<TopRatedMovieEvent, TopRatedMovieState> {
  TopRatedMovieBloc(GetTopRatedMovies getTopRatedMovies) : super(TopRatedMovieInitial()) {
    on<TopRatedMovieEvent>((event, emit) {
      if (event is OnTopRatedMovieDataRequested) {
        onTopRatedMovieDataRequested(getTopRatedMovies);
      }
    });
  }

  Future<void> onTopRatedMovieDataRequested(GetTopRatedMovies getTopRatedMovies) async {
    emit(TopRatedMovieLoading());

    final result = await getTopRatedMovies.execute();
    result.fold((failure) {
      final state = TopRatedMovieError(failure.message, retry: () {
        add(OnTopRatedMovieDataRequested());
      });

      emit(state);
    }, (data) {
      final result = data.map((e) => IdPosterTitleOverview.fromMovie(e)).toList();
      final state = TopRatedMovieSuccess(result);

      emit(state);
    });
  }
}
