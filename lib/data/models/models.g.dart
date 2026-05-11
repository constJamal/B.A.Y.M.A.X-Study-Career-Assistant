// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SkillModelImpl _$$SkillModelImplFromJson(Map<String, dynamic> json) =>
    _$SkillModelImpl(
      skillName: json['skillName'] as String,
      description: json['description'] as String,
      learningResources: (json['learningResources'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      practiceProjects: (json['practiceProjects'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      timeEstimate: json['timeEstimate'] as String,
      prerequisites: (json['prerequisites'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      nextSkills: (json['nextSkills'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$SkillModelImplToJson(_$SkillModelImpl instance) =>
    <String, dynamic>{
      'skillName': instance.skillName,
      'description': instance.description,
      'learningResources': instance.learningResources,
      'practiceProjects': instance.practiceProjects,
      'timeEstimate': instance.timeEstimate,
      'prerequisites': instance.prerequisites,
      'nextSkills': instance.nextSkills,
    };

_$CareerPathModelImpl _$$CareerPathModelImplFromJson(
        Map<String, dynamic> json) =>
    _$CareerPathModelImpl(
      title: json['title'] as String,
      summary: json['summary'] as String,
      keySkills:
          (json['keySkills'] as List<dynamic>).map((e) => e as String).toList(),
      nextSteps:
          (json['nextSteps'] as List<dynamic>).map((e) => e as String).toList(),
      relevanceScore: (json['relevanceScore'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$CareerPathModelImplToJson(
        _$CareerPathModelImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'summary': instance.summary,
      'keySkills': instance.keySkills,
      'nextSteps': instance.nextSteps,
      'relevanceScore': instance.relevanceScore,
    };

_$SkillRoadmapModelImpl _$$SkillRoadmapModelImplFromJson(
        Map<String, dynamic> json) =>
    _$SkillRoadmapModelImpl(
      skills: (json['skills'] as List<dynamic>)
          .map((e) => SkillModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      skillDependencies:
          (json['skillDependencies'] as Map<String, dynamic>).map(
        (k, e) =>
            MapEntry(k, (e as List<dynamic>).map((e) => e as String).toList()),
      ),
      generatedPrompt: json['generatedPrompt'] as String,
      criticFeedback: json['criticFeedback'] as String,
    );

Map<String, dynamic> _$$SkillRoadmapModelImplToJson(
        _$SkillRoadmapModelImpl instance) =>
    <String, dynamic>{
      'skills': instance.skills,
      'skillDependencies': instance.skillDependencies,
      'generatedPrompt': instance.generatedPrompt,
      'criticFeedback': instance.criticFeedback,
    };
