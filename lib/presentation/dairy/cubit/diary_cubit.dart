import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/model/food.dart';
import '../../../data/repository/food_repository.dart';

class DiaryCubit extends Cubit<List<Food>> {
  final FoodRepository repo;

  DiaryCubit(this.repo) : super(repo.foods);

  void refresh() {
    emit(repo.foods);
  }

  void delete(String id) {
    repo.delete(id);
    emit(repo.foods);
  }
}

