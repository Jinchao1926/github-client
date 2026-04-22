import 'package:github_client/models/github_user.dart';
import 'package:github_client/services/api/api_client.dart';

class UserService {
  UserService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Future<GitHubUser> getCurrentUser() async {
    final response = await _apiClient.dio.get<Map<String, dynamic>>('/user');
    final body = response.data;

    if (response.statusCode != 200 || body == null) {
      throw Exception('Failed to load GitHub user');
    }

    return GitHubUser.fromJson(body);
  }
}
