import "package:cloud_firestore/cloud_firestore.dart";

class FirestoreStorage {
  final _databaseReference = Firestore.instance;
  /*For this project, the user id should be put into "String collection"*/

  /*Retrieves all document from a collection, and returns a snapshot*/
  /*-QuerySnapshot returns a List of DocumentSnapshot, each DocumentSnapshot.data is a map*/
  Future<List<Map<String,dynamic>>> getCollectionData(String collection) async {
    List<Map<String,dynamic>> docMapList = [];
    var result = await _databaseReference.collection(collection).getDocuments();
    if(result.documents.isNotEmpty){
      result.documents.forEach((document) => docMapList.add(document.data));
      print("Collection data => " + docMapList.toString());
      return docMapList;
    }
    else{
      print("Subcollection does not exist.");
      return null;
    }
  }
  /*Retrieves all document from a sub collection, and returns a snapshot*/
  /*-QuerySnapshot returns a List of DocumentSnapshot, each DocumentSnapshot.data is a map*/
  Future<List<Map<String,dynamic>>> getSubCollectionData(String main_collection, String document, String sub_collection) async {
    List<Map<String,dynamic>> docMapList = [];
    var result = await _databaseReference.collection(main_collection).document(document).collection(sub_collection).getDocuments();
    if(result.documents.isNotEmpty){
      result.documents.forEach((document) => docMapList.add(document.data));
      //print("Subcollection data => " + docMapList.toString());
      return docMapList;
    }
    else{
      print("Subcollection does not exist.");
      return null;
    }
  }
  /*Retrieves a specified document from a collection and returns a DocumentSnapshot*/
  /*-DocumentSnapshot.data returns the document data as a map*/
  Future<Map<String,dynamic>> getDocumentData(String collection, String document) async {
    final result = await _databaseReference.collection(collection).document(document).get();
    if(result.exists){
      print("Document data => " + result.data.toString());
      return result.data;
    }
    else{
      print("Document does not exists");
      return null;
    }
  }
  /*Retrieves a specified sub document from a sub collection and returns a DocumentSnapshot*/
  Future<Map<String,dynamic>> getSubDocumentData(String main_collection, String main_document, String sub_collection, String sub_document) async {
    final result = await _databaseReference.collection(main_collection).document(main_document).collection(sub_collection).document(sub_document).get();
    if(result.exists){
      print("Subdocument data => " + result.data.toString());
      return result.data;
    }
    else{
      print("Subdocument does not exist/");
      return null;
    }
  }
  /*Creates a new document using name of folder and store folder data*/
  /*-This may overwrite document content if there is a same folder name in the same collection*/
  void addDocument(String collection, Map folder) async {
    _databaseReference.collection(collection).document(folder["name"])
        .setData(folder).whenComplete(
            () => print("Document " + folder["name"] + " created in " + collection)
    );
  }
  /*Creates a new document using name of folder and store folder data in sub collection*/
  /*-User must specify main collection, main document and sub collection*/
  /*-If the main collection does not exists, the main collection will be directly created*/
  void addSubDocument(String main_collection, String main_document, String sub_collection, String sub_document, var folder) async {
    _databaseReference.collection(main_collection).document(main_document).collection(sub_collection).document(sub_document)
        .setData(folder).whenComplete(
        () => print("Document " + " created in " + main_collection + "/" + main_document + "/" + sub_collection)
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
  /*Updates and overwrites a specific field of a sub document of a main collection with new data*/
  void updateSubDocument(String main_collection, String main_document, String sub_collection, String sub_document, String field, var data) async {
    _databaseReference.collection(main_collection).document(main_document).collection(sub_collection).document(sub_document)
        .updateData({field:data}).whenComplete(
          () => print(field + " updated in " + main_collection + "/" + main_document + "/" + sub_collection + "/" + sub_document + "with" + data)
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
  /*Deletes a specified document of a specific main collection*/
  void deleteSubDocument(String main_collection, String main_document, String sub_collection, String sub_document) async {
    _databaseReference.collection(main_collection).document(main_document).collection(sub_collection).document(sub_document).delete()
        .whenComplete(
            () => print(sub_document + " in " + main_collection + "/" + main_document + "/" + sub_collection + "deleted")
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
  /*Deletes a specific sub collection*/
  void deleteSubCollection(String main_collection, String main_document, String sub_collection) async {
    _databaseReference.collection(main_collection).document(main_document).collection(sub_collection).getDocuments().then( (snapshot) {
      for (DocumentSnapshot doc in snapshot.documents) {
        doc.reference.delete();
      }
    }).whenComplete( () => print("Collection " + sub_collection + "deleted") );
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
  /*Removes a specific field of a sub document*/
  void removeSubDocumentField(String main_collection, String main_document, String sub_collection, String sub_document, String field) async {
    _databaseReference.collection(main_collection).document(main_document).collection(sub_collection).document(sub_document)
        .updateData({field:FieldValue.delete()}).whenComplete(
            () => print(field + " in " + sub_document + " deleted")
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
  /*Adds new data of type Map to the "children" field of a sub document*/
  void addChildtoSub(String main_collection, String main_document, String sub_collection, String sub_document, Map data) async {
    final doc = await getSubDocumentData(main_collection, main_document,sub_collection,sub_document);
    List docChildren = doc['children'];
    docChildren.add(data);
    _databaseReference.collection(main_collection).document(main_document).collection(sub_collection).document(sub_document)
        .updateData({"children":docChildren}).whenComplete(
            () => print('New data added to "children" of ' + sub_document + " in " + main_collection + "/" + main_document + "/" + sub_collection)
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
  /*Updates and overwrites a specified field of an item in the "children" array of the specified sub document of a sub collection with new data*/
  void updateChildofSub(String main_collection, String main_document, String sub_collection, String sub_document, String imagename, String field, var data) async {
    final doc = await getSubDocumentData(main_collection, main_document, sub_collection, sub_document);
    List docChildren = doc['children'];
    for (var item in docChildren){
      if(item['name'] == imagename){
        item[field] = data;
        _databaseReference.collection(main_collection).document(main_document).collection(main_collection).document(sub_document)
            .updateData({"children":docChildren}).whenComplete(
                () => print("'" + field + "'" + " of Image Name:" + imagename + ' updated in "children" of ' + sub_document + " in " + sub_collection)
        );
        return null;
      }
    }
    print("Image Name :" + imagename + ' is not found in "children" of ' + sub_document + " in " + sub_collection);
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
  /*Removes specific data from the "children" field of a sub document*/
  void removeChildofSub(String main_collection, String main_document, String sub_collection, String sub_document, Map data) async {
    print(data);
    _databaseReference.collection(main_collection).document(main_document).collection(sub_collection).document(sub_document)
        .updateData({"children":FieldValue.arrayRemove([data])}).whenComplete(
            () => print('Data deleted from "children" of ' + sub_document + " in " + sub_collection)
    );
  }
}