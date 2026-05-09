import 'dart:async';
import '../models/models.dart';
import '../../core/failures/failure.dart';
import '../../core/utils/either.dart';
import '../../domain/entities/entities.dart';
import '../../domain/repositories/repositories.dart';
import '../datasources/ai_remote_datasource.dart';

/// Concrete implementation of CareerMappingRepository
class CareerMappingRepositoryImpl implements CareerMappingRepository {
  final AIRemoteDataSource _remoteDataSource;

  CareerMappingRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<CareerPath>>> getCareerPaths(
    String userInput, {
    bool includeMarketTrends = true,
  }) async {
    try {
      final careerPathModels = await _remoteDataSource.getCareerPaths(
        userInput,
      );
      final careerPaths = careerPathModels.map((m) => m.toEntity()).toList();
      return Right(careerPaths);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(AIServiceFailure(message: e.toString()));
    }
  }

  @override
  Stream<Either<Failure, CareerPath>> streamCareerPaths(
    String userInput,
  ) async* {
    try {
      yield* _remoteDataSource
          .streamCareerPaths(userInput)
          .transform(
            StreamTransformer.fromHandlers(
              handleData: (chunk, sink) {
                try {
                  // Parse the streamed chunk as JSON
                  final careerPathModel = CareerPathModel.fromJson(
                    Map<String, dynamic>.from({
                      'title': chunk,
                      'summary': '',
                      'key_skills': [],
                      'next_steps': [],
                    }),
                  );
                  sink.add(Right(careerPathModel.toEntity()));
                } catch (e) {
                  sink.add(Left(AIServiceFailure(message: e.toString())));
                }
              },
              handleError: (error, stack, sink) {
                sink.add(Left(AIServiceFailure(message: error.toString())));
              },
            ),
          );
    } catch (e) {
      yield Left(AIServiceFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CareerPath>>> getNextCareerMoves(
    String userId,
    Map<String, dynamic> knowledgeGraph,
  ) async {
    try {
      // This would call a specialized edge function
      // that uses the knowledge graph to recommend next career moves
      // For now, calling getCareerPaths as a placeholder
      final careerPathModels = await _remoteDataSource.getCareerPaths(
        'recommend next career moves',
      );
      final careerPaths = careerPathModels.map((m) => m.toEntity()).toList();
      return Right(careerPaths);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(AIServiceFailure(message: e.toString()));
    }
  }
}
