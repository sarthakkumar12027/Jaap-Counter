import '../../core/services/storage_service.dart';
import '../models/jaap_profile.dart';
import '../models/jaap_session.dart';
import '../models/sankalp_goal.dart';

class JaapRepository {
  final StorageService _storage;

  JaapRepository(this._storage);

  List<JaapProfile> getProfiles() => _storage.loadProfiles();

  Future<void> saveProfiles(List<JaapProfile> profiles) => _storage.saveProfiles(profiles);

  String? getActiveProfileId() => _storage.loadActiveProfileId();

  Future<void> saveActiveProfileId(String id) => _storage.saveActiveProfileId(id);

  List<JaapSession> getSessions() => _storage.loadSessions();

  Future<void> saveSessions(List<JaapSession> sessions) => _storage.saveSessions(sessions);

  List<SankalpGoal> getSankalps() => _storage.loadSankalps();

  Future<void> saveSankalps(List<SankalpGoal> sankalps) => _storage.saveSankalps(sankalps);
}
