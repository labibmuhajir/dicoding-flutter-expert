import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/id_poster_title_overview.dart';
import 'package:ditonton/presentation/widgets/id_poster_title_overview_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  Widget _makeTestableWidget(Widget body) {
    return MaterialApp(
      home: Scaffold(
        body: body,
      ),
    );
  }

  final movie = testMovieDetail;
  final idPosterTitleOverview = IdPosterTitleOverview.fromMovieDetail(movie);
  final imageUrl = '$BASE_IMAGE_URL${idPosterTitleOverview.poster}';

  testWidgets('IdPosterTitleOvervieCard should show right data',
      (WidgetTester tester) async {
    await tester.pumpWidget(
        _makeTestableWidget(IdPosterTitleOverviewCard(idPosterTitleOverview)));

    expect(find.text(idPosterTitleOverview.overview), findsOneWidget);
    expect(find.text(idPosterTitleOverview.title), findsOneWidget);
    final image = find.byType(CachedNetworkImage).evaluate().single.widget
        as CachedNetworkImage;

    expect(image.imageUrl, imageUrl);
  });
}
