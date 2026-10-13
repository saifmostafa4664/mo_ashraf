# Vercel upload setup

Project images are stored in Vercel Blob. Firestore stores only the returned image URL.

Before deploying, attach a Blob store to the Vercel project so Vercel creates
`BLOB_READ_WRITE_TOKEN`, then add these Firebase Admin variables in Vercel:

- `FIREBASE_PROJECT_ID`: `moashraf-b78ed`
- `FIREBASE_CLIENT_EMAIL`: the service account client email
- `FIREBASE_PRIVATE_KEY`: the service account private key, including `\\n` line breaks

The Firebase service account is created from Firebase Console > Project settings >
Service accounts. Never commit its JSON file or private key.
# mo_ashraf

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
