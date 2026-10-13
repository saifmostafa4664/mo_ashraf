import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StorageService {
  Uri get _uploadUri {
    const configuredBaseUrl = String.fromEnvironment('UPLOAD_API_BASE_URL');
    if (configuredBaseUrl.isNotEmpty) {
      return Uri.parse('$configuredBaseUrl/api/upload');
    }
    if (Uri.base.host == 'localhost' || Uri.base.host == '127.0.0.1') {
      return Uri.parse('https://mo-ashraf.vercel.app/api/upload');
    }
    return Uri.base.resolve('/api/upload');
  }

  Future<String> uploadFile(String path, Uint8List data, String contentType) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw StateError('You must be signed in to upload files.');

    final token = await user.getIdToken();
    final uri = _uploadUri;
    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': contentType,
        'X-File-Name': path.split('/').last,
        'X-Content-Type': contentType,
        'X-Upload-Path': path.substring(0, path.lastIndexOf('/')),
      },
      body: data,
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw StateError(
        'Upload failed (${response.statusCode}): ${response.body}',
      );
    }
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final url = body['url'] as String?;
    if (url == null || url.isEmpty) throw StateError('Upload returned no URL.');
    return url;
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
    // Vercel Blob deletion should be done by a protected server endpoint.
  }
}
