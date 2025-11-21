import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/activity_cubit.dart';
import '../../data/api/activity_api.dart';

class ActivityScreen extends StatelessWidget {
  ActivityScreen({super.key});

  final durationController = TextEditingController();
  final List<String> activityNames = ["Бег", "Ходьба", "Плавание", "Велоспорт"];
  final selectedActivity = ValueNotifier<String>("Бег");

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ActivityCubit>();

    return Scaffold(
      appBar: AppBar(title: const Text("Активности")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    ValueListenableBuilder<String>(
                      valueListenable: selectedActivity,
                      builder: (_, value, __) => DropdownButton<String>(
                        value: value,
                        items: activityNames
                            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (v) => selectedActivity.value = v!,
                      ),
                    ),
                    TextField(
                      controller: durationController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: "Продолжительность (мин)"),
                    ),
                    const SizedBox(height: 10),
                    BlocBuilder<ActivityCubit, ActivityState>(
                      builder: (_, state) => ElevatedButton(
                        onPressed: state.loading
                            ? null
                            : () {
                          final duration = int.tryParse(durationController.text) ?? 30;
                          cubit.addActivity(selectedActivity.value, duration);
                          durationController.clear();
                        },
                        child: state.loading
                            ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                            : const Text("Добавить"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: BlocBuilder<ActivityCubit, ActivityState>(
                builder: (_, state) => ListView.builder(
                  itemCount: state.activities.length,
                  itemBuilder: (_, i) {
                    final a = state.activities[i];
                    return ListTile(
                      title: Text(a.name),
                      subtitle: Text("${a.duration} мин"),
                      trailing: Text("${a.calories.toStringAsFixed(1)} ккал"),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
