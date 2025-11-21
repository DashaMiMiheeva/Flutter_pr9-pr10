import 'package:dio/dio.dart';
import 'package:flutter_pr9/keys.dart';
import '../model/activity.dart';

class ActivityApi {
  final Dio _dio = Dio();

  Future<double> calculateCalories(String activity, int duration, int weight) async {
    try {
      final response = await _dio.get(
        'https://api.api-ninjas.com/v1/caloriesburned',
        queryParameters: {
          'activity': activity,
          'duration': duration,
          'weight': weight,
        },
        options: Options(headers: {'X-Api-Key': API_NINJAS_KEY}),
      );

      final data = response.data;

      if (data is List && data.isNotEmpty) {
        final first = data[0];
        final totalCaloriesRaw = first['total_calories'];

        double calories;
        if (totalCaloriesRaw == null) {
          calories = 0;
        } else if (totalCaloriesRaw is num) {
          calories = totalCaloriesRaw.toDouble();
        } else if (totalCaloriesRaw is String) {
          calories = double.tryParse(totalCaloriesRaw) ?? 0;
        } else {
          calories = 0;
        }

        return calories;
      }

      return 0;
    } catch (e) {
      print("Ошибка API: $e");
      return 0;
    }
  }
}
