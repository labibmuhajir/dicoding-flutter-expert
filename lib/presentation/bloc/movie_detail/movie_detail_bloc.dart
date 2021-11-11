// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/content_data.dart';
import 'package:ditonton/domain/entities/id_poster_data_type.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';

part 'movie_detail_event.dart';
part 'movie_detail_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  MovieDetailBloc(GetMovieDetail getMovieDetail,
      GetMovieRecommendations getMovieRecommendations)
      : super(MovieDetailInitial()) {
    on<MovieDetailEvent>((event, emit) {
      if (event is OnMovieDetailDataRequested) {
        onMovieDetailDataRequested(
            getMovieDetail, getMovieRecommendations, event.id);
      } else if (event is OnMovieRecommendationsRequested) {
        onMovieRecommendationsRequested(
            getMovieRecommendations, event.contentData);
      }
    });
  }

  Future<void> onMovieDetailDataRequested(GetMovieDetail getMovieDetail,
      GetMovieRecommendations getMovieRecommendations, int id) async {
    emit(MovieDetailLoading());

    final result = await getMovieDetail.execute(id);
    final futureRecommendation = getMovieRecommendations.execute(id);

    result.fold((failure) {
      final state = MovieDetailError(failure.message, retry: () {
        add(OnMovieDetailDataRequested(id));
      });

      emit(state);
    }, (data) async {
      final contentData = ContentData.fromMovie(data);
      final recommendation = await futureRecommendation;

      recommendation.fold((failure) {
        final state = MovieDetailError(failure.message, retry: () {
          add(OnMovieRecommendationsRequested(contentData));
        });

        emit(state);

        final detailState = MovieDetailSuccess(contentData);
        emit(detailState);
      }, (data) {
        final recommendationResult =
            data.map((e) => IdPosterDataType.fromMovie(e)).toList();

        final state = MovieDetailSuccess(contentData,
            recommendations: recommendationResult);
        emit(state);
      });
    });
  }

  Future<void> onMovieRecommendationsRequested(
      GetMovieRecommendations getMovieRecommendations,
      ContentData contentData) async {
    emit(MovieDetailLoading());
    final result = await getMovieRecommendations.execute(contentData.id);

    result.fold((failure) {
      final state = MovieDetailError(failure.message, retry: () {
        add(OnMovieRecommendationsRequested(contentData));
      });

      emit(state);
    }, (data) async {
      final recommendation =
          data.map((e) => IdPosterDataType.fromMovie(e)).toList();
      final state =
          MovieDetailSuccess(contentData, recommendations: recommendation);

      emit(state);
    });
  }
}
