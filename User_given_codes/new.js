const express = require('express');
const admin = require('firebase-admin');
const serviceAccount = require('./credential_firebase.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const app = express();
const PORT = 3000;

// Sample health check endpoint
app.get('/api/health', (req, res) => {
  res.json({ status: 'ok', firebaseInitialized: true });
});

app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});
