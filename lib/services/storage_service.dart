import 'package:hive_flutter/hive_flutter.dart';
import '../models/job.dart';

class StorageService {
  static late Box _usersBox;
  static late Box _sessionBox;
  static late Box _savedJobsBox;

  static Future<void> init() async {
    _usersBox = await Hive.openBox('users');
    _sessionBox = await Hive.openBox('session');
    _savedJobsBox = await Hive.openBox('savedJobs');
  }

  // USERS
  static bool userExists(String email) => _usersBox.containsKey(email);

  static void saveUser(String email, String passwordHash) {
    _usersBox.put(email, {'passwordHash': passwordHash});
  }

  static String? getPasswordHash(String email) {
    final data = _usersBox.get(email);
    if (data is Map) return data['passwordHash'] as String?;
    return null;
  }

  // SESSION
  static void setCurrentUser(String email) => _sessionBox.put('currentUser', email);
  static String? get currentUser => _sessionBox.get('currentUser') as String?;
  static void clearSession() => _sessionBox.delete('currentUser');

  // SAVED JOBS
  static List<Job> getSavedJobs() {
    final list = <Job>[];
    for (final key in _savedJobsBox.keys) {
      final m = _savedJobsBox.get(key);
      if (m is Map) {
        list.add(Job.fromMap(Map<String, dynamic>.from(m)));
      }
    }
    return list;
  }

  static bool isJobSaved(int id) => _savedJobsBox.containsKey(id);

  static void saveJob(Job job) {
    _savedJobsBox.put(job.id, job.toMap());
  }

  static void removeJob(int id) {
    _savedJobsBox.delete(id);
  }

  static int savedCount() => _savedJobsBox.length;
}
