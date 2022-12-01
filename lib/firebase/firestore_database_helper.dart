import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:product_buy_sell/models/notes_model.dart';
import 'package:product_buy_sell/models/reference_model.dart';

const admin = 'admin';

// reference
const noteTopic = 'note_topic';
const noteDetails = 'note_details';
const note = 'note';
const wishlist = 'wishlist';
const referenceTitle = 'reference_title';
const referenceDetails = 'reference_details';

class FireStoreDatabaseHelper {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  ///////////// *************** for question
  static Future<void> addNodeTopic(Notes questionModel) async {
    return db.collection(noteTopic).doc(questionModel.noteId).set(questionModel.toJson());
  }

  static Future<void> updateNodeTopic(Notes questionModel) async {
    return db.collection(noteTopic).doc(questionModel.noteId).update(questionModel.toJson());
  }

  static Future<void> deleteNodeTopic(Notes questionModel) async {
    print(' Hasan ');
    print(questionModel.toJson());
    return db.collection(noteTopic).doc(questionModel.noteId).delete();
  }

  ///////////// *************** for question
  static Future<void> addQuestion(Notes questionModel, String noteID) async {
    return db.collection(noteDetails).doc(noteID).collection(note).doc(questionModel.noteId).set(questionModel.toJson());
  }

  static Future<void> updateQuestion(Notes questionModel, String noteID) async {
    return db.collection(noteDetails).doc(noteID).collection(note).doc(questionModel.noteId).update(questionModel.toJson());
  }

  static Future<void> deleteQuestion(Notes questionModel, String noteID) async {
    return db.collection(noteDetails).doc(noteID).collection(note).doc(questionModel.noteId).delete();
  }

  ///////////// *************** for Reference Title
  static Future<void> addReferenceTitle(ReferenceModel referenceModel, String postID, String noteID) async {
    return db
        .collection(noteDetails)
        .doc(noteID)
        .collection(referenceTitle)
        .doc(postID)
        .collection(referenceTitle)
        .doc(referenceModel.referenceId)
        .set(referenceModel.toJson());
  }

  static Future<void> updateReferenceTitle(ReferenceModel referenceModel, String postID, String noteID) async {
    return db
        .collection(noteDetails)
        .doc(noteID)
        .collection(referenceTitle)
        .doc(postID)
        .collection(referenceTitle)
        .doc(referenceModel.referenceId)
        .update(referenceModel.toJson());
  }

  static Future<void> deleteReferenceTitle(ReferenceModel referenceModel, String postID, String noteID) async {
    return db
        .collection(noteDetails)
        .doc(noteID)
        .collection(referenceTitle)
        .doc(postID)
        .collection(referenceTitle)
        .doc(referenceModel.referenceId)
        .delete();
  }

  ///////////// *************** for Reference Details
  static Future<void> addReferenceDetails(ReferenceModel referenceModel, String postID, String referenceTitleID, String noteID) async {
    return db
        .collection(noteDetails)
        .doc(noteID)
        .collection(referenceDetails)
        .doc(postID + referenceTitleID)
        .collection(referenceDetails)
        .doc(referenceModel.referenceId)
        .set(referenceModel.toJson());
  }

  static Future<void> updateReferenceDetails(ReferenceModel referenceModel, String postID, String referenceTitleID, String noteID) async {
    return db
        .collection(noteDetails)
        .doc(noteID)
        .collection(referenceDetails)
        .doc(postID + referenceTitleID)
        .collection(referenceDetails)
        .doc(referenceModel.referenceId)
        .update(referenceModel.toJson());
  }

  static Future<void> deleteReferenceDetails(ReferenceModel referenceModel, String postID, String referenceTitleID, String noteID) async {
    return db
        .collection(noteDetails)
        .doc(noteID)
        .collection(referenceDetails)
        .doc(postID + referenceTitleID)
        .collection(referenceDetails)
        .doc(referenceModel.referenceId)
        .delete();
  }

  ///////////// *************** for Archive
  static Future<void> addWishlist(Notes questionModel, String noteID) async {
    return db.collection(noteDetails).doc(noteID).collection(wishlist).doc(questionModel.noteId).set(questionModel.toJson());
  }

  static Future<void> updateWishlist(Notes questionModel, String noteID) async {
    return db.collection(noteDetails).doc(noteID).collection(wishlist).doc(questionModel.noteId).update(questionModel.toJson());
  }

  static Future<void> deleteWishlist(Notes questionModel, String noteID) async {
    return db.collection(noteDetails).doc(noteID).collection(wishlist).doc(questionModel.noteId).delete();
  }

  static Future<bool> checkIfWishlistExists(String docId, String noteID) async {
    try {
      var collectionRef = db.collection(noteDetails).doc(noteID).collection(wishlist);
      var doc = await collectionRef.doc(docId).get();
      return doc.exists;
    } catch (e) {
      throw e;
    }
  }

  static Future addAdmin() async {
    return db.collection(admin).doc(admin).set({'email': 'e', 'password': 'e'});
  }

  static Future<int> getAdmin(String email, String password) async {
    QuerySnapshot snapshot = await db.collection(admin).get();

    return (email == snapshot.docs[0]['email']) && (password == snapshot.docs[0]['password']) ? 1 : 0;
  }
}
