import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/job.dart';

class ApiService {
  static const _base = 'https://dummyjson.com';

  static Future<List<Job>> fetchJobs() async {
    final url = Uri.parse('$_base/products?limit=50');
    final res = await http.get(url);
    if (res.statusCode != 200) {
      throw Exception('Failed to fetch jobs (${res.statusCode})');
    }
    final data = json.decode(res.body) as Map<String, dynamic>;
    final List list = data['products'] as List;
    return list.map((e) => Job.fromProductJson(e as Map<String, dynamic>)).toList();
  }

  static Future<Job> fetchJobById(int id) async {
    final url = Uri.parse('$_base/products/$id');
    final res = await http.get(url);
    if (res.statusCode != 200) {
      throw Exception('Failed to fetch job');
    }
    final data = json.decode(res.body) as Map<String, dynamic>;
    return Job.fromProductJson(data);
  }
}
