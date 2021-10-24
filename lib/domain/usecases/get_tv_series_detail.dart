import 'package:dartz/dartz.dart';
import 'package:ditonton/data/models/tv_detail_model.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/repositories/tv_series_repository.dart';

class GetTvSeriesDetail {
  final TvSeriesRepository repository;

  GetTvSeriesDetail(this.repository);

  Future<Either<Failure, TvDetailModel>> execute(int id) {
    return repository.getTvSeries(id);
  }
}
