import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/entities.dart';

part 'models.freezed.dart';
part 'models.g.dart';

@freezed
class SkillModel with _$SkillModel {
  const factory SkillModel({
    required String skillName,
    required String description,
    required List<String> learningResources,
    required List<String> practiceProjects,
    required String timeEstimate,
    List<String>? prerequisites,
    List<String>? nextSkills,
  }) = _SkillModel;

  factory SkillModel.fromJson(Map<String, dynamic> json) =>
      _$SkillModelFromJson(json);

  factory SkillModel.fromEntity(Skill skill) => SkillModel(
    skillName: skill.skillName,
    description: skill.description,
    learningResources: skill.learningResources,
    practiceProjects: skill.practiceProjects,
    timeEstimate: skill.timeEstimate,
    prerequisites: skill.prerequisites,
    nextSkills: skill.nextSkills,
  );
}

extension SkillModelX on SkillModel {
  Skill toEntity() => Skill(
    skillName: skillName,
    description: description,
    learningResources: learningResources,
    practiceProjects: practiceProjects,
    timeEstimate: timeEstimate,
    prerequisites: prerequisites,
    nextSkills: nextSkills,
  );
}

@freezed
class CareerPathModel with _$CareerPathModel {
  const factory CareerPathModel({
    required String title,
    required String summary,
    required List<String> keySkills,
    required List<String> nextSteps,
    double? relevanceScore,
  }) = _CareerPathModel;

  factory CareerPathModel.fromJson(Map<String, dynamic> json) =>
      _$CareerPathModelFromJson(json);

  factory CareerPathModel.fromEntity(CareerPath path) => CareerPathModel(
    title: path.title,
    summary: path.summary,
    keySkills: path.keySkills,
    nextSteps: path.nextSteps,
    relevanceScore: path.relevanceScore,
  );
}

extension CareerPathModelX on CareerPathModel {
  CareerPath toEntity() => CareerPath(
    title: title,
    summary: summary,
    keySkills: keySkills,
    nextSteps: nextSteps,
    relevanceScore: relevanceScore,
  );
}

@freezed
class SourceCitationModel with _$SourceCitationModel {
  const factory SourceCitationModel({
    required String text,
    required int startIndex,
    required int endIndex,
    required String page,
    required String documentSection,
  }) = _SourceCitationModel;

  factory SourceCitationModel.fromJson(Map<String, dynamic> json) =>
      _$SourceCitationModelFromJson(json);

  factory SourceCitationModel.fromEntity(SourceCitation citation) =>
      SourceCitationModel(
        text: citation.text,
        startIndex: citation.startIndex,
        endIndex: citation.endIndex,
        page: citation.page,
        documentSection: citation.documentSection,
      );
}

extension SourceCitationModelX on SourceCitationModel {
  SourceCitation toEntity() => SourceCitation(
    text: text,
    startIndex: startIndex,
    endIndex: endIndex,
    page: page,
    documentSection: documentSection,
  );
}

@freezed
class StudySummaryModel with _$StudySummaryModel {
  const factory StudySummaryModel({
    required String summary,
    required List<SourceCitationModel> citations,
    required String sourceDocumentId,
    required DateTime generatedAt,
  }) = _StudySummaryModel;

  factory StudySummaryModel.fromJson(Map<String, dynamic> json) =>
      _$StudySummaryModelFromJson(json);

  factory StudySummaryModel.fromEntity(StudySummary summary) =>
      StudySummaryModel(
        summary: summary.summary,
        citations: summary.citations
            .map((c) => SourceCitationModel.fromEntity(c))
            .toList(),
        sourceDocumentId: summary.sourceDocumentId,
        generatedAt: summary.generatedAt,
      );
}

extension StudySummaryModelX on StudySummaryModel {
  StudySummary toEntity() => StudySummary(
    summary: summary,
    citations: citations.map((c) => c.toEntity()).toList(),
    sourceDocumentId: sourceDocumentId,
    generatedAt: generatedAt,
  );
}

@freezed
class SkillRoadmapModel with _$SkillRoadmapModel {
  const factory SkillRoadmapModel({
    required List<SkillModel> skills,
    required Map<String, List<String>> skillDependencies,
    required String generatedPrompt,
    required String criticFeedback,
  }) = _SkillRoadmapModel;

  factory SkillRoadmapModel.fromJson(Map<String, dynamic> json) =>
      _$SkillRoadmapModelFromJson(json);

  factory SkillRoadmapModel.fromEntity(SkillRoadmap roadmap) =>
      SkillRoadmapModel(
        skills: roadmap.skills.map((s) => SkillModel.fromEntity(s)).toList(),
        skillDependencies: roadmap.skillDependencies,
        generatedPrompt: roadmap.generatedPrompt,
        criticFeedback: roadmap.criticFeedback,
      );
}

extension SkillRoadmapModelX on SkillRoadmapModel {
  SkillRoadmap toEntity() => SkillRoadmap(
    skills: skills.map((s) => s.toEntity()).toList(),
    skillDependencies: skillDependencies,
    generatedPrompt: generatedPrompt,
    criticFeedback: criticFeedback,
  );
}
