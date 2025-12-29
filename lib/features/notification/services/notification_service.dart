import '../../../core/constants/api_url.dart';
import '../../../core/services/api_service.dart';
import '../models/notification_model.dart';

class NotificationService {
  static Future<List<NotificationModel>> getNotifications() async {
    try {
      final response = await ApiService.get('${ApiUrl.baseUrl}/notifications');

      if (response['data'] is List) {
        return (response['data'] as List)
            .map((json) => NotificationModel.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      throw Exception('Gagal memuat notifikasi: $e');
    }
  }
}
