import 'package:ditonton/common/extension.dart';
import 'package:ditonton/domain/entities/id_and_data_type.dart';
import 'package:ditonton/domain/entities/id_poster_title_overview.dart';
import 'package:ditonton/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_detail/tv_detail_bloc.dart';
import 'package:ditonton/presentation/widgets/detail_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      context
          .read<MovieDetailBloc>()
          .add(OnMovieDetailDataRequested(widget.idAndDataType.id));
    } else if (widget.idAndDataType.dataType == DataType.TvSeries) {
      context
          .read<TvDetailBloc>()
          .add(OnTvDetailDataRequested(widget.idAndDataType.id));
    }
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
    return BlocConsumer<MovieDetailBloc, MovieDetailState>(
      listener: (context, state) {
        if (state is MovieDetailError) {
          context.dialog(state.message, state.retry);
        }
      },
      builder: (context, state) {
        if (state is MovieDetailLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is MovieDetailSuccess) {
          final movie = state.contentData;
          return SafeArea(
            child: DetailContent(movie),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildTvDetail() {
    return BlocConsumer<TvDetailBloc, TvDetailState>(
      listener: (context, state) {
        if (state is TvDetailError) {
          context.dialog(state.message, state.retry);
        }
      },
      builder: (context, state) {
        if (state is TvDetailLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is TvDetailSuccess) {
          final tv = state.contentData;
          return SafeArea(
            child: DetailContent(tv),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
