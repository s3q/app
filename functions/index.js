const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp(functions.config().firebase);
const firestore = admin.firestore()

// admin.storage().bucket().upload();

exports.topActivitesFillter = functions.https.onCall( async (data, context) => {
    let activitesList = await firestore.collection("activites").where("isActive", "==", true).limit(10).get();

    activitesList.docs.forEach((a) => {
        // a.data()["viewCounter"];
        // a.data()["createdAt"];
        // a.data()["availableDays"];
        // a.data()["lat"];
        // a.data()["lng"];
        
    })
    console.log(activitesList)
    return activitesList.docs;
});

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });


