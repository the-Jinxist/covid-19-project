// to run this script install node and open the terminal in the same folder /function
// then use this command: npm install --save firebase-admin
// then use this to run the scrpit: node send_notification.js
// don't forget to add serviceAccountKey.json to the root of the project, it can be downloaded through Firebase console.
var admin = require("firebase-admin");

// change this path to your serviceAccountKey.json path in your machine
var serviceAccount = require("/Users/neo/Downloads/serviceAccount.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

// This registration token comes from the console after lunching the app
var registrationToken =
  "cEILdVSaQJa9ZhYkY5o7e-:APA91bEA7dBQrliN1ARb8ExHtC5SsEkDFoRXcvUaXLEDTCNN_GVbGAI2VUcYuTHxmCcwD0_kLuSz3wh8uIrfufrru2cEDPVzK6M66kRBQKjDO1ky1iK8vyi6rxij8dzmVw6hkncN42CJ";

const message = {
  token: registrationToken,

  notification: {
    title: "Caution!",
    body: "You may have been in contact with an infected person",
  },

  data: {
    type: "infection_notification",
    title: "Caution!",
    body: "You may have been in contact with an infected person",
    topic: "covid-tracking"
    
  },

  apns: {
    headers: {
      "apns-push-type": "alert",
      "apns-priority": "10",
    },
    payload: {
      aps: {
        badge: 1,
        alert: "Thnks for ordering",
        sound: "notify.aiff",
        "content-available": 1,
      },
    },
  },
};

// Send a message to the device corresponding to the provided registration token.
admin
  .messaging()
  .send(message)
  .then((response) => {
    // Response is a message ID string.
    console.log("Successfully sent message:", response);
  })
  .catch((error) => {
    console.log("Error sending message:", error);
  });
