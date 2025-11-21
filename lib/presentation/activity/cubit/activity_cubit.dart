import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pr9/data/api/activity_api.dart';
import 'package:flutter_pr9/data/model/activity.dart';
import 'package:flutter_pr9/presentation/profile/user_cubit.dart';

class ActivityState {
  final List<UserActivity> activities;
  final bool loading;

  ActivityState({this.activities = const [], this.loading = false});

  ActivityState copyWith({List<UserActivity>? activities, bool? loading}) {
    return ActivityState(
      activities: activities ?? this.activities,
      loading: loading ?? this.loading,
    );
  }
}

class ActivityCubit extends Cubit<ActivityState> {
  final ActivityApi api;
  int _userWeight;
  late final StreamSubscription userSubscription;

  final Map<String, String> activityMap = {
    "Бег": "running",
    "Ходьба": "walking",
    "Плавание": "swimming",
    "Велоспорт": "cycling",
  };

  ActivityCubit({
    required this.api,
    required int initialWeight,
    required UserCubit userCubit,
  })  : _userWeight = initialWeight,
        super(ActivityState()) {
    userSubscription = userCubit.stream.listen((userState) {
      _userWeight = userState.weight;
    });
  }

  Future<void> addActivity(String name, int duration) async {
    final eng = activityMap[name] ?? name;
    emit(state.copyWith(loading: true));

    try {
      final calories = await api.calculateCalories(eng, duration, _userWeight);
      final newActivity = UserActivity(name: name, duration: duration, calories: calories);

      emit(state.copyWith(
        activities: [...state.activities, newActivity],
        loading: false,
      ));
    } catch (_) {
      emit(state.copyWith(loading: false));
    }
  }

  @override
  Future<void> close() {
    userSubscription.cancel();
    return super.close();
  }
}
