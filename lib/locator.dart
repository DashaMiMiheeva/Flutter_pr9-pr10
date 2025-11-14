import 'package:get_it/get_it.dart';
import 'data/repository/food_repository.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => FoodRepository());
}
