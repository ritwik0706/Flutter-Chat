const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

exports.myFunction = functions.firestore
    .document('chat/{doc_id}')
    .onCreate((snap, context) => {
        return admin.messaging().sendToTopic('chat', {
            notification: {
                title: snap.data().userName,
                body: snap.data().text,
                clickAction: 'FLUTTER_NOTIFICATION_CLICK',
            },
        });
    });
