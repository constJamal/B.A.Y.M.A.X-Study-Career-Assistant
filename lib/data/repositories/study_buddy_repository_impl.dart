import 'dart:async';
import '../../core/failures/failure.dart';
import '../../core/utils/either.dart';
import '../../domain/entities/entities.dart';
import '../../domain/repositories/repositories.dart';
import '../datasources/ai_remote_datasource.dart';
import '../models/models.dart';

/// Concrete implementation of StudyBuddyRepository
class StudyBuddyRepositoryImpl implements StudyBuddyRepository {
  final AIRemoteDataSource _remoteDataSource;

  StudyBuddyRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, StudySummary>> summarizeDocument(
    String documentPath,
  ) async {
    try {
      final summaryModel = await _remoteDataSource.summarizeDocument(
        documentPath,
      );
      return Right(summaryModel.toEntity());
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(AIServiceFailure(message: e.toString()));
    }
  }

  @override
  Stream<Either<Failure, String>> streamDocumentSummary(
    String documentPath,
  ) async* {
    try {
      yield* _remoteDataSource
          .streamDocumentSummary(documentPath)
          .transform(
            StreamTransformer.fromHandlers(
              handleData: (chunk, sink) {
                sink.add(Right(chunk));
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
  Future<Either<Failure, StudySummary>> queryDocument(
    String documentId,
    String query,
  ) async {
    try {
      final summaryModel = await _remoteDataSource.queryDocument(
        documentId,
        query,
      );
      return Right(summaryModel.toEntity());
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(AIServiceFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> uploadDocument(
    String userId,
    String filePath,
  ) async {
    try {
      final documentId = await _remoteDataSource.uploadDocument(
        filePath,
        userId,
      );
      return Right(documentId);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(AIServiceFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<SourceCitation>>> getSourceCitations(
    String summaryId,
  ) async {
    try {
      final citationModels = await _remoteDataSource.getSourceCitations(
        summaryId,
      );
      final citations = citationModels.map((m) => m.toEntity()).toList();
      return Right(citations);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(AIServiceFailure(message: e.toString()));
    }
  }
}
