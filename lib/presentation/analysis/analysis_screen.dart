import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/food.dart';
import '../../data/model/user.dart';
import '../profile/user_cubit.dart';
import '../dairy/cubit/diary_cubit.dart';

class AnalysisScreen extends StatelessWidget {
  const AnalysisScreen({super.key});

  Widget _circle(String title, double current, double max) {
    final progress = (max == 0 ? 0.0 : (current / max).clamp(0.0, 1.0));

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 120,
          height: 120,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: progress,
                strokeWidth: 12,
              ),
              // Показываем текущие / максимум
              Text(
                "${current.toInt()} / ${max.toInt()}",
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(title, style: const TextStyle(fontSize: 16)),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Анализ питания")),
      body: BlocBuilder<UserCubit, User>(
        builder: (context, user) {
          return BlocBuilder<DiaryCubit, List<Food>>(
            builder: (context, diary) {
              // Считаем текущее потребление из дневника
              final calories = diary.fold(0.0, (sum, f) => sum + f.calories.toDouble());
              final proteins = diary.fold(0.0, (sum, f) => sum + f.proteins);
              final fats = diary.fold(0.0, (sum, f) => sum + f.fats);
              final carbs = diary.fold(0.0, (sum, f) => sum + f.carbs);

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    alignment: WrapAlignment.center,
                    children: [
                      _circle("Ккал", calories, user.calories.toDouble()),
                      _circle("Белки", proteins, user.protein.toDouble()),
                      _circle("Жиры", fats, user.fat.toDouble()),
                      _circle("Углеводы", carbs, user.carbs.toDouble()),
                      _circle("Активность", 0.0, user.activity.toDouble()), // пока 0
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
