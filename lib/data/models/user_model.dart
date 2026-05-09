import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/entities.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String email,
    String? fullName,
    String? section,
    String? major,
    required DateTime createdAt,
    Map<String, dynamic>? knowledgeGraph,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  factory UserModel.fromEntity(User user) => UserModel(
    id: user.id,
    email: user.email,
    fullName: user.fullName,
    section: user.section,
    major: user.major,
    createdAt: user.createdAt,
    knowledgeGraph: user.knowledgeGraph,
  );
}

extension UserModelX on UserModel {
  User toEntity() => User(
    id: id,
    email: email,
    fullName: fullName,
    section: section,
    major: major,
    createdAt: createdAt,
    knowledgeGraph: knowledgeGraph,
  );
}
