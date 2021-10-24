import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/id_poster_title_overview.dart';
import 'package:ditonton/domain/usecases/search_tv_series.dart';
import 'package:flutter/foundation.dart';

class TvSeriesSearchNotifier extends ChangeNotifier {
  final SearchTvSeries searchTvSeries;

  TvSeriesSearchNotifier({required this.searchTvSeries});

  RequestState _state = RequestState.Empty;
  RequestState get state => _state;

  List<IdPosterTitleOverview> _searchResult = [];
  List<IdPosterTitleOverview> get searchResult => _searchResult;

  String _message = '';
  String get message => _message;

  Future<void> fetchTvSeriesSearch(String query) async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await searchTvSeries.execute(query);
    result.fold(
      (failure) {
        _message = failure.message;
        _state = RequestState.Error;
        notifyListeners();
      },
      (data) {
        _searchResult =
            data.map((e) => IdPosterTitleOverview.fromTvSeries(e)).toList();
        _state = RequestState.Loaded;
        notifyListeners();
      },
    );
  }
}
