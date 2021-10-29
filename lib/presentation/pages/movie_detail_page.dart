import 'package:ditonton/domain/entities/content_data.dart';
import 'package:ditonton/domain/entities/id_and_data_type.dart';
import 'package:ditonton/domain/entities/id_poster_title_overview.dart';
import 'package:ditonton/presentation/provider/movie_detail_notifier.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/provider/tv_detail_notifier.dart';
import 'package:ditonton/presentation/provider/watchlist_notifier.dart';
import 'package:ditonton/presentation/widgets/detail_content.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MovieDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/detail';

  final IdAndDataType idAndDataType;

  MovieDetailPage({required this.idAndDataType});

  @override
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  @override
  void initState() {
    super.initState();
    if (widget.idAndDataType.dataType == DataType.Movie) {
      Future.microtask(() {
        Provider.of<MovieDetailNotifier>(context, listen: false)
            .fetchMovieDetail(widget.idAndDataType.id);
      });
    } else if (widget.idAndDataType.dataType == DataType.TvSeries) {
      Future.microtask(() {
        Provider.of<TvDetailNotifier>(context, listen: false)
            .fetchTvDetail(widget.idAndDataType.id);
      });
    }

    Provider.of<WatchlistNotifier>(context, listen: false)
        .loadWatchlistStatus(widget.idAndDataType);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.idAndDataType.dataType == DataType.TvSeries
          ? _buildTvDetail()
          : _buildMovieDetail(),
    );
  }

  Widget _buildMovieDetail() {
    return Consumer<MovieDetailNotifier>(
      builder: (context, provider, child) {
        if (provider.movieState == RequestState.Loading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (provider.movieState == RequestState.Loaded) {
          final movie = provider.movie;
          return SafeArea(
            child: DetailContent(
              ContentData.fromMovie(movie),
            ),
          );
        } else {
          return Text(provider.message);
        }
      },
    );
  }

  Widget _buildTvDetail() {
    return Consumer<TvDetailNotifier>(
      builder: (context, provider, child) {
        if (provider.tvSeriesState == RequestState.Loading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (provider.tvSeriesState == RequestState.Loaded) {
          final movie = provider.tvSeries;
          return SafeArea(
            child: DetailContent(
              movie,
            ),
          );
        } else {
          return Text(provider.message);
        }
      },
    );
  }
}
