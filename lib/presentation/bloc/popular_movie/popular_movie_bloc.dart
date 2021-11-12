// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/id_poster_title_overview.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:equatable/equatable.dart';

part 'popular_movie_event.dart';
part 'popular_movie_state.dart';

class PopularMovieBloc extends Bloc<PopularMovieEvent, PopularMovieState> {
  PopularMovieBloc(GetPopularMovies getPopularMovies) : super(PopularMovieInitial()) {
    on<PopularMovieEvent>((event, emit) {
      if (event is OnPopularMovieDataRequested) {
        onPopularMovieDataRequested(getPopularMovies);
      }
    });
  }

  Future<void> onPopularMovieDataRequested(GetPopularMovies getPopularMovies) async {
    emit(PopularMovieLoading());
    final result = await getPopularMovies.execute();

    result.fold((failure) {
      final state = PopularMovieError(failure.message, retry: () {
        add(OnPopularMovieDataRequested());
      });

      emit(state);
    }, (data) {
      final result = data.map((e) => IdPosterTitleOverview.fromMovie(e)).toList();
      final state = PopularMovieSuccess(result);

      emit(state);
    });
  }
}


