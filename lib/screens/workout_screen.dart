import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animations/animations.dart';
import '../models/workout.dart';
import '../providers/workout_provider.dart';
import 'workout_form_screen.dart';

class WorkoutScreen extends ConsumerWidget {
  const WorkoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workoutsAsyncValue = ref.watch(workoutListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          ' My Workouts',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                color: Color(0xFF9D00FF),
                blurRadius: 12,
                offset: Offset(0, 0),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.black,
      body: workoutsAsyncValue.when(
        data: (workouts) {
          if (workouts.isEmpty) {
            return const Center(
              child: Text(
                'No Workouts Found',
                style: TextStyle(
                  color: Color(0xFF9D00FF),
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            itemCount: workouts.length,
            itemBuilder: (context, index) {
              final workout = workouts[index];
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF9D00FF),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF9D00FF).withOpacity(0.7),
                      blurRadius: 15,
                      spreadRadius: 1,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                child: ListTile(
                  title: Text(
                    workout.name,
                    style: const TextStyle(
                      color: Color(0xFF9D00FF),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Color(0xFF9D00FF),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                  ),
                  subtitle: Text(
                    workout.type,
                    style: const TextStyle(
                      color: Colors.purpleAccent,
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      shadows: [
                        Shadow(
                          color: Colors.purpleAccent,
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () {
                      ref.read(workoutDeleteProvider(workout.id!).future).then((_) {
                        ref.invalidate(workoutListProvider);
                      });
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => WorkoutFormScreen(workout: workout),
                      ),
                    ).then((_) => ref.invalidate(workoutListProvider));
                  },
                ),
              );
            },
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: Color(0xFF9D00FF)),
        ),
        error: (error, stack) => Center(
          child: Text(
            'Error: $error',
            style: const TextStyle(color: Colors.redAccent, fontSize: 18),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF9D00FF),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const WorkoutFormScreen()),
          ).then((_) => ref.invalidate(workoutListProvider));
        },
      ),
    );
  }
}
