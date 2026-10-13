const { put } = require('@vercel/blob');
const admin = require('firebase-admin');

function getFirebaseAdmin() {
  if (admin.apps.length) return admin.app();

  const required = [
    'FIREBASE_PROJECT_ID',
    'FIREBASE_CLIENT_EMAIL',
    'FIREBASE_PRIVATE_KEY',
  ];
  const missing = required.filter((name) => !process.env[name]);
  if (missing.length) {
    throw new Error(`Missing Vercel environment variables: ${missing.join(', ')}`);
  }

  return admin.initializeApp({
    credential: admin.credential.cert({
      projectId: process.env.FIREBASE_PROJECT_ID,
      clientEmail: process.env.FIREBASE_CLIENT_EMAIL,
      privateKey: process.env.FIREBASE_PRIVATE_KEY.replace(/\\n/g, '\n'),
    }),
  });
}

module.exports = async function handler(req, res) {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Headers', 'Authorization, Content-Type, X-File-Name, X-Content-Type, X-Upload-Path');
  res.setHeader('Access-Control-Allow-Methods', 'POST, OPTIONS');

  if (req.method === 'OPTIONS') return res.status(204).end();
  if (req.method !== 'POST') return res.status(405).json({ error: 'Method not allowed' });

  try {
    const authorization = req.headers.authorization || '';
    if (!authorization.startsWith('Bearer ')) {
      return res.status(401).json({ error: 'Authentication required' });
    }

    const blobToken = process.env.BLOB_READ_WRITE_TOKEN;
    if (!blobToken) {
      return res.status(500).json({
        error: 'Missing Vercel Blob token. Add BLOB_READ_WRITE_TOKEN in Vercel env vars.',
      });
    }

    await getFirebaseAdmin();
    await admin.auth().verifyIdToken(authorization.substring(7));

    const filename = String(req.headers['x-file-name'] || 'upload.bin')
      .replace(/[^a-zA-Z0-9._-]/g, '_');
    const contentType = String(req.headers['x-content-type'] || 'application/octet-stream');
    const projectPath = String(req.headers['x-upload-path'] || 'uploads');

    if (!/^image\/(jpeg|png|webp|gif|avif)$/.test(contentType)) {
      return res.status(415).json({ error: 'Only image files are allowed' });
    }

    const putOptions = {
      access: 'public',
      contentType,
      addRandomSuffix: true,
      token: blobToken,
    };

    if (process.env.BLOB_STORE_ID) {
      putOptions.store = process.env.BLOB_STORE_ID;
    }

    const result = await put(`${projectPath}/${filename}`, req, putOptions);

    return res.status(200).json({ url: result.url });
  } catch (error) {
    console.error('Upload failed', error);
    const message = error instanceof Error ? error.message : 'Upload failed';
    return res.status(500).json({ error: message });
  }
};
