import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/id_and_data_type.dart';
import 'package:ditonton/domain/entities/id_poster_title_overview.dart';
import 'package:ditonton/domain/repositories/watch_list_repository.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late RemoveWatchlist usecase;
  late WatchlistRepository repository;

  setUp(() {
    repository = MockWatchlistRepository();
    usecase = RemoveWatchlist(repository);
  });

  test('should remove watchlist movie from repository', () async {
    // arrange
    final data = IdPosterTitleOverview.fromMovieDetail(testMovieDetail);
    final id = data.id;
    final dataType = data.dataType;
    final idAdDataType = IdAndDataType(id, dataType);

    when(repository.removeWatchlist(id, dataType.index))
        .thenAnswer((_) async => Right('Removed from watchlist'));
    // act
    final result = await usecase.execute(idAdDataType);
    // assert
    verify(repository.removeWatchlist(id, dataType.index));
    expect(result, Right('Removed from watchlist'));
  });
}
