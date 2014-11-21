//
// # Firebase Sample
//
// A simple sample of writing data to Firebase with Nodejs.
//
// Make sure to install the Firebase module with:
//
//     npm install firebase
//
// You can run this sample with:
//
//     node firebase.js
//
var Firebase = require('firebase');

var id = Math.floor(Math.random()*1000000)
  , addy = "https://"+ id +".firebaseio-demo.com";

console.log("You can view your data being written to: "+ addy);
console.log("Data will continue to be written until you close this program.");

// Create a Firebase Reference
var firebaseRef = new Firebase(addy);

// This function is called from setInterval, every 5 seconds
function dataToFirebase() {
  var key = ""+Math.floor(Math.random()*10000)
    , val = "This is random data, from firebase.js"
    , obj = {};
  obj[key] = val;
  // Push our random data to firebase
  firebaseRef.push(obj);
}
setInterval(dataToFirebase, 5000);

// Listen for data being added to firebase.
firebaseRef.on("child_added", function(snapshot) {
  console.log("Value from Firebase: ", snapshot.val());
});
