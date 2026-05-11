// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SkillModel _$SkillModelFromJson(Map<String, dynamic> json) {
  return _SkillModel.fromJson(json);
}

/// @nodoc
mixin _$SkillModel {
  String get skillName => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  List<String> get learningResources => throw _privateConstructorUsedError;
  List<String> get practiceProjects => throw _privateConstructorUsedError;
  String get timeEstimate => throw _privateConstructorUsedError;
  List<String>? get prerequisites => throw _privateConstructorUsedError;
  List<String>? get nextSkills => throw _privateConstructorUsedError;

  /// Serializes this SkillModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SkillModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SkillModelCopyWith<SkillModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SkillModelCopyWith<$Res> {
  factory $SkillModelCopyWith(
          SkillModel value, $Res Function(SkillModel) then) =
      _$SkillModelCopyWithImpl<$Res, SkillModel>;
  @useResult
  $Res call(
      {String skillName,
      String description,
      List<String> learningResources,
      List<String> practiceProjects,
      String timeEstimate,
      List<String>? prerequisites,
      List<String>? nextSkills});
}

/// @nodoc
class _$SkillModelCopyWithImpl<$Res, $Val extends SkillModel>
    implements $SkillModelCopyWith<$Res> {
  _$SkillModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SkillModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? skillName = null,
    Object? description = null,
    Object? learningResources = null,
    Object? practiceProjects = null,
    Object? timeEstimate = null,
    Object? prerequisites = freezed,
    Object? nextSkills = freezed,
  }) {
    return _then(_value.copyWith(
      skillName: null == skillName
          ? _value.skillName
          : skillName // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      learningResources: null == learningResources
          ? _value.learningResources
          : learningResources // ignore: cast_nullable_to_non_nullable
              as List<String>,
      practiceProjects: null == practiceProjects
          ? _value.practiceProjects
          : practiceProjects // ignore: cast_nullable_to_non_nullable
              as List<String>,
      timeEstimate: null == timeEstimate
          ? _value.timeEstimate
          : timeEstimate // ignore: cast_nullable_to_non_nullable
              as String,
      prerequisites: freezed == prerequisites
          ? _value.prerequisites
          : prerequisites // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      nextSkills: freezed == nextSkills
          ? _value.nextSkills
          : nextSkills // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SkillModelImplCopyWith<$Res>
    implements $SkillModelCopyWith<$Res> {
  factory _$$SkillModelImplCopyWith(
          _$SkillModelImpl value, $Res Function(_$SkillModelImpl) then) =
      __$$SkillModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String skillName,
      String description,
      List<String> learningResources,
      List<String> practiceProjects,
      String timeEstimate,
      List<String>? prerequisites,
      List<String>? nextSkills});
}

/// @nodoc
class __$$SkillModelImplCopyWithImpl<$Res>
    extends _$SkillModelCopyWithImpl<$Res, _$SkillModelImpl>
    implements _$$SkillModelImplCopyWith<$Res> {
  __$$SkillModelImplCopyWithImpl(
      _$SkillModelImpl _value, $Res Function(_$SkillModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of SkillModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? skillName = null,
    Object? description = null,
    Object? learningResources = null,
    Object? practiceProjects = null,
    Object? timeEstimate = null,
    Object? prerequisites = freezed,
    Object? nextSkills = freezed,
  }) {
    return _then(_$SkillModelImpl(
      skillName: null == skillName
          ? _value.skillName
          : skillName // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      learningResources: null == learningResources
          ? _value._learningResources
          : learningResources // ignore: cast_nullable_to_non_nullable
              as List<String>,
      practiceProjects: null == practiceProjects
          ? _value._practiceProjects
          : practiceProjects // ignore: cast_nullable_to_non_nullable
              as List<String>,
      timeEstimate: null == timeEstimate
          ? _value.timeEstimate
          : timeEstimate // ignore: cast_nullable_to_non_nullable
              as String,
      prerequisites: freezed == prerequisites
          ? _value._prerequisites
          : prerequisites // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      nextSkills: freezed == nextSkills
          ? _value._nextSkills
          : nextSkills // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SkillModelImpl implements _SkillModel {
  const _$SkillModelImpl(
      {required this.skillName,
      required this.description,
      required final List<String> learningResources,
      required final List<String> practiceProjects,
      required this.timeEstimate,
      final List<String>? prerequisites,
      final List<String>? nextSkills})
      : _learningResources = learningResources,
        _practiceProjects = practiceProjects,
        _prerequisites = prerequisites,
        _nextSkills = nextSkills;

  factory _$SkillModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SkillModelImplFromJson(json);

  @override
  final String skillName;
  @override
  final String description;
  final List<String> _learningResources;
  @override
  List<String> get learningResources {
    if (_learningResources is EqualUnmodifiableListView)
      return _learningResources;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_learningResources);
  }

  final List<String> _practiceProjects;
  @override
  List<String> get practiceProjects {
    if (_practiceProjects is EqualUnmodifiableListView)
      return _practiceProjects;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_practiceProjects);
  }

  @override
  final String timeEstimate;
  final List<String>? _prerequisites;
  @override
  List<String>? get prerequisites {
    final value = _prerequisites;
    if (value == null) return null;
    if (_prerequisites is EqualUnmodifiableListView) return _prerequisites;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _nextSkills;
  @override
  List<String>? get nextSkills {
    final value = _nextSkills;
    if (value == null) return null;
    if (_nextSkills is EqualUnmodifiableListView) return _nextSkills;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'SkillModel(skillName: $skillName, description: $description, learningResources: $learningResources, practiceProjects: $practiceProjects, timeEstimate: $timeEstimate, prerequisites: $prerequisites, nextSkills: $nextSkills)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SkillModelImpl &&
            (identical(other.skillName, skillName) ||
                other.skillName == skillName) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality()
                .equals(other._learningResources, _learningResources) &&
            const DeepCollectionEquality()
                .equals(other._practiceProjects, _practiceProjects) &&
            (identical(other.timeEstimate, timeEstimate) ||
                other.timeEstimate == timeEstimate) &&
            const DeepCollectionEquality()
                .equals(other._prerequisites, _prerequisites) &&
            const DeepCollectionEquality()
                .equals(other._nextSkills, _nextSkills));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      skillName,
      description,
      const DeepCollectionEquality().hash(_learningResources),
      const DeepCollectionEquality().hash(_practiceProjects),
      timeEstimate,
      const DeepCollectionEquality().hash(_prerequisites),
      const DeepCollectionEquality().hash(_nextSkills));

  /// Create a copy of SkillModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SkillModelImplCopyWith<_$SkillModelImpl> get copyWith =>
      __$$SkillModelImplCopyWithImpl<_$SkillModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SkillModelImplToJson(
      this,
    );
  }
}

abstract class _SkillModel implements SkillModel {
  const factory _SkillModel(
      {required final String skillName,
      required final String description,
      required final List<String> learningResources,
      required final List<String> practiceProjects,
      required final String timeEstimate,
      final List<String>? prerequisites,
      final List<String>? nextSkills}) = _$SkillModelImpl;

  factory _SkillModel.fromJson(Map<String, dynamic> json) =
      _$SkillModelImpl.fromJson;

  @override
  String get skillName;
  @override
  String get description;
  @override
  List<String> get learningResources;
  @override
  List<String> get practiceProjects;
  @override
  String get timeEstimate;
  @override
  List<String>? get prerequisites;
  @override
  List<String>? get nextSkills;

  /// Create a copy of SkillModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SkillModelImplCopyWith<_$SkillModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CareerPathModel _$CareerPathModelFromJson(Map<String, dynamic> json) {
  return _CareerPathModel.fromJson(json);
}

/// @nodoc
mixin _$CareerPathModel {
  String get title => throw _privateConstructorUsedError;
  String get summary => throw _privateConstructorUsedError;
  List<String> get keySkills => throw _privateConstructorUsedError;
  List<String> get nextSteps => throw _privateConstructorUsedError;
  double? get relevanceScore => throw _privateConstructorUsedError;

  /// Serializes this CareerPathModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CareerPathModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CareerPathModelCopyWith<CareerPathModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CareerPathModelCopyWith<$Res> {
  factory $CareerPathModelCopyWith(
          CareerPathModel value, $Res Function(CareerPathModel) then) =
      _$CareerPathModelCopyWithImpl<$Res, CareerPathModel>;
  @useResult
  $Res call(
      {String title,
      String summary,
      List<String> keySkills,
      List<String> nextSteps,
      double? relevanceScore});
}

/// @nodoc
class _$CareerPathModelCopyWithImpl<$Res, $Val extends CareerPathModel>
    implements $CareerPathModelCopyWith<$Res> {
  _$CareerPathModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CareerPathModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? summary = null,
    Object? keySkills = null,
    Object? nextSteps = null,
    Object? relevanceScore = freezed,
  }) {
    return _then(_value.copyWith(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      summary: null == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as String,
      keySkills: null == keySkills
          ? _value.keySkills
          : keySkills // ignore: cast_nullable_to_non_nullable
              as List<String>,
      nextSteps: null == nextSteps
          ? _value.nextSteps
          : nextSteps // ignore: cast_nullable_to_non_nullable
              as List<String>,
      relevanceScore: freezed == relevanceScore
          ? _value.relevanceScore
          : relevanceScore // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CareerPathModelImplCopyWith<$Res>
    implements $CareerPathModelCopyWith<$Res> {
  factory _$$CareerPathModelImplCopyWith(_$CareerPathModelImpl value,
          $Res Function(_$CareerPathModelImpl) then) =
      __$$CareerPathModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String title,
      String summary,
      List<String> keySkills,
      List<String> nextSteps,
      double? relevanceScore});
}

/// @nodoc
class __$$CareerPathModelImplCopyWithImpl<$Res>
    extends _$CareerPathModelCopyWithImpl<$Res, _$CareerPathModelImpl>
    implements _$$CareerPathModelImplCopyWith<$Res> {
  __$$CareerPathModelImplCopyWithImpl(
      _$CareerPathModelImpl _value, $Res Function(_$CareerPathModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of CareerPathModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? summary = null,
    Object? keySkills = null,
    Object? nextSteps = null,
    Object? relevanceScore = freezed,
  }) {
    return _then(_$CareerPathModelImpl(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      summary: null == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as String,
      keySkills: null == keySkills
          ? _value._keySkills
          : keySkills // ignore: cast_nullable_to_non_nullable
              as List<String>,
      nextSteps: null == nextSteps
          ? _value._nextSteps
          : nextSteps // ignore: cast_nullable_to_non_nullable
              as List<String>,
      relevanceScore: freezed == relevanceScore
          ? _value.relevanceScore
          : relevanceScore // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CareerPathModelImpl implements _CareerPathModel {
  const _$CareerPathModelImpl(
      {required this.title,
      required this.summary,
      required final List<String> keySkills,
      required final List<String> nextSteps,
      this.relevanceScore})
      : _keySkills = keySkills,
        _nextSteps = nextSteps;

  factory _$CareerPathModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CareerPathModelImplFromJson(json);

  @override
  final String title;
  @override
  final String summary;
  final List<String> _keySkills;
  @override
  List<String> get keySkills {
    if (_keySkills is EqualUnmodifiableListView) return _keySkills;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_keySkills);
  }

  final List<String> _nextSteps;
  @override
  List<String> get nextSteps {
    if (_nextSteps is EqualUnmodifiableListView) return _nextSteps;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_nextSteps);
  }

  @override
  final double? relevanceScore;

  @override
  String toString() {
    return 'CareerPathModel(title: $title, summary: $summary, keySkills: $keySkills, nextSteps: $nextSteps, relevanceScore: $relevanceScore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CareerPathModelImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.summary, summary) || other.summary == summary) &&
            const DeepCollectionEquality()
                .equals(other._keySkills, _keySkills) &&
            const DeepCollectionEquality()
                .equals(other._nextSteps, _nextSteps) &&
            (identical(other.relevanceScore, relevanceScore) ||
                other.relevanceScore == relevanceScore));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      title,
      summary,
      const DeepCollectionEquality().hash(_keySkills),
      const DeepCollectionEquality().hash(_nextSteps),
      relevanceScore);

  /// Create a copy of CareerPathModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CareerPathModelImplCopyWith<_$CareerPathModelImpl> get copyWith =>
      __$$CareerPathModelImplCopyWithImpl<_$CareerPathModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CareerPathModelImplToJson(
      this,
    );
  }
}

abstract class _CareerPathModel implements CareerPathModel {
  const factory _CareerPathModel(
      {required final String title,
      required final String summary,
      required final List<String> keySkills,
      required final List<String> nextSteps,
      final double? relevanceScore}) = _$CareerPathModelImpl;

  factory _CareerPathModel.fromJson(Map<String, dynamic> json) =
      _$CareerPathModelImpl.fromJson;

  @override
  String get title;
  @override
  String get summary;
  @override
  List<String> get keySkills;
  @override
  List<String> get nextSteps;
  @override
  double? get relevanceScore;

  /// Create a copy of CareerPathModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CareerPathModelImplCopyWith<_$CareerPathModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SkillRoadmapModel _$SkillRoadmapModelFromJson(Map<String, dynamic> json) {
  return _SkillRoadmapModel.fromJson(json);
}

/// @nodoc
mixin _$SkillRoadmapModel {
  List<SkillModel> get skills => throw _privateConstructorUsedError;
  Map<String, List<String>> get skillDependencies =>
      throw _privateConstructorUsedError;
  String get generatedPrompt => throw _privateConstructorUsedError;
  String get criticFeedback => throw _privateConstructorUsedError;

  /// Serializes this SkillRoadmapModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SkillRoadmapModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SkillRoadmapModelCopyWith<SkillRoadmapModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SkillRoadmapModelCopyWith<$Res> {
  factory $SkillRoadmapModelCopyWith(
          SkillRoadmapModel value, $Res Function(SkillRoadmapModel) then) =
      _$SkillRoadmapModelCopyWithImpl<$Res, SkillRoadmapModel>;
  @useResult
  $Res call(
      {List<SkillModel> skills,
      Map<String, List<String>> skillDependencies,
      String generatedPrompt,
      String criticFeedback});
}

/// @nodoc
class _$SkillRoadmapModelCopyWithImpl<$Res, $Val extends SkillRoadmapModel>
    implements $SkillRoadmapModelCopyWith<$Res> {
  _$SkillRoadmapModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SkillRoadmapModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? skills = null,
    Object? skillDependencies = null,
    Object? generatedPrompt = null,
    Object? criticFeedback = null,
  }) {
    return _then(_value.copyWith(
      skills: null == skills
          ? _value.skills
          : skills // ignore: cast_nullable_to_non_nullable
              as List<SkillModel>,
      skillDependencies: null == skillDependencies
          ? _value.skillDependencies
          : skillDependencies // ignore: cast_nullable_to_non_nullable
              as Map<String, List<String>>,
      generatedPrompt: null == generatedPrompt
          ? _value.generatedPrompt
          : generatedPrompt // ignore: cast_nullable_to_non_nullable
              as String,
      criticFeedback: null == criticFeedback
          ? _value.criticFeedback
          : criticFeedback // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SkillRoadmapModelImplCopyWith<$Res>
    implements $SkillRoadmapModelCopyWith<$Res> {
  factory _$$SkillRoadmapModelImplCopyWith(_$SkillRoadmapModelImpl value,
          $Res Function(_$SkillRoadmapModelImpl) then) =
      __$$SkillRoadmapModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<SkillModel> skills,
      Map<String, List<String>> skillDependencies,
      String generatedPrompt,
      String criticFeedback});
}

/// @nodoc
class __$$SkillRoadmapModelImplCopyWithImpl<$Res>
    extends _$SkillRoadmapModelCopyWithImpl<$Res, _$SkillRoadmapModelImpl>
    implements _$$SkillRoadmapModelImplCopyWith<$Res> {
  __$$SkillRoadmapModelImplCopyWithImpl(_$SkillRoadmapModelImpl _value,
      $Res Function(_$SkillRoadmapModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of SkillRoadmapModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? skills = null,
    Object? skillDependencies = null,
    Object? generatedPrompt = null,
    Object? criticFeedback = null,
  }) {
    return _then(_$SkillRoadmapModelImpl(
      skills: null == skills
          ? _value._skills
          : skills // ignore: cast_nullable_to_non_nullable
              as List<SkillModel>,
      skillDependencies: null == skillDependencies
          ? _value._skillDependencies
          : skillDependencies // ignore: cast_nullable_to_non_nullable
              as Map<String, List<String>>,
      generatedPrompt: null == generatedPrompt
          ? _value.generatedPrompt
          : generatedPrompt // ignore: cast_nullable_to_non_nullable
              as String,
      criticFeedback: null == criticFeedback
          ? _value.criticFeedback
          : criticFeedback // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SkillRoadmapModelImpl implements _SkillRoadmapModel {
  const _$SkillRoadmapModelImpl(
      {required final List<SkillModel> skills,
      required final Map<String, List<String>> skillDependencies,
      required this.generatedPrompt,
      required this.criticFeedback})
      : _skills = skills,
        _skillDependencies = skillDependencies;

  factory _$SkillRoadmapModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SkillRoadmapModelImplFromJson(json);

  final List<SkillModel> _skills;
  @override
  List<SkillModel> get skills {
    if (_skills is EqualUnmodifiableListView) return _skills;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_skills);
  }

  final Map<String, List<String>> _skillDependencies;
  @override
  Map<String, List<String>> get skillDependencies {
    if (_skillDependencies is EqualUnmodifiableMapView)
      return _skillDependencies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_skillDependencies);
  }

  @override
  final String generatedPrompt;
  @override
  final String criticFeedback;

  @override
  String toString() {
    return 'SkillRoadmapModel(skills: $skills, skillDependencies: $skillDependencies, generatedPrompt: $generatedPrompt, criticFeedback: $criticFeedback)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SkillRoadmapModelImpl &&
            const DeepCollectionEquality().equals(other._skills, _skills) &&
            const DeepCollectionEquality()
                .equals(other._skillDependencies, _skillDependencies) &&
            (identical(other.generatedPrompt, generatedPrompt) ||
                other.generatedPrompt == generatedPrompt) &&
            (identical(other.criticFeedback, criticFeedback) ||
                other.criticFeedback == criticFeedback));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_skills),
      const DeepCollectionEquality().hash(_skillDependencies),
      generatedPrompt,
      criticFeedback);

  /// Create a copy of SkillRoadmapModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SkillRoadmapModelImplCopyWith<_$SkillRoadmapModelImpl> get copyWith =>
      __$$SkillRoadmapModelImplCopyWithImpl<_$SkillRoadmapModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SkillRoadmapModelImplToJson(
      this,
    );
  }
}

abstract class _SkillRoadmapModel implements SkillRoadmapModel {
  const factory _SkillRoadmapModel(
      {required final List<SkillModel> skills,
      required final Map<String, List<String>> skillDependencies,
      required final String generatedPrompt,
      required final String criticFeedback}) = _$SkillRoadmapModelImpl;

  factory _SkillRoadmapModel.fromJson(Map<String, dynamic> json) =
      _$SkillRoadmapModelImpl.fromJson;

  @override
  List<SkillModel> get skills;
  @override
  Map<String, List<String>> get skillDependencies;
  @override
  String get generatedPrompt;
  @override
  String get criticFeedback;

  /// Create a copy of SkillRoadmapModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SkillRoadmapModelImplCopyWith<_$SkillRoadmapModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
