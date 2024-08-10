importScripts(
  "https://www.gstatic.com/firebasejs/9.10.0/firebase-app-compat.js"
);
importScripts(
  "https://www.gstatic.com/firebasejs/9.10.0/firebase-messaging-compat.js"
);

firebase.initializeApp({
  apiKey: "AIzaSyAyiZi-oi6QilI2X-7hNcCgtbmRT2WLAhs",
  authDomain: "astroway-diploy.firebaseapp.com",
  databaseURL: "https://astroway-diploy-default-rtdb.firebaseio.com",
  projectId: "astroway-diploy",
  storageBucket: "astroway-diploy.appspot.com",
  messagingSenderId: "381086206621",
  appId: "1:381086206621:web:f09b5db876e2323d32e274",
  measurementId: "G-XY1LD81J6X",
});
// Necessary to receive background messages:
const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((m) => {
  console.log("onBackgroundMessage", m);
});
