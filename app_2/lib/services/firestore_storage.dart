import "package:cloud_firestore/cloud_firestore.dart";
import 'record.dart';

abstract class Firestore_functions{
  /*General Firestore functions, can be used in all projects*/
  Future<List<Map<String,dynamic>>> getCollectionData(String collection);
  Future<Map<String,dynamic>> getDocumentData(String collection, String document);
  void addDocument(String collection, folderRecord folder);
  void updateDocument(String collection, String document, String field, var data );
  void deleteDocument(String collection, String document);
  void deleteCollection(String collection);
  void removeDocumentField(String collection, String document, String field);
  /*Custom Firestore functions, customized for this FlutterPhoto project*/
  void addChild(String collection, String document, Map data);
  void unionChild(String collection, String document, var data);
  void updateChild(String collection, String document, String imagename, String field, var data);
  void removeChild(String collection, String document, Map data);
}

class FirestoreStorage implements Firestore_functions {
  final _databaseReference = Firestore.instance;
  /*For this project, the user id should be put into "String collection"*/

  /*Retrieves all document from a collection, and returns a snapshot*/
  /*-QuerySnapshot returns a List of DocumentSnapshot, each DocumentSnapshot.data is a map*/
  Future<List<Map<String,dynamic>>> getCollectionData(String collection) async {
    List<Map<String,dynamic>> docMapList = [];
    final result = await _databaseReference.collection(collection).getDocuments();
    result.documents.forEach(
        (document) => docMapList.add(document.data)
    );
    print("Collection data => " + docMapList.toString());
    return docMapList;
  }
  /*Retrieves a specified document from a collection and returns a DocumentSnapshot*/
  /*-DocumentSnapshot.data returns the document data as a map*/
  Future<Map<String,dynamic>> getDocumentData(String collection, String document) async {
    final result = await _databaseReference.collection(collection).document(document).get();
    print("Document data => " + result.data.toString());
    return result.data;
  }
  /*Creates a new document using name of folder and store folder data*/
  /*-This may overwrite document content if there is a same folder name in the same collection*/
  void addDocument(String collection, folderRecord folder) async {
    _databaseReference.collection(collection).document(folder.name)
        .setData(folder.dat()).whenComplete(
            () => print("Document " + folder.name + " created in Collection " + collection)
    );
  }
  /*Updates and overwrites a specific field of a document with new data*/
  /*-This will add a new field instead if the field was previously not found in the document*/
  /*-The difference between addDocument and updateDocument is addDocument will change/overwrite the whole
  *   document while updateDocument will only update/overwrite the specific field of the document*/
  void updateDocument(String collection, String document, String field, var data ) async {
    _databaseReference.collection(collection).document(document)
        .updateData({field:data}).whenComplete(
            () => print(field + " updated in " + document + " with " + data)
    );
  }
  /*Deletes a specified document of a specific collection*/
  /*-No action taken if specified document is not found in collection*/
  void deleteDocument(String collection, String document) async {
    _databaseReference.collection(collection).document(document).delete()
        .whenComplete(
        () => print(document + " in collection " + collection + " deleted")
    );
  }
  /*Deletes a specific collection*/
  /*-According to Firestore docs, a collection can only be removed when all documents under
  *   the collection has been deleted*/
  /*-Once all documents are deleted, the collection is already deleted, but will still show
  *   up in firebase console unless the browser is refreshed*/
  /*-This action will also delete all documents under that collection*/
  void deleteCollection(String collection) async {
    _databaseReference.collection(collection).getDocuments().then( (snapshot) {
      for (DocumentSnapshot doc in snapshot.documents) {
        doc.reference.delete();
      }
    }).whenComplete( () => print("Collection " + collection + " deleted") );
  }
  /*Removes a specific field of a document*/
  /*-No action if the specified field is not found in the document*/
  /*-To add field to a document, just use updateDocument function instead*/
  void removeDocumentField(String collection, String document, String field) async {
    _databaseReference.collection(collection).document(document)
        .updateData({field:FieldValue.delete()}).whenComplete(
        () => print(field + " in " + document + " deleted")
    );
  }
  /*Adds new data of type Map to the "children" field of document*/
  /*-This function works as if adding the details of imageRecord into folderRecord*/
  /*-The "children" field of the document is retrieved to local client, then new data is appended to
  *   the original "children" list before overwriting the "children" list in firestore database*/
  /*-arrayUnion cannot be used as any data with the same field name cannot be added twice*/
  void addChild(String collection, String document, Map data) async {
    final doc = await getDocumentData(collection, document);
    List docChildren = doc['children'];
    docChildren.add(data);
    _databaseReference.collection(collection).document(document)
        .updateData({"children":docChildren}).whenComplete(
            () => print('New data added to "children" of ' + document + " in " + collection)
    );
  }
  /*Unions a new data to the "children" field of a document*/
  /*-This functions works as if performing a union on the details of imageRecord in folderRecord*/
  /*-This function basically does nothing if the field already exists*/
  /*-Not recommended to be used if no new fields*/
  void unionChild(String collection, String document, var data) async {
    await _databaseReference.collection(collection).document(document)
        .updateData({"children":FieldValue.arrayUnion([data])}).whenComplete(
        () => print('New data added to "children" of ' + document + " in " + collection)
    );
  }
  /*Updates and overwrites a specified field of an item in the "children" array of the specified document of a collection with new data*/
  /*-This function assumes that there is no identical imagename in the "children" array of the document, as images stored
  *   should not have the same name*/
  /*-The "children" field of the specified document is retrieved to local client first*/
  /*-The function will navigate to the specified document, iterate through the list of item stored in the "children" array to
  *   find a match, change the data of the specified field, then overwrite the "children* list in firestore database with the new list*/
  void updateChild(String collection, String document, String imagename, String field, var data) async {
    final doc = await getDocumentData(collection, document);
    List docChildren = doc['children'];
    for (var item in docChildren){
      if(item['name'] == imagename){
        item[field] = data;
        _databaseReference.collection(collection).document(document)
            .updateData({"children":docChildren}).whenComplete(
                () => print("'" + field + "'" + " of Image Name:" + imagename + ' updated in "children" of ' + document + " in " + collection)
        );
        return null;
      }
    }
    print("Image Name :" + imagename + ' is not found in "children" of ' + document + " in " + collection);
  }
  /*Removes specific data from the "children" field of a document*/
  /*-This function only works if the data is exactly the same as the data in firestore database*/
  /*-To be exact, null value field is not equal to "" empty string*/
  void removeChild(String collection, String document, Map data) async {
    print(data);
    _databaseReference.collection(collection).document(document)
        .updateData({"children":FieldValue.arrayRemove([data])}).whenComplete(
        () => print('Data deleted from "children" of ' + document + " in " + collection)
    );
  }
}