import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/calculator_cubit.dart';


class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  String sex = "male";
  double activityLevel = 1.2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Калькулятор КБЖУ")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: weightController,
                decoration: const InputDecoration(labelText: "Вес (кг)"),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: heightController,
                decoration: const InputDecoration(labelText: "Рост (см)"),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: ageController,
                decoration: const InputDecoration(labelText: "Возраст"),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              DropdownButton<String>(
                value: sex,
                items: const [
                  DropdownMenuItem(value: "male", child: Text("Мужчина")),
                  DropdownMenuItem(value: "female", child: Text("Женщина")),
                ],
                onChanged: (v) => setState(() => sex = v!),
              ),
              const SizedBox(height: 12),
              DropdownButton<double>(
                value: activityLevel,
                items: const [
                  DropdownMenuItem(value: 1.2, child: Text("Минимальная активность")),
                  DropdownMenuItem(value: 1.375, child: Text("Лёгкая активность")),
                  DropdownMenuItem(value: 1.55, child: Text("Средняя активность")),
                  DropdownMenuItem(value: 1.725, child: Text("Высокая активность")),
                  DropdownMenuItem(value: 1.9, child: Text("Очень высокая активность")),
                ],
                onChanged: (v) => setState(() => activityLevel = v!),
              ),
              const SizedBox(height: 12),
              DropdownButton<Goal>(
                value: context.watch<CalculatorCubit>().state.goal,
                items: const [
                  DropdownMenuItem(value: Goal.lose, child: Text("Похудение")),
                  DropdownMenuItem(value: Goal.maintain, child: Text("Поддержание")),
                  DropdownMenuItem(value: Goal.gain, child: Text("Набор массы")),
                ],
                onChanged: (v) => context.read<CalculatorCubit>().updateGoal(v!),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final weight = int.tryParse(weightController.text) ?? 70;
                  final height = int.tryParse(heightController.text) ?? 170;
                  final age = int.tryParse(ageController.text) ?? 25;

                  context.read<CalculatorCubit>().calculate(
                    weight: weight,
                    height: height,
                    age: age,
                    sex: sex,
                    activityLevel: activityLevel,
                  );
                },
                child: const Text("Рассчитать"),
              ),
              const SizedBox(height: 20),
              BlocBuilder<CalculatorCubit, CalculatorState>(
                builder: (context, state) {
                  return Card(
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text("Калории: ${state.calories.toInt()} ккал"),
                          Text("Белки: ${state.protein.toInt()} г"),
                          Text("Жиры: ${state.fat.toInt()} г"),
                          Text("Углеводы: ${state.carbs.toInt()} г"),
                          Text("Активность: ${state.activity.toInt()} ккал"),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

