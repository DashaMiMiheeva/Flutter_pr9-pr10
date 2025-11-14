import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/model/food.dart';
import '../../../data/repository/food_repository.dart';

class AddFoodCubit extends Cubit<void> {
  final FoodRepository repo;

  AddFoodCubit(this.repo) : super(null);

  void add(Food food) {
    repo.add(food);
  }
}
