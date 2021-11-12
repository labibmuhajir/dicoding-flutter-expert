import 'package:ditonton/presentation/bloc/top_rated_tv_series/top_rated_tv_series_bloc.dart';
import 'package:ditonton/presentation/widgets/ditonton_error_widget.dart';
import 'package:ditonton/presentation/widgets/id_poster_title_overview_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TopRatedTvSeriesPage extends StatelessWidget {
  static const ROUTE_NAME = '/top-rated-tv-series';

  @override
  Widget build(BuildContext context) {
    context.read<TopRatedTvSeriesBloc>().add(OnTopRatedTvSeriesDataRequested());

    return Scaffold(
      appBar: AppBar(
        title: Text('Top Rated Tv Series'),
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TopRatedTvSeriesBloc, TopRatedTvSeriesState>(
          builder: (context, state) {
            if (state is TopRatedTvSeriesLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is TopRatedTvSeriesSuccess) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = state.tvSeries[index];
                  return IdPosterTitleOverviewCard(movie);
                },
                itemCount: state.tvSeries.length,
              );
            } else if (state is TopRatedTvSeriesError) {
              return DitontonErrorWidget(state.message, retry: state.retry);
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
