import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mo_ashraf/data/dummy_data.dart';
import 'package:mo_ashraf/models/profile_model.dart';
import 'package:mo_ashraf/models/experience_model.dart';
import 'package:mo_ashraf/models/project_model.dart';
import 'package:mo_ashraf/models/skill_model.dart';
import 'package:mo_ashraf/models/publication_model.dart';
import 'package:mo_ashraf/models/reel_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> seedPortfolioData({bool overwrite = false}) async {
    final batch = _db.batch();

    final profileRef = _db.collection('profile').doc('main');
    final profileSnap = await profileRef.get();
    if (overwrite || !profileSnap.exists) {
      batch.set(profileRef, DummyData.profile.toMap(), SetOptions(merge: true));
    }

    await _seedCollection(
      batch: batch,
      collection: 'experiences',
      entries: {
        for (final item in DummyData.experiences) item.id: item.toMap(),
      },
      overwrite: overwrite,
    );
    await _seedCollection(
      batch: batch,
      collection: 'projects',
      entries: {for (final item in DummyData.projects) item.id: item.toMap()},
      overwrite: overwrite,
    );
    await _seedCollection(
      batch: batch,
      collection: 'skills',
      entries: {for (final item in DummyData.skills) item.id: item.toMap()},
      overwrite: overwrite,
    );

    await batch.commit();
  }

  Future<void> _seedCollection({
    required WriteBatch batch,
    required String collection,
    required Map<String, Map<String, dynamic>> entries,
    required bool overwrite,
  }) async {
    for (final entry in entries.entries) {
      final ref = _db.collection(collection).doc(entry.key);
      final snap = await ref.get();
      if (overwrite || !snap.exists) {
        batch.set(ref, entry.value, SetOptions(merge: true));
      }
    }
  }

  Stream<ProfileModel> getProfile() {
    return _db.collection('profile').doc('main').snapshots().map((snap) {
      if (snap.exists && snap.data() != null) {
        return ProfileModel.fromMap(snap.data()!);
      }
      return ProfileModel();
    });
  }

  Future<void> updateProfile(Map<String, dynamic> data) {
    return _db
        .collection('profile')
        .doc('main')
        .set(data, SetOptions(merge: true));
  }

  Stream<List<ExperienceModel>> getExperiences() {
    return _db
        .collection('experiences')
        .orderBy('order')
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((d) => ExperienceModel.fromMap(d.data(), d.id))
              .toList(),
        );
  }

  Future<void> addExperience(Map<String, dynamic> data) {
    return _db.collection('experiences').add(data);
  }

  Future<void> updateExperience(String id, Map<String, dynamic> data) {
    return _db.collection('experiences').doc(id).update(data);
  }

  Future<void> deleteExperience(String id) {
    return _db.collection('experiences').doc(id).delete();
  }

  Stream<List<ProjectModel>> getProjects() {
    return _db
        .collection('projects')
        .orderBy('order')
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((d) => ProjectModel.fromMap(d.data(), d.id))
              .toList(),
        );
  }

  Future<void> addProject(Map<String, dynamic> data) {
    return _db.collection('projects').add(data);
  }

  Future<void> updateProject(String id, Map<String, dynamic> data) {
    return _db.collection('projects').doc(id).update(data);
  }

  Future<void> deleteProject(String id) {
    return _db.collection('projects').doc(id).delete();
  }

  Stream<List<SkillModel>> getSkills() {
    return _db
        .collection('skills')
        .orderBy('order')
        .snapshots()
        .map(
          (snap) =>
              snap.docs.map((d) => SkillModel.fromMap(d.data(), d.id)).toList(),
        );
  }

  Future<void> addSkill(Map<String, dynamic> data) {
    return _db.collection('skills').add(data);
  }

  Future<void> updateSkill(String id, Map<String, dynamic> data) {
    return _db.collection('skills').doc(id).update(data);
  }

  Future<void> deleteSkill(String id) {
    return _db.collection('skills').doc(id).delete();
  }

  Stream<List<PublicationModel>> getPublications() {
    return _db
        .collection('publications')
        .orderBy('order')
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((d) => PublicationModel.fromMap(d.data(), d.id))
              .toList(),
        );
  }

  Future<void> addPublication(Map<String, dynamic> data) {
    return _db.collection('publications').add(data);
  }

  Future<void> updatePublication(String id, Map<String, dynamic> data) {
    return _db.collection('publications').doc(id).update(data);
  }

  Future<void> deletePublication(String id) {
    return _db.collection('publications').doc(id).delete();
  }

  Stream<List<ReelModel>> getReels() {
    return _db
        .collection('reels')
        .orderBy('order')
        .snapshots()
        .map(
          (snap) =>
              snap.docs.map((d) => ReelModel.fromMap(d.data(), d.id)).toList(),
        );
  }

  Future<void> addReel(Map<String, dynamic> data) {
    return _db.collection('reels').add(data);
  }

  Future<void> updateReel(String id, Map<String, dynamic> data) {
    return _db.collection('reels').doc(id).update(data);
  }

  Future<void> deleteReel(String id) {
    return _db.collection('reels').doc(id).delete();
  }
}
