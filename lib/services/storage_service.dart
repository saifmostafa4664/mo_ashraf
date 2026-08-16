import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadFile(String path, Uint8List data, String contentType) async {
    final ref = _storage.ref().child(path);
    final metadata = SettableMetadata(contentType: contentType);
    await ref.putData(data, metadata);
    return await ref.getDownloadURL();
  }

  Future<String> uploadProfilePhoto(Uint8List data, String extension) {
    return uploadFile('profile/photo.$extension', data, 'image/$extension');
  }

  Future<String> uploadLogo(Uint8List data, String extension) {
    return uploadFile('profile/logo.$extension', data, 'image/$extension');
  }

  Future<String> uploadStudioPhoto(Uint8List data, String extension) {
    return uploadFile('profile/studio.$extension', data, 'image/$extension');
  }

  Future<String> uploadCV(Uint8List data, String fileName) {
    return uploadFile('profile/cv/$fileName', data, 'application/pdf');
  }

  Future<String> uploadProjectImage(String projectId, Uint8List data, String extension, int index) {
    return uploadFile('projects/$projectId/image_$index.$extension', data, 'image/$extension');
  }

  Future<String> uploadReelThumbnail(String reelId, Uint8List data, String extension) {
    return uploadFile('reels/$reelId/thumbnail.$extension', data, 'image/$extension');
  }

  Future<String> uploadPublicationImage(String pubId, Uint8List data, String extension) {
    return uploadFile('publications/$pubId/image.$extension', data, 'image/$extension');
  }

  Future<void> deleteFile(String url) async {
    try {
      final ref = _storage.refFromURL(url);
      await ref.delete();
    } catch (_) {}
  }
}
