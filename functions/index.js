const functions=require("firebase-functions");
const admin=require("firebase-admin");
admin.initializeApp();
exports.sendAmbulanceRequestNotification = functions.firestore
    .document("Requests/{reqKey}")
    .onCreate(async (snapshot, context) => {
    //   const requestData = snapshot.data();
      // Fetch all admins or a specific admin based on Firestore structure
      const adminsSnapshot = await admin.firestore().collection("Admin").get();
      // Loop through all the admin documents
      adminsSnapshot.forEach(async (adminDoc) => {
        const adminData = adminDoc.data();
        const adminToken = adminData.fcm_token;
        if (adminToken) {
          // Create the notification payload
          const payload = {
            notification: {
              title: "New Ambulance Request",
              body: "A new request has been submitted",
            },
            data: {
              reqKey: context.params.reqKey,
            },
          };
          // Send the notification to the admin"s device using FCM
          await admin.messaging().sendToDevice(adminToken, payload);
          console.log("Notification sent to admin ${adminDoc.id}");
        }
      });
    });
