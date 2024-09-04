import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Relatório de exercícios',
      home: ExerciseReport(),
    );
  }
}

class ExerciseReport extends StatefulWidget {
  const ExerciseReport({super.key});

  @override
  State<ExerciseReport> createState() => _ExerciseReportState();
}

class _ExerciseReportState extends State<ExerciseReport> {
  final List<Exercise> _exerciseData = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Relatório de exercícios'),
      ),
      body: _exerciseData.isEmpty
          ? const Center(child: Text('Não há dados para exibir'))
          : ListView.builder(
              itemCount: _exerciseData.length,
              itemBuilder: (context, index) {
                Exercise exercise = _exerciseData[index];
                return ListTile(
                  title: Text(exercise.date),
                  subtitle: Text('${exercise.exercise} - ${exercise.reps} reps - ${exercise.weight} kg'),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showExerciseInputDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showExerciseInputDialog() {
    late String? data = '';
    late String exercise;
    late int reps;
    late double weight;

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Adicionar exercício'),
            content: SizedBox(
              // height: 150,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2050),
                      );

                      setState(() {
                        data = '${date?.day.toString().padLeft(2, '0')}/${date?.month.toString().padLeft(2, '0')}/${date?.year.toString()}';
                      });
                    },
                    child: const Text('Selecine uma data'),
                  ),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Exercício'),
                    onChanged: (value) => exercise = value,
                  ),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Repetições'),
                    onChanged: (value) => reps = int.parse(value),
                  ),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Peso (kg)'),
                    onChanged: (value) => weight = double.parse(value),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancelar'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: const Text('Adicionar'),
                onPressed: () {
                  setState(() {
                    _exerciseData.add(Exercise(date: data!, exercise: exercise, reps: reps, weight: weight));
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}

class Exercise {
  final String date;
  final String exercise;
  final int reps;
  final double weight;

  Exercise({
    required this.date,
    required this.exercise,
    required this.reps,
    required this.weight,
  });
}
