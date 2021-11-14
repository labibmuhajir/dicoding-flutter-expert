import 'package:ditonton/common/constants.dart';
import 'package:ditonton/presentation/bloc/now_playing_movie/now_playing_movie_bloc.dart';
import 'package:ditonton/presentation/bloc/on_the_air_tv_series/on_the_air_tv_series_bloc.dart';
import 'package:ditonton/presentation/bloc/popular_movie/popular_movie_bloc.dart';
import 'package:ditonton/presentation/bloc/popular_tv_series/popular_tv_series_bloc.dart';
import 'package:ditonton/presentation/bloc/top_rated_movie/top_rated_movie_bloc.dart';
import 'package:ditonton/presentation/bloc/top_rated_tv_series/top_rated_tv_series_bloc.dart';
import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:ditonton/presentation/pages/popular_movies_page.dart';
import 'package:ditonton/presentation/pages/popular_tv_series_page.dart';
import 'package:ditonton/presentation/pages/search_page.dart';
import 'package:ditonton/presentation/pages/top_rated_movies_page.dart';
import 'package:ditonton/presentation/pages/top_rated_tv_series_page.dart';
import 'package:ditonton/presentation/pages/watchlist_page.dart';
import 'package:ditonton/presentation/widgets/ditonton_error_widget.dart';
import 'package:ditonton/presentation/widgets/movie_list.dart';
import 'package:ditonton/presentation/widgets/row_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class HomeMoviePage extends StatefulWidget {
  static const ROUTE_NAME = '/home';

  @override
  _HomeMoviePageState createState() => _HomeMoviePageState();
}

enum HomeState { TvSeries, Movies }

class _HomeMoviePageState extends State<HomeMoviePage> {
  HomeState state = HomeState.Movies;

  @override
  Widget build(BuildContext context) {
    if (state == HomeState.TvSeries) {
      _getTvSeriesData(context);
    } else {
      _getMovieData(context);
    }

    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/circle-g.png'),
              ),
              accountName: Text('Ditonton'),
              accountEmail: Text('ditonton@dicoding.com'),
            ),
            ListTile(
              leading: Icon(Icons.movie),
              title: Text('Movies'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  state = HomeState.Movies;
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.movie),
              title: Text('Tv Series'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  state = HomeState.TvSeries;
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.save_alt),
              title: Text('Watchlist'),
              onTap: () {
                Navigator.pushNamed(context, WatchlistPage.ROUTE_NAME);
              },
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, AboutPage.ROUTE_NAME);
              },
              leading: Icon(Icons.info_outline),
              title: Text('About'),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Ditonton ${state == HomeState.Movies ? 'Movie' : 'Tv'}'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, SearchPage.ROUTE_NAME,
                  arguments: state);
            },
            icon: Icon(Icons.search),
          )
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              state == HomeState.TvSeries ? _buildTvSeries() : _buildMovies()),
    );
  }

  Row _buildSubHeading({required String title, required Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: kHeading6,
        ),
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }

  SingleChildScrollView _buildMovies() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Now Playing',
            style: kHeading6,
          ),
          BlocBuilder<NowPlayingMovieBloc, NowPlayingMovieState>(
              builder: (context, state) {
            if (state is NowPlayingMovieLoading) {
              return RowLoading();
            } else if (state is NowPlayingMovieSuccess) {
              return MovieList(state.movies);
            } else if (state is NowPlayingMovieError) {
              return DitontonErrorWidget(state.message, retry: state.retry);
            } else {
              return Container();
            }
          }),
          _buildSubHeading(
            title: 'Popular',
            onTap: () =>
                Navigator.pushNamed(context, PopularMoviesPage.ROUTE_NAME),
          ),
          BlocBuilder<PopularMovieBloc, PopularMovieState>(
              builder: (context, state) {
            if (state is PopularMovieLoading) {
              return RowLoading();
            } else if (state is PopularMovieSuccess) {
              return MovieList.fromIdPosterTitleOverview(state.movies);
            } else if (state is PopularMovieError) {
              return DitontonErrorWidget(state.message, retry: state.retry);
            } else {
              return Container();
            }
          }),
          _buildSubHeading(
            title: 'Top Rated',
            onTap: () =>
                Navigator.pushNamed(context, TopRatedMoviesPage.ROUTE_NAME),
          ),
          BlocBuilder<TopRatedMovieBloc, TopRatedMovieState>(
              builder: (context, state) {
            if (state is TopRatedMovieLoading) {
              return RowLoading();
            } else if (state is TopRatedMovieSuccess) {
              return MovieList.fromIdPosterTitleOverview(state.movies);
            } else if (state is TopRatedMovieError) {
              return DitontonErrorWidget(
                state.message,
                retry: state.retry,
              );
            } else {
              return Container();
            }
          }),
        ],
      ),
    );
  }

  SingleChildScrollView _buildTvSeries() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'On The Air Tv Series',
            style: kHeading6,
          ),
          BlocBuilder<OnTheAirTvSeriesBloc, OnTheAirTvSeriesState>(
              builder: (context, state) {
            if (state is OnTheAirTvSeriesLoading) {
              return RowLoading();
            } else if (state is OnTheAirTvSeriesSuccess) {
              return MovieList(state.tvSeries);
            } else if (state is OnTheAirTvSeriesError) {
              return DitontonErrorWidget(state.message, retry: state.retry);
            } else {
              return Container();
            }
          }),
          _buildSubHeading(
            title: 'Popular Tv Series',
            onTap: () =>
                Navigator.pushNamed(context, PopularTvSeriesPage.ROUTE_NAME),
          ),
          BlocBuilder<PopularTvSeriesBloc, PopularTvSeriesState>(
              builder: (context, state) {
            if (state is PopularTvSeriesLoading) {
              return RowLoading();
            } else if (state is PopularTvSeriesSuccess) {
              return MovieList.fromIdPosterTitleOverview(state.tvSeries);
            } else if (state is PopularTvSeriesError) {
              return DitontonErrorWidget(state.message, retry: state.retry);
            } else {
              return Container();
            }
          }),
          _buildSubHeading(
            title: 'Top Rated',
            onTap: () =>
                Navigator.pushNamed(context, TopRatedTvSeriesPage.ROUTE_NAME),
          ),
          BlocBuilder<TopRatedTvSeriesBloc, TopRatedTvSeriesState>(
              builder: (context, state) {
            if (state is TopRatedTvSeriesLoading) {
              return RowLoading();
            } else if (state is TopRatedTvSeriesSuccess) {
              return MovieList.fromIdPosterTitleOverview(state.tvSeries);
            } else if (state is TopRatedTvSeriesError) {
              return DitontonErrorWidget(state.message, retry: state.retry);
            } else {
              return Container();
            }
          }),
        ],
      ),
    );
  }

  void _getTvSeriesData(BuildContext context) {
    context
      ..read<OnTheAirTvSeriesBloc>().add(OnTheAirTvSeriesDataRequested())
      ..read<PopularTvSeriesBloc>().add(OnPopulartTvSeriesDataRequested())
      ..read<TopRatedTvSeriesBloc>().add(OnTopRatedTvSeriesDataRequested());
  }

  void _getMovieData(BuildContext context) {
    context
      ..read<NowPlayingMovieBloc>().add(OnNowPlayingMovieDataRequested())
      ..read<PopularMovieBloc>().add(OnPopularMovieDataRequested())
      ..read<TopRatedMovieBloc>().add(OnTopRatedMovieDataRequested());
  }
}
