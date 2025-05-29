import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/workout.dart';
import '../providers/workout_provider.dart';

class WorkoutFormScreen extends ConsumerStatefulWidget {
  final Workout? workout;
  const WorkoutFormScreen({super.key, this.workout});

  @override
  ConsumerState<WorkoutFormScreen> createState() => _WorkoutFormScreenState();
}

class _WorkoutFormScreenState extends ConsumerState<WorkoutFormScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _typeController;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.workout?.name ?? '');
    _typeController = TextEditingController(text: widget.workout?.type ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _typeController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final workout = Workout(
      id: widget.workout?.id,
      name: _nameController.text.trim(),
      type: _typeController.text.trim(),
    );

    try {
      if (widget.workout == null) {
        // Create new workout
        await ref.read(workoutCreateProvider(workout).future);
      } else {
        // Update existing workout
        await ref.read(workoutUpdateProvider({'id': workout.id!, 'workout': workout}).future);
      }
      ref.invalidate(workoutListProvider);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e', style: const TextStyle(color: Colors.white))),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.workout != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? 'Edit Workout' : 'Add Workout',
          style: const TextStyle(
            color: Color(0xFF9D00FF),
            shadows: [
              Shadow(color: Color(0xFF9D00FF), blurRadius: 12),
            ],
          ),
        ),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                style: const TextStyle(color: Color(0xFF9D00FF)),
                decoration: InputDecoration(
                  labelText: 'Workout Name',
                  labelStyle: const TextStyle(color: Color(0xFF9D00FF)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFF9D00FF), width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFF9D00FF), width: 3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) =>
                    value == null || value.trim().isEmpty ? 'Please enter a workout name' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _typeController,
                style: const TextStyle(color: Color(0xFF9D00FF)),
                decoration: InputDecoration(
                  labelText: 'Workout Type',
                  labelStyle: const TextStyle(color: Color(0xFF9D00FF)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFF9D00FF), width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFF9D00FF), width: 3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) =>
                    value == null || value.trim().isEmpty ? 'Please enter a workout type' : null,
              ),
              const SizedBox(height: 30),
              _isLoading
                  ? const CircularProgressIndicator(color: Color(0xFF9D00FF))
                  : SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF9D00FF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          shadowColor: const Color(0xFF9D00FF),
                          elevation: 10,
                        ),
                        onPressed: _submit,
                        child: Text(
                          isEditing ? 'Update Workout' : 'Add Workout',
                          style: const TextStyle(fontSize: 18, color: Colors.black),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
