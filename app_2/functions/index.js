const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);

exports.getData = functions.https.onRequest(async (request, response) => {
    const {Storage} = require('@google-cloud/storage');
    const storage = new Storage();
    const bucket = storage.bucket('app2-57fcd');
    console.log("Started");
    await bucket.getFiles(function(err,files) {
        if(!err){
            console.log("Files are:");
            console.log(files);
            return files;
        }
        else{
            console.log("Errors are:")
            console.log(err);
            return null;
        }
    });
    console.log("Ended");
});