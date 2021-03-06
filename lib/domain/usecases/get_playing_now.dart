import 'package:dartz/dartz.dart';
import 'package:moviesapp_flutter/domain/entities/app_error.dart';
import 'package:moviesapp_flutter/domain/entities/movie_entity.dart';
import 'package:moviesapp_flutter/domain/entities/no_params.dart';
import 'package:moviesapp_flutter/domain/repositories/movie_repository.dart';
import 'package:moviesapp_flutter/domain/usecases/usecase.dart';

class GetPlayingNow extends UseCase<List<MovieEntity>, NoParams> {
  final MovieRepository repository;

  GetPlayingNow(this.repository);

  @override
  Future<Either<AppError, List<MovieEntity>>> call(NoParams noParams) async {
    return await repository.getPlayingNow();
  }
}
