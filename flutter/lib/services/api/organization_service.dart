import 'package:github_client/models/github_organization.dart';
import 'package:github_client/services/api/api_client.dart';

class OrganizationService {
  OrganizationService({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Future<List<GithubOrganization>> getOrganizations() async {
    final response = await _apiClient.dio.get('/user/orgs');
    final body = response.data;

    if (response.statusCode != 200 || body == null) {
      throw Exception('Failed to load organizations');
    }

    return (body as List)
        .map((json) => GithubOrganization.fromJson(json))
        .toList();
  }
}
