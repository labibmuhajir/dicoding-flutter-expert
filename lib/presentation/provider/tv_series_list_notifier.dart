import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/id_poster_data_type.dart';
import 'package:ditonton/domain/usecases/get_on_the_air_tv_series.dart';
import 'package:ditonton/domain/usecases/get_popular_tv_series.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv_series.dart';
import 'package:flutter/material.dart';

class TvSeriesListNotifier extends ChangeNotifier {
  final GetOnTheAirTvSeries getOnTheAirTvSeries;
  final GetPopularTvSeries getPopularTvSeries;
  final GetTopRatedTvSeries getTopRatedTvSeries;

  List<IdPosterDataType> onTheAirTvSeries = [];

  RequestState _onTheAirState = RequestState.Empty;
  RequestState get onTheAirState => _onTheAirState;

  List<IdPosterDataType> popularTvSeries = [];

  RequestState _popularState = RequestState.Empty;
  RequestState get popularState => _popularState;

  List<IdPosterDataType> topRatedTvSeries = [];

  RequestState _topRatedState = RequestState.Empty;
  RequestState get topRatedState => _topRatedState;

  String _message = '';
  String get message => _message;

  TvSeriesListNotifier(
      {required this.getOnTheAirTvSeries,
      required this.getPopularTvSeries,
      required this.getTopRatedTvSeries});

  Future<void> fetchOnTheAirTvSeries() async {
    _onTheAirState = RequestState.Loading;
    notifyListeners();

    final result = await getOnTheAirTvSeries.execute();
    result.fold((failure) {
      _message = failure.message;
      _onTheAirState = RequestState.Error;
      notifyListeners();
    }, (data) {
      final result = data.map((e) => IdPosterDataType.fromTvSeries(e)).toList();
      onTheAirTvSeries = result;
      _onTheAirState = RequestState.Loaded;
      notifyListeners();
    });
  }

  Future<void> fetchPopularTvSeries() async {
    _popularState = RequestState.Loading;
    notifyListeners();

    final result = await getPopularTvSeries.execute();
    result.fold((failure) {
      _message = failure.message;
      _popularState = RequestState.Error;
      notifyListeners();
    }, (data) {
      final result = data.map((e) => IdPosterDataType.fromTvSeries(e)).toList();
      popularTvSeries = result;
      _popularState = RequestState.Loaded;
      notifyListeners();
    });
  }

  Future<void> fetchTopRatedTvSeries() async {
    _topRatedState = RequestState.Loading;
    notifyListeners();

    final result = await getTopRatedTvSeries.execute();
    result.fold((failure) {
      _message = failure.message;
      _topRatedState = RequestState.Error;
      notifyListeners();
    }, (data) {
      final result = data.map((e) => IdPosterDataType.fromTvSeries(e)).toList();
      topRatedTvSeries = result;
      _topRatedState = RequestState.Loaded;
      notifyListeners();
    });
  }
}
