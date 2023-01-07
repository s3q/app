const functions = require("firebase-functions");
const admin = require("firebase-admin");
const serializer = require('proto3-json-serializer');

const counter = require("./distributed_counter")




admin.initializeApp(functions.config().firebase);
const firestore = admin.firestore();

// There is a way to get the collection without loop.

// exports.SearchActivity = functions.https.onRequest(async (req, res) => {
//     // const {id} = req.query;
//     // let activitesList = 
//     var docs;

//     await firestore.collection("activites").where("isActive", "==", true).get().then((querySnapshot) => {
//     docs =  querySnapshot.docs.map(doc => doc.data());
//   });
//     res.status(200).json(docs);
// });

function searchinObject(object, searchKeys) {
  let keysFinded = [];
  if (typeof (object) == "object") {
    let objectValuse = Array(...object.values());
    objectValuse.forEach((v1, i1) => {
      searchKeys.forEach((v2, i2) => {
        if (v.contains(v1)) {
          keysFinded.push(v1);
        }

      })
    })
  }
  return keysFinded
}

exports.SearchForActivity = functions.https.onCall(async (data, context) => {
  let activitesList = await firestore.collection("activites").where("isActive", "==", true).get();
  // let searchKeys = "d o"
  let searchKeys = data





  // // let resultActivityList = activitesList.docs;
  let resultActivityList = [];

  let klist = []

  activitesList.docs.forEach((a) => {

    if (data == "Discover all") {
      resultActivityList.push(a.data())

    } else {

      let keysFinded = [];
      // let activityId = a.data()["Id"]

      Object.values(a.data()).forEach((v1, i1) => {
        searchKeys.split(" ").forEach((v2, i2) => {

          if (v1.toString().toLowerCase().search(v2.toLowerCase()) != -1) {
            keysFinded.push(v1)
          }
        })
      })

      if (keysFinded.length != 0) {
        klist.push(keysFinded);
        let activity =  a.data();
        activity["storeId"] = a.id;
        resultActivityList.push(activity)
      }

    }

    //   // a.data().values.map((v, i) => {
    //   //   if (v.contains(data)) {
    //   //     resultActivityList.push(a);
    //   //   }
    //   // }d,
    //   // );
  })

  console.log(resultActivityList)



  return resultActivityList
  // return data

})


exports.SearchForActivityDirectly = functions.https.onCall(async (data, context) => {
  let activitesList = await firestore.collection("activites").where("isActive", "==", true).get();
  // let searchKeys = "d o"
  let searchKeys = data




  // // let resultActivityList = activitesList.docs;
  let resultActivityList = [];

  let klist = []

  activitesList.docs.forEach((a) => {

    let keysFinded = [];
    // let activityId = a.data()["Id"]

    Object.values(a.data()).forEach((v1, i1) => {
      searchKeys.split(" ").forEach((v2, i2) => {

        if (v1.toString().toLowerCase().search(v2.toLowerCase()) != -1) {
          keysFinded.push(v1)
        }
      })
    })

    if (keysFinded.length != 0) {
      klist.push(keysFinded);
      let activity = a.data();
      activity["storeId"] = a.id;
      resultActivityList.push(activity)
    }

    //   // a.data().values.map((v, i) => {
    //   //   if (v.contains(data)) {
    //   //     resultActivityList.push(a);
    //   //   }
    //   // }d,
    //   // );
  })

  console.log(resultActivityList)



  return resultActivityList.splice(0, 10)
  // return data

})


// {sharesCount: {valueType: integerValue, integerValue: 0}, description: {stringValue: djhsdg sdiugsadguasdgiuasgd  dshdjkh hsdkhsdh hsakjdh asohdsahd ohdkjsah , valueType: stringValue}, isActive: {valueType: booleanValue, booleanValue: true}, title: {stringValue: Dolphin watching and snorking MuscatDolphin watching and snorking Muscat, valueType: stringValue}, chatsCount: {valueType: integerValue, integerValue: 0}, likesCount: {valueType: integerValue, integerValue: 0}, createdAt: {valueType: integerValue, integerValue: 1665076807196}, priceNote: {stringValue: sbsbshsbsbsbs, valueType: stringValue}, reviews: {valueType: arrayValue, arrayValue: {values: [{mapValue: {fields: {createdAt: {valueType: integerValue, integerValue: 1665336205797}, review: {stringValue: gooooo, valueType: stringValue}, rating: {valueType: doubleValue, doubleValue: 5}, Id: {stringValue: 4d32aaf8-6cd0-465c-bc63-c765c2c1446f, valueType: stringValue}, userId: {stringValue: 8YAbJZkkcef847bZcVsSQELTTmF3, valueType: stringValue}}}, valueType
// {valueType: arrayValue, arrayValue: {values: [{mapValue: {fields: {createdAt: {valueType: integerValue, integerValue: 1665336205797}, review: {stringValue: gooooo, valueType: stringValue}, rating: {valueType: doubleValue, doubleValue: 5}, Id: {stringValue: 4d32aaf8-6cd0-465c-bc63-c765c2c1446f, valueType: stringValue}, userId: {stringValue: 8YAbJZkkcef847bZcVsSQELTTmF3, valueType: stringValue}}}, valueType: mapValue}, {mapValue: {fields: {createdAt: {valueType: integerValue, integerValue: 1665336425198}, review: {stringValue: very good, valueType: stringValue}, rating: {valueType: doubleValue, doubleValue: 3}, Id: {stringValue: 1967bd5d-b05b-4ae3-aaf0-4596f85cf7c6, valueType: stringValue}, userId: {stringValue: 8YAbJZkkcef847bZcVsSQELTTmF3, valueType: stringValue}}}, valueType: mapValue}, {mapValue: {fields: {createdAt: {valueType: integerValue, integerValue: 1665336804538}, review: {stringValue: hfxddxdx hdf ffc  fcfdsarzr, valueType: stringValue}, rating: {valueType: doubleValue, doubleValue: 3}, Id: {strin



exports.notificationFunction = functions.firestore
  .document("/notifications/{documentId}")
  .onCreate((snap, cxt) => {

    const messages = [];

    messages.push({

      notification: { title: snap.data().username, body: snap.data().text },
      topic: "chat",
    });

    admin.messaging().sendToTopic(snap.data()["notificationId"]).sendAll(messages)
      .then((response) => {
        console.log(response.successCount.toString() +
          "messages were sent successfully");
      });
});


exports.increaseCountersActivities = functions.https.onCall(async (data, context) => {
  let field = data["field"]
  let doc = data["doc"]

  const field_counter = new counter(firestore.collection("activites").doc(doc), field)

  // Increment the field "visits" of the document "pages/hello-world".
  field_counter.incrementBy(1);


  // Listen to locally consistent values.
  // field_counter.onSnapshot((snap) => {
    // console.log("Locally consistent view of visits: " + );
    // return 
  // });

  return await field_counter.get();

})