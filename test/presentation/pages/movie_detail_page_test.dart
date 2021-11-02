import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/content_data.dart';
import 'package:ditonton/domain/entities/id_and_data_type.dart';
import 'package:ditonton/domain/entities/id_poster_data_type.dart';
import 'package:ditonton/domain/entities/id_poster_title_overview.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:ditonton/presentation/provider/movie_detail_notifier.dart';
import 'package:ditonton/presentation/provider/tv_detail_notifier.dart';
import 'package:ditonton/presentation/provider/watchlist_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../dummy_data/dummy_objects.dart';
import '../widgets.dart/watchlist_button_test.mocks.dart';
import 'movie_detail_page_test.mocks.dart';

@GenerateMocks([TvDetailNotifier, MovieDetailNotifier])
main() {
  late MovieDetailNotifier movieDetailNotifier;
  late TvDetailNotifier tvDetailNotifier;
  late WatchlistNotifier watchlistNotifier;

  setUp(() {
    movieDetailNotifier = MockMovieDetailNotifier();
    tvDetailNotifier = MockTvDetailNotifier();
    watchlistNotifier = MockWatchlistNotifier();
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => movieDetailNotifier,
          ),
          ChangeNotifierProvider(
            create: (_) => tvDetailNotifier,
          ),
          ChangeNotifierProvider(
            create: (_) => watchlistNotifier,
          ),
        ],
        child: Builder(
          builder: (_) => MaterialApp(home: body),
        ));
  }

  testWidgets('Should call fetchMovieDetail when DataType.Movie',
      (WidgetTester tester) async {
    final movieDetail = testMovieDetail;
    final idAndDataType = IdAndDataType(movieDetail.id, DataType.Movie);
    final id = idAndDataType.id;
    final movieRecommendations = <Movie>[];
    final isAddedToWatchList = false;
    final imageUrl = '$BASE_IMAGE_URL${movieDetail.posterPath}';

    when(movieDetailNotifier.movieState).thenReturn(RequestState.Loaded);
    when(movieDetailNotifier.movie).thenReturn(movieDetail);
    when(movieDetailNotifier.recommendationState)
        .thenReturn(RequestState.Loaded);
    when(movieDetailNotifier.movieRecommendations)
        .thenReturn(movieRecommendations);
    when(watchlistNotifier.isAddedToWatchlist).thenReturn(isAddedToWatchList);

    await tester.pumpWidget(
        _makeTestableWidget(MovieDetailPage(idAndDataType: idAndDataType)));

    verify(movieDetailNotifier.fetchMovieDetail(id));
    verify(watchlistNotifier.loadWatchlistStatus(idAndDataType));

    expect(find.text(movieDetail.overview), findsOneWidget);
    expect(find.text(movieDetail.title), findsOneWidget);
    final image = find.byType(CachedNetworkImage).evaluate().single.widget
        as CachedNetworkImage;

    expect(image.imageUrl, imageUrl);
  });

  testWidgets('Should call fetchTvDetail when DataType.Movie',
      (WidgetTester tester) async {
    final tvDetail = tTvDetail;
    final contentData = ContentData.fromTvSeries(tvDetail);
    final idAndDataType = IdAndDataType(tvDetail.id, DataType.TvSeries);
    final id = idAndDataType.id;
    final movieRecommendations = <IdPosterDataType>[];
    final isAddedToWatchList = false;
    final imageUrl = '$BASE_IMAGE_URL${tvDetail.posterPath}';

    when(tvDetailNotifier.tvSeriesState).thenReturn(RequestState.Loaded);
    when(tvDetailNotifier.tvSeries).thenReturn(contentData);
    when(tvDetailNotifier.recommendationState).thenReturn(RequestState.Loaded);
    when(tvDetailNotifier.recommendations).thenReturn(movieRecommendations);
    when(watchlistNotifier.isAddedToWatchlist).thenReturn(isAddedToWatchList);

    await tester.pumpWidget(
        _makeTestableWidget(MovieDetailPage(idAndDataType: idAndDataType)));

    verify(tvDetailNotifier.fetchTvDetail(id));
    verify(watchlistNotifier.loadWatchlistStatus(idAndDataType));

    expect(find.text(tvDetail.overview), findsOneWidget);
    expect(find.text(tvDetail.name), findsOneWidget);
    final image = find.byType(CachedNetworkImage).evaluate().single.widget
        as CachedNetworkImage;

    expect(image.imageUrl, imageUrl);
  });
}
