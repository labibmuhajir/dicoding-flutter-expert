import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/extension.dart';
import 'package:ditonton/domain/entities/content_data.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/id_and_data_type.dart';
import 'package:ditonton/domain/entities/id_poster_title_overview.dart';
import 'package:ditonton/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_detail/tv_detail_bloc.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:ditonton/presentation/widgets/ditonton_image.dart';
import 'package:ditonton/presentation/widgets/watchlist_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class DetailContent extends StatelessWidget {
  final ContentData contentData;

  DetailContent(this.contentData);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        DitontonImage(
          contentData.posterPath,
          width: screenWidth,
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: kRichBlack,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 16,
                  right: 16,
                ),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              contentData.title,
                              style: kHeading5,
                            ),
                            WatchlistButton(contentData),
                            Text(
                              _showGenres(contentData.genres),
                            ),
                            Text(
                              _showDuration(
                                  int.fromEnvironment(contentData.runtime)),
                            ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: contentData.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${contentData.voteAverage}')
                              ],
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              contentData.overview,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Recommendations',
                              style: kHeading6,
                            ),
                            if (contentData.dataType == DataType.TvSeries)
                              _buildTvDetail()
                            else
                              _buildMovie()
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    ),
                  ],
                ),
              );
            },
            // initialChildSize: 0.5,
            minChildSize: 0.25,
            // maxChildSize: 1.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        )
      ],
    );
  }

  Widget _buildMovie() {
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
          return Container(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final movies = state.recommendations[index];
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushReplacementNamed(
                        context,
                        MovieDetailPage.ROUTE_NAME,
                        arguments: IdAndDataType.fromIdPosterDataType(movies),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                      child: DitontonImage(movies.poster),
                    ),
                  ),
                );
              },
              itemCount: state.recommendations.length,
            ),
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
          return Container(
            height: 170,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final idPosterDataType = state.recommendations[index];
                return Container(
                  width: 120,
                  padding: const EdgeInsets.all(4.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushReplacementNamed(
                        context,
                        MovieDetailPage.ROUTE_NAME,
                        arguments: IdAndDataType.fromIdPosterDataType(
                            idPosterDataType),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                      child: DitontonImage(idPosterDataType.poster),
                    ),
                  ),
                );
              },
              itemCount: state.recommendations.length,
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += genre.name + ', ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }

  String _showDuration(int runtime) {
    final int hours = runtime ~/ 60;
    final int minutes = runtime % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
}
