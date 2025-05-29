import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/workout.dart';
import '../services/api_service.dart';

final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

final workoutListProvider = FutureProvider<List<Workout>>((ref) async {
  final api = ref.watch(apiServiceProvider);
  return api.fetchWorkouts();
});

final workoutCreateProvider = FutureProvider.family<Workout, Workout>((ref, workout) async {
  final api = ref.watch(apiServiceProvider);
  return api.createWorkout(workout);
});

final workoutUpdateProvider = FutureProvider.family<Workout, Map<String, dynamic>>((ref, data) async {
  final api = ref.watch(apiServiceProvider);
  final id = data['id'] as int;
  final workout = data['workout'] as Workout;
  return api.updateWorkout(id, workout);
});

final workoutDeleteProvider = FutureProvider.family<void, int>((ref, id) async {
  final api = ref.watch(apiServiceProvider);
  await api.deleteWorkout(id);
});
