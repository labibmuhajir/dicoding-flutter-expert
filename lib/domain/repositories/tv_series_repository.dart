import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/data/models/tv_detail_model.dart';
import 'package:ditonton/data/models/tv_series_model.dart';

abstract class TvSeriesRepository {
  Future<Either<Failure, List<TvSeriesModel>>> getOnTheAirTvSeries();
  Future<Either<Failure, List<TvSeriesModel>>> getPopularTvSeries();
  Future<Either<Failure, List<TvSeriesModel>>> getTopRatedTvSeries();
  Future<Either<Failure, List<TvSeriesModel>>> searchTvSeries(String keyword);
  Future<Either<Failure, TvDetailModel>> getTvSeries(int id);
  Future<Either<Failure, List<TvSeriesModel>>> getTvSeriesRecommendation(
      int id);
}
