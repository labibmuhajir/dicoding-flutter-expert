import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/content_data.dart';
import 'package:ditonton/domain/entities/id_and_data_type.dart';
import 'package:ditonton/domain/entities/id_poster_title_overview.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:ditonton/presentation/provider/watchlist_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'watchlist_movie_notifier_test.mocks.dart';

@GenerateMocks(
    [GetWatchlist, GetWatchListStatus, RemoveWatchlist, SaveWatchlist])
void main() {
  late WatchlistNotifier provider;
  late GetWatchlist getWatchlist;
  late GetWatchListStatus getWatchListStatus;
  late RemoveWatchlist removeWatchlist;
  late SaveWatchlist saveWatchlist;

  setUp(() {
    getWatchlist = MockGetWatchlist();
    getWatchListStatus = MockGetWatchListStatus();
    removeWatchlist = MockRemoveWatchlist();
    saveWatchlist = MockSaveWatchlist();

    provider = WatchlistNotifier(
      getWatchlist: getWatchlist,
      getWatchListStatus: getWatchListStatus,
      removeWatchlist: removeWatchlist,
      saveWatchlist: saveWatchlist,
    );
  });

  final data = [testWatchlistMovie];
  final expected = data.map((e) => IdPosterTitleOverview.fromMovie(e)).toList();

  group("get watch list", () {
    test('should change watchlist data when data is gotten successfully',
        () async {
      // arrange
      when(getWatchlist.execute()).thenAnswer((_) async => Right(expected));
      // act
      await provider.fetchWatchlistMovies();
      // assert
      expect(provider.watchlistState, RequestState.Loaded);
      expect(provider.watchlist, expected);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(getWatchlist.execute())
          .thenAnswer((_) async => Left(DatabaseFailure("Can't get data")));
      // act
      await provider.fetchWatchlistMovies();
      // assert
      expect(provider.watchlistState, RequestState.Error);
      expect(provider.message, "Can't get data");
    });
  });

  group('Watchlist status', () {
    final movie = testMovieDetail;
    final params = IdAndDataType(movie.id, DataType.Movie);

    test('should get the watchlist status and refresh watchlist', () async {
      // arrange
      when(getWatchListStatus.execute(params.id, params.dataType.index))
          .thenAnswer((_) async => true);
      when(getWatchlist.execute()).thenAnswer((_) async => Right(expected));
      // act
      await provider.loadWatchlistStatus(params);
      // assert
      expect(provider.isAddedToWatchlist, true);
      verify(getWatchlist.execute());
    });
  });

  group('Save watchlist', () {
    final movie = testMovieDetail;
    final params = ContentData.fromMovie(movie);
    test('should execute save watchlist when function called', () async {
      // arrange

      when(saveWatchlist.execute(params))
          .thenAnswer((_) async => Right('Success'));
      when(getWatchListStatus.execute(params.id, params.dataType.index))
          .thenAnswer((_) async => true);
      when(getWatchlist.execute()).thenAnswer((_) async => Right(expected));
      // act
      await provider.addWatchlist(params);
      // assert
      verify(saveWatchlist.execute(params));
      verify(getWatchlist.execute());
    });

    test('should update watchlist status when add watchlist success', () async {
      // arrange
      when(saveWatchlist.execute(params))
          .thenAnswer((_) async => Right('Added to Watchlist'));
      when(getWatchListStatus.execute(params.id, params.dataType.index))
          .thenAnswer((_) async => true);
      when(getWatchlist.execute()).thenAnswer((_) async => Right(expected));
      // act
      await provider.addWatchlist(params);
      // assert
      verify(getWatchListStatus.execute(params.id, params.dataType.index));
      expect(provider.isAddedToWatchlist, true);
      expect(provider.message, 'Added to Watchlist');
      verify(getWatchlist.execute());
    });

    test('should update watchlist message when add watchlist failed', () async {
      // arrange
      when(saveWatchlist.execute(params))
          .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
      when(getWatchListStatus.execute(params.id, params.dataType.index))
          .thenAnswer((_) async => false);
      when(getWatchlist.execute()).thenAnswer((_) async => Right(expected));
      // act
      await provider.addWatchlist(params);
      // assert
      expect(provider.message, 'Failed');
      verify(getWatchlist.execute());
    });
  });

  group('remove watchlist', () {
    final movie = testMovieDetail;
    final params = IdAndDataType(movie.id, DataType.Movie);
    test('should execute remove watchlist when function called', () async {
      // arrange
      when(removeWatchlist.execute(params))
          .thenAnswer((_) async => Right('Removed'));
      when(getWatchListStatus.execute(params.id, params.dataType.index))
          .thenAnswer((_) async => false);
      when(getWatchlist.execute()).thenAnswer((_) async => Right(expected));
      // act
      await provider.removeFromWatchlist(params);
      // assert
      verify(removeWatchlist.execute(params));
      verify(getWatchlist.execute());
    });
  });
}
