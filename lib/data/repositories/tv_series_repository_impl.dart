import 'dart:io';

import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/datasources/tv_remote_data_source.dart';
import 'package:ditonton/data/models/tv_detail_model.dart';
import 'package:ditonton/data/models/tv_series_model.dart';
import 'package:ditonton/common/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/repositories/tv_series_repository.dart';

class TvSeriesRepositoryImpl extends TvSeriesRepository {
  TvRemoteDataSource _dataSource;

  TvSeriesRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, List<TvSeriesModel>>> getOnTheAirTvSeries() async {
    try {
      final result = await _dataSource.getOnTheAirTvSeries();
      return Right(result);
    } on ServerException {
      return Left(ServerFailure());
    } on SocketException {
      return Left(ConnectionFailure());
    } catch (e) {
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, List<TvSeriesModel>>> getPopularTvSeries() async {
    try {
      final result = await _dataSource.getPopularTvSeries();
      return Right(result);
    } on ServerException {
      return Left(ServerFailure());
    } on SocketException {
      return Left(ConnectionFailure());
    } catch (e) {
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, List<TvSeriesModel>>> getTopRatedTvSeries() async {
    try {
      final result = await _dataSource.getTopRatedTvSeries();
      return Right(result);
    } on ServerException {
      return Left(ServerFailure());
    } on SocketException {
      return Left(ConnectionFailure());
    } catch (e) {
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, List<TvSeriesModel>>> searchTvSeries(
      String keyword) async {
    try {
      final result = await _dataSource.searchTvSeries(keyword);
      return Right(result);
    } on ServerException {
      return Left(ServerFailure());
    } on SocketException {
      return Left(ConnectionFailure());
    } catch (e) {
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, TvDetailModel>> getTvSeries(int id) async {
    try {
      final result = await _dataSource.getTvSeries(id);
      return Right(result);
    } on ServerException {
      return Left(ServerFailure());
    } on SocketException {
      return Left(ConnectionFailure());
    } catch (e) {
      return Left(UnknownFailure());
    }
  }
}
