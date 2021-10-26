import 'package:ditonton/domain/entities/content_data.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/id_poster_data_type.dart';
import 'package:ditonton/domain/usecases/get_tv_series_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_series_recommendations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TvDetailNotifier extends ChangeNotifier {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetTvSeriesDetail getTvSeriesDetail;
  final GetTvSeriesRecommendations getTvSeriesRecommendations;

  TvDetailNotifier(
      {required this.getTvSeriesDetail,
      required this.getTvSeriesRecommendations});

  late ContentData _tvSeries;
  ContentData get tvSeries => _tvSeries;

  late List<IdPosterDataType> _recommendations;
  List<IdPosterDataType> get recommendations => _recommendations;

  RequestState _tvSeriesState = RequestState.Empty;
  RequestState get tvSeriesState => _tvSeriesState;

  RequestState _recommendationState = RequestState.Empty;
  RequestState get recommendationState => _recommendationState;

  String _message = '';
  String get message => _message;

  Future<void> fetchTvDetail(int id) async {
    _tvSeriesState = RequestState.Loading;
    _recommendationState = RequestState.Loading;
    notifyListeners();
    final detailResult = await getTvSeriesDetail.execute(id);
    final recommendationFuture = getTvSeriesRecommendations.execute(id);

    await detailResult.fold(
      (failure) {
        _tvSeriesState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (data) async {
        _tvSeries = ContentData.fromTvSeries(data);
        _tvSeriesState = RequestState.Loaded;
        notifyListeners();

        final recommendationResult = await recommendationFuture;
        recommendationResult.fold((failure) {
          _recommendationState = RequestState.Error;
          _message = failure.message;
          notifyListeners();
        }, (data) {
          _recommendations =
              data.map((e) => IdPosterDataType.fromTvSeries(e)).toList();
          _recommendationState = RequestState.Loaded;
          notifyListeners();
        });
      },
    );
  }
}
