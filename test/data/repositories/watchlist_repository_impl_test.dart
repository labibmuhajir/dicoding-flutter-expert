import 'package:dartz/dartz.dart';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/data/datasources/movie_local_data_source.dart';
import 'package:ditonton/data/repositories/watchlist_repository_impl.dart';
import 'package:ditonton/domain/entities/content_data.dart';
import 'package:ditonton/domain/entities/id_poster_title_overview.dart';
import 'package:ditonton/domain/repositories/watch_list_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late WatchlistLocalDataSource localDataSource;
  late WatchlistRepository repository;

  setUp(() {
    localDataSource = MockWatchlistLocalDataSource();
    repository = WatchlistRepositoryImpl(localDataSource);
  });

  final source = testMovieDetail;
  final data = ContentData.fromMovie(source);
  final table = testMovieTable;
  final id = data.id;
  final dataType = data.dataType;

  group('save watchlist', () {
    test('should return success message when saving successful', () async {
      // arrange
      when(localDataSource.insertWatchlist(table))
          .thenAnswer((_) async => 'Added to Watchlist');
      // act
      final result = await repository.saveWatchlist(data);
      // assert
      expect(result, Right('Added to Watchlist'));
    });

    test('should return DatabaseFailure when saving unsuccessful', () async {
      // arrange
      when(localDataSource.insertWatchlist(testMovieTable))
          .thenThrow(DatabaseException('Failed to add watchlist'));
      // act
      final result = await repository.saveWatchlist(data);
      // assert
      expect(result, Left(DatabaseFailure('Failed to add watchlist')));
    });
  });

  group('remove watchlist', () {
    test('should return success message when remove successful', () async {
      // arrange
      when(localDataSource.removeWatchlist(id, dataType.index))
          .thenAnswer((_) async => 'Removed from watchlist');
      // act
      final result = await repository.removeWatchlist(id, dataType.index);
      // assert
      expect(result, Right('Removed from watchlist'));
    });

    test('should return DatabaseFailure when remove unsuccessful', () async {
      // arrange
      when(localDataSource.removeWatchlist(id, dataType.index))
          .thenThrow(DatabaseException('Failed to remove watchlist'));
      // act
      final result = await repository.removeWatchlist(id, dataType.index);
      // assert
      expect(result, Left(DatabaseFailure('Failed to remove watchlist')));
    });
  });

  group('get watchlist status', () {
    test('should return watch status whether data is found', () async {
      // arrange
      when(localDataSource.getMovieById(id, dataType.index))
          .thenAnswer((_) async => null);
      // act
      final result = await repository.isAddedToWatchlist(id, dataType.index);
      // assert
      expect(result, false);
    });
  });

  group('get watchlist movies', () {
    test('should return list of Movies', () async {
      // arrange
      final expected = [IdPosterTitleOverview.fromMovie(testWatchlistMovie)];
      when(localDataSource.getWatchlistMovies())
          .thenAnswer((_) async => [testMovieTable]);
      // act
      final result = await repository.getWatchlist();
      // assert
      final resultList = result.getOrElse(() => []);
      expect(resultList, expected);
    });
  });
}
