import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/id_poster_title_overview.dart';
import 'package:ditonton/domain/repositories/watch_list_repository.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetWatchlist usecase;
  late WatchlistRepository repository;

  setUp(() {
    repository = MockWatchlistRepository();
    usecase = GetWatchlist(repository);
  });

  test('should get list of movies from the repository', () async {
    // arrange
    final data = testMovieList;
    final expected =
        data.map((e) => IdPosterTitleOverview.fromMovie(e)).toList();

    when(repository.getWatchlist()).thenAnswer((_) async => Right(expected));
    // act
    final result = await usecase.execute();
    // assert
    expect(result, Right(expected));
  });
}
