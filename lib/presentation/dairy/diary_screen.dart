import 'package:flutter/material.dart';
import '../../../locator.dart';
import '../../data/model/food.dart';
import '../../data/repository/food_repository.dart';
import 'add_food_screen.dart';
import 'cubit/add_food_cubit.dart';
import 'cubit/diary_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DiaryScreen extends StatelessWidget {
  const DiaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Дневник питания")),
      body: BlocBuilder<DiaryCubit, List<Food>>(
        builder: (context, foods) {
          if (foods.isEmpty) {
            return const Center(child: Text("Записей нет"));
          }

          return ListView.builder(
            itemCount: foods.length,
            itemBuilder: (context, index) {
              final item = foods[index];
              return ListTile(
                title: Text(item.name),
                subtitle: Text("${item.calories} ккал"),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider(
                create: (_) => AddFoodCubit(locator.get<FoodRepository>()),
                child: const AddFoodScreen(),
              ),
            ),
          ).then((_) {
            context.read<DiaryCubit>().refresh();
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

