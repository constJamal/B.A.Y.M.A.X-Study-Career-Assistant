import 'package:equatable/equatable.dart';

/// User entity representing the authenticated user
class User extends Equatable {
  final String id;
  final String email;
  final String? fullName;
  final String? section;
  final String? major;
  final DateTime createdAt;
  final Map<String, dynamic>? knowledgeGraph;

  const User({
    required this.id,
    required this.email,
    this.fullName,
    this.section,
    this.major,
    required this.createdAt,
    this.knowledgeGraph,
  });

  User copyWith({
    String? id,
    String? email,
    String? fullName,
    String? section,
    String? major,
    DateTime? createdAt,
    Map<String, dynamic>? knowledgeGraph,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      section: section ?? this.section,
      major: major ?? this.major,
      createdAt: createdAt ?? this.createdAt,
      knowledgeGraph: knowledgeGraph ?? this.knowledgeGraph,
    );
  }

  @override
  List<Object?> get props => [
    id,
    email,
    fullName,
    section,
    major,
    createdAt,
    knowledgeGraph,
  ];
}

/// Career path entity
class CareerPath extends Equatable {
  final String title;
  final String summary;
  final List<String> keySkills;
  final List<String> nextSteps;
  final double? relevanceScore;

  const CareerPath({
    required this.title,
    required this.summary,
    required this.keySkills,
    required this.nextSteps,
    this.relevanceScore,
  });

  @override
  List<Object?> get props => [
    title,
    summary,
    keySkills,
    nextSteps,
    relevanceScore,
  ];
}

/// Skill entity
class Skill extends Equatable {
  final String skillName;
  final String description;
  final List<String> learningResources;
  final List<String> practiceProjects;
  final String timeEstimate;
  final List<String>? prerequisites;
  final List<String>? nextSkills;

  const Skill({
    required this.skillName,
    required this.description,
    required this.learningResources,
    required this.practiceProjects,
    required this.timeEstimate,
    this.prerequisites,
    this.nextSkills,
  });

  @override
  List<Object?> get props => [
    skillName,
    description,
    learningResources,
    practiceProjects,
    timeEstimate,
    prerequisites,
    nextSkills,
  ];
}

/// Study buddy summary with source citations
class StudySummary extends Equatable {
  final String summary;
  final List<SourceCitation> citations;
  final String sourceDocumentId;
  final DateTime generatedAt;

  const StudySummary({
    required this.summary,
    required this.citations,
    required this.sourceDocumentId,
    required this.generatedAt,
  });

  @override
  List<Object?> get props => [
    summary,
    citations,
    sourceDocumentId,
    generatedAt,
  ];
}

/// Source citation for RAG-based responses
class SourceCitation extends Equatable {
  final String text;
  final int startIndex;
  final int endIndex;
  final String page;
  final String documentSection;

  const SourceCitation({
    required this.text,
    required this.startIndex,
    required this.endIndex,
    required this.page,
    required this.documentSection,
  });

  @override
  List<Object?> get props => [
    text,
    startIndex,
    endIndex,
    page,
    documentSection,
  ];
}

/// AI-generated roadmap with skill progression
class SkillRoadmap extends Equatable {
  final List<Skill> skills;
  final Map<String, List<String>> skillDependencies;
  final String generatedPrompt;
  final String criticFeedback;

  const SkillRoadmap({
    required this.skills,
    required this.skillDependencies,
    required this.generatedPrompt,
    required this.criticFeedback,
  });

  @override
  List<Object?> get props => [
    skills,
    skillDependencies,
    generatedPrompt,
    criticFeedback,
  ];
}
