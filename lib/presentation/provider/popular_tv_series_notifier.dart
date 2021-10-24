import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/id_poster_title_overview.dart';
import 'package:ditonton/domain/usecases/get_popular_tv_series.dart';
import 'package:flutter/material.dart';

class PopularTvSeriesNotifier extends ChangeNotifier {
  GetPopularTvSeries getPopularTvSeries;

  RequestState _state = RequestState.Empty;
  RequestState get state => _state;

  List<IdPosterTitleOverview> _popularTvSeries = [];
  List<IdPosterTitleOverview> get popularTvSeries => _popularTvSeries;

  String _message = '';
  String get message => _message;

  PopularTvSeriesNotifier({required this.getPopularTvSeries});

  Future<void> fetchPopularTvSeries() async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await getPopularTvSeries.execute();

    result.fold(
      (failure) {
        _message = failure.message;
        _state = RequestState.Error;
        notifyListeners();
      },
      (data) {
        _popularTvSeries =
            data.map((e) => IdPosterTitleOverview.fromTvSeries(e)).toList();
        _state = RequestState.Loaded;
        notifyListeners();
      },
    );
  }
}
