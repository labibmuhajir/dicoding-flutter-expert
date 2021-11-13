import 'package:bloc_test/bloc_test.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/content_data.dart';
import 'package:ditonton/domain/entities/id_and_data_type.dart';
import 'package:ditonton/domain/entities/id_poster_data_type.dart';
import 'package:ditonton/domain/entities/id_poster_title_overview.dart';
import 'package:ditonton/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/watchlist_status/watchlist_status_bloc.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../mock/mock_bloc.dart';

void main() {
  late MovieDetailBloc movieDetailBloc;
  late WatchlistStatusBloc watchlistStatusBloc;

  setUp(() {
    movieDetailBloc = MockMovieDetailBloc();
    watchlistStatusBloc = MockWatchListStatusBloc();
  });

  setUpAll(() {
    registerFallbackValue(MovieDetailStateFake());
    registerFallbackValue(MovieDetailEventFake());
    registerFallbackValue(WatchListStatusStateFake());
    registerFallbackValue(WatchListStatusEventFake());
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiProvider(
        providers: [
          BlocProvider(
            create: (_) => movieDetailBloc,
          ),
          BlocProvider(
            create: (context) => watchlistStatusBloc,
          )
        ],
        child: Builder(
          builder: (_) => MaterialApp(home: body),
        ));
  }

  final movieDetail = testMovieDetail;
  final idAndDataType = IdAndDataType(movieDetail.id, DataType.Movie);
  final movieRecommendations = <IdPosterDataType>[];
  final isAddedToWatchList = false;
  final imageUrl = '$BASE_IMAGE_URL${movieDetail.posterPath}';
  final contentData = ContentData.fromMovie(movieDetail);

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    whenListen(movieDetailBloc, Stream.fromIterable([MovieDetailLoading()]),
        initialState: MovieDetailInitial());

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(
        _makeTestableWidget(MovieDetailPage(idAndDataType: idAndDataType)));
    await tester.pump(Duration.zero);

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });
  testWidgets('Should has same data', (WidgetTester tester) async {
    whenListen(
        movieDetailBloc,
        Stream.fromIterable([
          MovieDetailLoading(),
          MovieDetailSuccess(contentData, recommendations: movieRecommendations)
        ]),
        initialState: MovieDetailInitial());
    whenListen(
        watchlistStatusBloc,
        Stream.fromIterable([
          WatchlistStatusLoading(),
          WatchlistStatusLoaded(isAddedToWatchList)
        ]),
        initialState: WatchlistStatusInitial());

    await tester.pumpWidget(
      _makeTestableWidget(MovieDetailPage(idAndDataType: idAndDataType)),
    );
    await tester.pump(Duration.zero);

    expect(find.text(movieDetail.overview), findsOneWidget);
    expect(find.text(movieDetail.title), findsOneWidget);
    final image = find.byType(CachedNetworkImage).evaluate().single.widget
        as CachedNetworkImage;

    expect(image.imageUrl, imageUrl);
  });

  testWidgets('should show ditonton error widget when failure',
      (WidgetTester tester) async {
    whenListen(
        movieDetailBloc,
        Stream.fromIterable([
          MovieDetailLoading(),
          MovieDetailError('Server Failure', retry: () {})
        ]),
        initialState: MovieDetailInitial());
    whenListen(
        watchlistStatusBloc,
        Stream.fromIterable([
          WatchlistStatusLoading(),
          WatchlistStatusLoaded(isAddedToWatchList)
        ]),
        initialState: WatchlistStatusInitial());

    await tester.pumpWidget(
      _makeTestableWidget(MovieDetailPage(idAndDataType: idAndDataType)),
    );
    await tester.pump(Duration.zero);

    expect(find.text('Retry'), findsOneWidget);
  });
}
