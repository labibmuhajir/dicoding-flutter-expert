import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/id_poster_title_overview.dart';
import 'package:ditonton/domain/repositories/watch_list_repository.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetWatchListStatus usecase;
  late WatchlistRepository repository;

  setUp(() {
    repository = MockWatchlistRepository();
    usecase = GetWatchListStatus(repository);
  });
  test('should get watchlist status from repository', () async {
    // arrange
    final data = testMovieList;
    final expected =
        data.map((e) => IdPosterTitleOverview.fromMovie(e)).toList();
    final id = 1;
    final dataType = DataType.Movie.index;

    when(repository.isAddedToWatchlist(id, dataType))
        .thenAnswer((_) async => true);
    when(repository.getWatchlist()).thenAnswer((_) async => Right(expected));
    // act
    final result = await usecase.execute(id, dataType);
    // assert
    expect(result, true);
  });
}
