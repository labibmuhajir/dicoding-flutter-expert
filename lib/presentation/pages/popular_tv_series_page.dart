import 'package:ditonton/presentation/bloc/popular_tv_series/popular_tv_series_bloc.dart';
import 'package:ditonton/presentation/widgets/ditonton_error_widget.dart';
import 'package:ditonton/presentation/widgets/id_poster_title_overview_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PopularTvSeriesPage extends StatelessWidget {
  static const ROUTE_NAME = '/popular-tv-series';

  @override
  Widget build(BuildContext context) {
    context.read<PopularTvSeriesBloc>().add(OnPopulartTvSeriesDataRequested());
    
    return Scaffold(
            appBar: AppBar(
              title: Text('Popular Tv Series'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: BlocBuilder<PopularTvSeriesBloc, PopularTvSeriesState>(
                builder: (context, state) {
                  if (state is PopularTvSeriesLoading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is PopularTvSeriesSuccess) {
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        final movie = state.tvSeries[index];
                        return IdPosterTitleOverviewCard(movie);
                      },
                      itemCount: state.tvSeries.length,
                    );
                  } else if (state is PopularTvSeriesError) {
                      return DitontonErrorWidget(state.message, retry: state.retry,);
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          );
  }
}

