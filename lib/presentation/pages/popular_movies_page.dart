import 'package:ditonton/presentation/bloc/popular_movie/popular_movie_bloc.dart';
import 'package:ditonton/presentation/widgets/ditonton_error_widget.dart';
import 'package:ditonton/presentation/widgets/id_poster_title_overview_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PopularMoviesPage extends StatelessWidget {
  static const ROUTE_NAME = '/popular-movie';

  @override
  Widget build(BuildContext context) {
    context.read<PopularMovieBloc>().add(OnPopularMovieDataRequested());

    return Scaffold(
      appBar: AppBar(
        title: Text('Popular Movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<PopularMovieBloc, PopularMovieState>(
          builder: (context, state) {
            if (state is PopularMovieLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is PopularMovieSuccess) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = state.movies[index];

                  return IdPosterTitleOverviewCard(movie);
                },
                itemCount: state.movies.length,
              );
            } else if (state is PopularMovieError) {
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
