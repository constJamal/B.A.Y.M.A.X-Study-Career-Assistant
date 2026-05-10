import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. Standard Class for MissionState (No Freezed)
class MissionState {
  final String? currentMission;
  final String? intent;

  const MissionState({this.currentMission, this.intent});

  // Manual copyWith replacing Freezed logic
  MissionState copyWith({String? currentMission, String? intent}) {
    return MissionState(
      currentMission: currentMission ?? this.currentMission,
      intent: intent ?? this.intent,
    );
  }
}

// 2. The Notifier
class MissionNotifier extends Notifier<MissionState> {
  @override
  MissionState build() {
    return const MissionState();
  }

  void setMission(String mission) {
    state = state.copyWith(currentMission: mission);
  }

  void clearMission() {
    state = state.copyWith(currentMission: null);
  }

  void setIntent(String intent) {
    state = state.copyWith(intent: intent);
  }

  void clearIntent() {
    state = state.copyWith(intent: null);
  }
}

// 3. The Provider
final missionProvider = NotifierProvider<MissionNotifier, MissionState>(
  MissionNotifier.new,
);
