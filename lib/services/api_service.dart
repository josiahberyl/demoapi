import 'package:dio/dio.dart';
import '../models/workout.dart';

class ApiService {
  final Dio _dio = Dio();
  final String baseUrl = 'https://mocki.io/v1/7e8f0a34-a843-4038-b974-f2a39bf68099';

  Future<List<Workout>> fetchWorkouts() async {
    final response = await _dio.get(baseUrl);
    return (response.data['workouts'] as List)
        .map((json) => Workout.fromJson(json))
        .toList();
  }

  Future<Workout> createWorkout(Workout workout) async {
    // Mock API might not support actual POST - simulate response
    final response = await _dio.post(baseUrl, data: workout.toJson());
    return Workout.fromJson(response.data);
  }

  Future<Workout> updateWorkout(int id, Workout workout) async {
    // Mock API might not support actual PUT - simulate response
    final response = await _dio.put('$baseUrl/$id', data: workout.toJson());
    return Workout.fromJson(response.data);
  }

  Future<void> deleteWorkout(int id) async {
    // Mock API might not support actual DELETE - simulate response
    await _dio.delete('$baseUrl/$id');
  }
}
