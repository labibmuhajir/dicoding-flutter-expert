// Mocks generated by Mockito 5.0.8 from annotations
// in ditonton/test/presentation/provider/tv_detail_notifier_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i5;

import 'package:dartz/dartz.dart' as _i3;
import 'package:ditonton/common/failure.dart' as _i6;
import 'package:ditonton/data/models/tv_detail_model.dart' as _i7;
import 'package:ditonton/data/models/tv_series_model.dart' as _i9;
import 'package:ditonton/domain/repositories/tv_series_repository.dart' as _i2;
import 'package:ditonton/domain/usecases/get_tv_series_detail.dart' as _i4;
import 'package:ditonton/domain/usecases/get_tv_series_recommendations.dart'
    as _i8;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: comment_references
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis

class _FakeTvSeriesRepository extends _i1.Fake
    implements _i2.TvSeriesRepository {}

class _FakeEither<L, R> extends _i1.Fake implements _i3.Either<L, R> {}

/// A class which mocks [GetTvSeriesDetail].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetTvSeriesDetail extends _i1.Mock implements _i4.GetTvSeriesDetail {
  MockGetTvSeriesDetail() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.TvSeriesRepository get repository =>
      (super.noSuchMethod(Invocation.getter(#repository),
          returnValue: _FakeTvSeriesRepository()) as _i2.TvSeriesRepository);
  @override
  _i5.Future<_i3.Either<_i6.Failure, _i7.TvDetailModel>> execute(int? id) =>
      (super.noSuchMethod(Invocation.method(#execute, [id]),
          returnValue: Future<_i3.Either<_i6.Failure, _i7.TvDetailModel>>.value(
              _FakeEither<_i6.Failure, _i7.TvDetailModel>())) as _i5
          .Future<_i3.Either<_i6.Failure, _i7.TvDetailModel>>);
}

/// A class which mocks [GetTvSeriesRecommendations].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetTvSeriesRecommendations extends _i1.Mock
    implements _i8.GetTvSeriesRecommendations {
  MockGetTvSeriesRecommendations() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.TvSeriesRepository get repository =>
      (super.noSuchMethod(Invocation.getter(#repository),
          returnValue: _FakeTvSeriesRepository()) as _i2.TvSeriesRepository);
  @override
  _i5.Future<_i3.Either<_i6.Failure, List<_i9.TvSeriesModel>>> execute(
          dynamic id) =>
      (super.noSuchMethod(Invocation.method(#execute, [id]),
          returnValue:
              Future<_i3.Either<_i6.Failure, List<_i9.TvSeriesModel>>>.value(
                  _FakeEither<_i6.Failure, List<_i9.TvSeriesModel>>())) as _i5
          .Future<_i3.Either<_i6.Failure, List<_i9.TvSeriesModel>>>);
}
