import 'package:flutter_riverpod/flutter_riverpod.dart';

class MissionState {
  final String? currentMission;
  final String? intent;

  MissionState({
    this.currentMission,
    this.intent,
  });

  MissionState copyWith({
    String? currentMission,
    bool clearMission = false,
    String? intent,
    bool clearIntent = false,
  }) {
    return MissionState(
      currentMission: clearMission ? null : (currentMission ?? this.currentMission),
      intent: clearIntent ? null : (intent ?? this.intent),
    );
  }
}

class MissionNotifier extends StateNotifier<MissionState> {
  MissionNotifier() : super(MissionState());

  void setMission(String mission) {
    state = state.copyWith(currentMission: mission);
  }

  void clearMission() {
    state = state.copyWith(clearMission: true);
  }

  void setIntent(String intent) {
    state = state.copyWith(intent: intent);
  }

  void clearIntent() {
    state = state.copyWith(clearIntent: true);
  }
}

final missionProvider = StateNotifierProvider<MissionNotifier, MissionState>((ref) {
  return MissionNotifier();
});
