// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/id_poster_title_overview.dart';
import 'package:ditonton/domain/usecases/get_now_playing_movies.dart';
import 'package:equatable/equatable.dart';

part 'now_playing_movie_event.dart';
part 'now_playing_movie_state.dart';

class NowPlayingMovieBloc
    extends Bloc<NowPlayingMovieEvent, NowPlayingMovieState> {
  NowPlayingMovieBloc(GetNowPlayingMovies getNowPlayingMovies)
      : super(NowPlayingMovieInitial()) {
    on<NowPlayingMovieEvent>((event, emit) {
      if (event is OnNowPlayingMovieDataRequested) {
        onNowPlayingMovieDataRequested(getNowPlayingMovies);
      }
    });
  }

  Future<void> onNowPlayingMovieDataRequested(
      GetNowPlayingMovies getNowPlayingMovies) async {
    emit(NowPlayingMovieLoading());

    final result = await getNowPlayingMovies.execute();

    result.fold((failure) {
      final state = NowPlayingMovieError(failure.message, retry: () {
        add(OnNowPlayingMovieDataRequested());
      });

      emit(state);
    }, (data) {
      final result =
          data.map((e) => IdPosterTitleOverview.fromMovie(e)).toList();
      final state = NowPlayingMovieSuccess(result);

      emit(state);
    });
  }
}
