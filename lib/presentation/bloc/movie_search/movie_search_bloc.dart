import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/search_movies.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/src/transformers/backpressure/debounce.dart';
import 'package:rxdart/src/transformers/flat_map.dart';

part 'movie_search_event.dart';
part 'movie_search_state.dart';

class MovieSearchBloc extends Bloc<MovieSearchEvent, MovieSearchState> {
  MovieSearchBloc(SearchMovies searchMovies) : super(MovieSearchInitial()) {
    on<MovieSearchEvent>((event, emit) async {
      if (event is OnQueryMovieChanged) {
        final query = event.query;

        if (query.isEmpty) {
          emit(MovieSearchInitial());
          return;
        }

        emit(MovieSearchLoading());

        final result = await searchMovies.execute(query);

        result.fold((failure) {
          final resultState = MovieSearchError('Server Failure', retry: () {
            add(OnQueryMovieChanged(query));
          });

          emit(resultState);
        }, (data) async {
          if (data.isNotEmpty) {
            final resultState = MovieSearchHasData(data);

            emit(resultState);
          } else {
            emit(MovieSearchEmpty('No movie found $query'));
          }
        });
      }
    }, transformer: debounce(const Duration(milliseconds: 500)));
  }

  EventTransformer<MovieSearchEvent> debounce<MovieSearchEvent>(
      Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }
}
