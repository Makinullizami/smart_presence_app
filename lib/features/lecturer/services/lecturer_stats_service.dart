import '../../../core/constants/api_url.dart';
import '../../../core/services/api_service.dart';
import '../models/lecturer_stats_model.dart';

class LecturerStatsService {
  static Future<List<StatsTrendModel>> getTrends() async {
    try {
      final response = await ApiService.get(
        '${ApiUrl.baseUrl}/lecturer/stats/trends',
      );
      return (response['data'] as List)
          .map((e) => StatsTrendModel.fromJson(e))
          .toList();
    } catch (e) {
      throw Exception('Gagal memuat tren: $e');
    }
  }

  static Future<List<StatsComparisonModel>> getComparison() async {
    try {
      final response = await ApiService.get(
        '${ApiUrl.baseUrl}/lecturer/stats/comparison',
      );
      return (response['data'] as List)
          .map((e) => StatsComparisonModel.fromJson(e))
          .toList();
    } catch (e) {
      throw Exception('Gagal memuat perbandingan: $e');
    }
  }

  static Future<StatsDistributionModel> getDistribution() async {
    try {
      final response = await ApiService.get(
        '${ApiUrl.baseUrl}/lecturer/stats/distribution',
      );
      return StatsDistributionModel.fromJson(response['data']);
    } catch (e) {
      throw Exception('Gagal memuat distribusi: $e');
    }
  }

  static Future<Map<String, int>> getMethods() async {
    try {
      final response = await ApiService.get(
        '${ApiUrl.baseUrl}/lecturer/stats/methods',
      );
      return Map<String, int>.from(response['data']);
    } catch (e) {
      throw Exception('Gagal memuat metode: $e');
    }
  }

  static Future<StatsPunctualityModel> getPunctuality() async {
    try {
      final response = await ApiService.get(
        '${ApiUrl.baseUrl}/lecturer/stats/punctuality',
      );
      return StatsPunctualityModel.fromJson(response['data']);
    } catch (e) {
      throw Exception('Gagal memuat ketepatan waktu: $e');
    }
  }
}
