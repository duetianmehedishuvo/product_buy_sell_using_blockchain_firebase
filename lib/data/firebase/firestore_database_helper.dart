import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:product_buy_sell/data/model/response/product_model.dart';
import 'package:product_buy_sell/data/model/response/user_models.dart';
import 'package:product_buy_sell/helper/secret_key.dart';

const admin = 'admin';

// reference
const user = 'user';
const products = 'products';
const deliveryMan = 'Delivery-MAN';

class FireStoreDatabaseHelper {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  // TODO: for user
  static Future<void> addUser(UserModels userModels) async {
    return db.collection(user).doc(userModels.phone).set(userModels.toJson());
  }

  static Future<bool> checkIfWishUserExists(String phoneNo) async {
    try {
      var collectionRef = db.collection(user);
      var doc = await collectionRef.doc(phoneNo).get();
      return doc.exists;
    } catch (e) {
      rethrow;
    }
  }

  static Future<int> loginUser(String phone, String password) async {
    var doc = await db.collection(user).doc(phone).get();
    if (!doc.exists) {
      return -1;
    } else {
      var snapshot = await db.collection(user).doc(phone).get();
      UserModels userModels = UserModels.fromJson(snapshot.data());
      if (userModels.password == password) {
        return 0;
      } else {
        return 1;
      }
    }
  }

  static Future<UserModels> getUserData(String phone) async {
    var snapshot = await db.collection(user).doc(phone).get();
    return UserModels.fromJson(snapshot.data());
  }

  // FOR PRODUCT Section
  static Future<void> addProduct(ProductModel productModel) async {
    return db.collection(products).doc(productModel.productId.toString()).set(productModel.toJson());
  }

  static Future<ProductModel> getProduct(String productId) async {
    var snapshot = await db.collection(products).doc(productId).get();
    return ProductModel.fromJson(snapshot.data());
  }

  static Future<List<UserModels>> distributorsLists() async {
    List<UserModels> data = [];
    await FirebaseFirestore.instance.collection(user).get().then((value) {
      for (var i in value.docs) {
        if (i.data()['userType'] == 0) {
          data.add(UserModels.fromJson(i.data()));
        }
      }
    });
    return data;
  }

  static Future<List<UserModels>> deliveryManLists() async {
    List<UserModels> data = [];
    await FirebaseFirestore.instance.collection(user).get().then((value) {
      for (var i in value.docs) {
        if (i.data()['userType'] == 1) {
          data.add(UserModels.fromJson(i.data()));
        }
      }
    });
    return data;
  }

  static Future<void> assignProducts(String deliveryManID, String distributorsID, String productID) async {
    db
        .collection(products)
        .doc(productID)
        .update({"distributorsID": encryptedText(distributorsID), "deliveryManID": encryptedText(deliveryManID), "status": 1});

    return db
        .collection(deliveryMan)
        .doc(deliveryManID)
        .collection(deliveryManID)
        .doc(productID)
        .set({'distributors_id': encryptedText(distributorsID), 'product_id': encryptedText(productID), 'status': 0});
  }

  static Future<List<ProductModel>> getDeliveryManAssignProducts(String deliveryManID) async {
    List<ProductModel> data = [];
    await FirebaseFirestore.instance.collection(deliveryMan).doc(deliveryManID).collection(deliveryManID).get().then((value) async {
      for (var i in value.docs) {
        data.add(await getProduct(decryptedText(i.data()['product_id'])));
      }
    });
    return data;
  }

  static Future<void> updateProductStatus(String productID, {int status = 2}) async {
    return db.collection(products).doc(productID).update({"status": status});
  }

  // ///////////// *************** for question
  // static Future<void> addNodeTopic(Notes questionModel) async {
  //   return db.collection(noteTopic).doc(questionModel.noteId).set(questionModel.toJson());
  // }
  //
  // static Future<void> updateNodeTopic(Notes questionModel) async {
  //   return db.collection(noteTopic).doc(questionModel.noteId).update(questionModel.toJson());
  // }
  //
  // static Future<void> deleteNodeTopic(Notes questionModel) async {
  //   print(' Hasan ');
  //   print(questionModel.toJson());
  //   return db.collection(noteTopic).doc(questionModel.noteId).delete();
  // }
  //
  // ///////////// *************** for question
  // static Future<void> addQuestion(Notes questionModel, String noteID) async {
  //   return db.collection(noteDetails).doc(noteID).collection(note).doc(questionModel.noteId).set(questionModel.toJson());
  // }
  //
  // static Future<void> updateQuestion(Notes questionModel, String noteID) async {
  //   return db.collection(noteDetails).doc(noteID).collection(note).doc(questionModel.noteId).update(questionModel.toJson());
  // }
  //
  // static Future<void> deleteQuestion(Notes questionModel, String noteID) async {
  //   return db.collection(noteDetails).doc(noteID).collection(note).doc(questionModel.noteId).delete();
  // }
  //
  // ///////////// *************** for Reference Title
  // static Future<void> addReferenceTitle(ReferenceModel referenceModel, String postID, String noteID) async {
  //   return db
  //       .collection(noteDetails)
  //       .doc(noteID)
  //       .collection(referenceTitle)
  //       .doc(postID)
  //       .collection(referenceTitle)
  //       .doc(referenceModel.referenceId)
  //       .set(referenceModel.toJson());
  // }
  //
  // static Future<void> updateReferenceTitle(ReferenceModel referenceModel, String postID, String noteID) async {
  //   return db
  //       .collection(noteDetails)
  //       .doc(noteID)
  //       .collection(referenceTitle)
  //       .doc(postID)
  //       .collection(referenceTitle)
  //       .doc(referenceModel.referenceId)
  //       .update(referenceModel.toJson());
  // }
  //
  // static Future<void> deleteReferenceTitle(ReferenceModel referenceModel, String postID, String noteID) async {
  //   return db
  //       .collection(noteDetails)
  //       .doc(noteID)
  //       .collection(referenceTitle)
  //       .doc(postID)
  //       .collection(referenceTitle)
  //       .doc(referenceModel.referenceId)
  //       .delete();
  // }
  //
  // ///////////// *************** for Reference Details
  // static Future<void> addReferenceDetails(ReferenceModel referenceModel, String postID, String referenceTitleID, String noteID) async {
  //   return db
  //       .collection(noteDetails)
  //       .doc(noteID)
  //       .collection(referenceDetails)
  //       .doc(postID + referenceTitleID)
  //       .collection(referenceDetails)
  //       .doc(referenceModel.referenceId)
  //       .set(referenceModel.toJson());
  // }
  //
  // static Future<void> updateReferenceDetails(ReferenceModel referenceModel, String postID, String referenceTitleID, String noteID) async {
  //   return db
  //       .collection(noteDetails)
  //       .doc(noteID)
  //       .collection(referenceDetails)
  //       .doc(postID + referenceTitleID)
  //       .collection(referenceDetails)
  //       .doc(referenceModel.referenceId)
  //       .update(referenceModel.toJson());
  // }
  //
  // static Future<void> deleteReferenceDetails(ReferenceModel referenceModel, String postID, String referenceTitleID, String noteID) async {
  //   return db
  //       .collection(noteDetails)
  //       .doc(noteID)
  //       .collection(referenceDetails)
  //       .doc(postID + referenceTitleID)
  //       .collection(referenceDetails)
  //       .doc(referenceModel.referenceId)
  //       .delete();
  // }
  //
  // ///////////// *************** for Archive
  // static Future<void> addWishlist(Notes questionModel, String noteID) async {
  //   return db.collection(noteDetails).doc(noteID).collection(wishlist).doc(questionModel.noteId).set(questionModel.toJson());
  // }
  //
  // static Future<void> updateWishlist(Notes questionModel, String noteID) async {
  //   return db.collection(noteDetails).doc(noteID).collection(wishlist).doc(questionModel.noteId).update(questionModel.toJson());
  // }
  //
  // static Future<void> deleteWishlist(Notes questionModel, String noteID) async {
  //   return db.collection(noteDetails).doc(noteID).collection(wishlist).doc(questionModel.noteId).delete();
  // }

  // static Future<bool> checkIfWishlistExists(String docId, String noteID) async {
  //   try {
  //     var collectionRef = db.collection(noteDetails).doc(noteID).collection(wishlist);
  //     var doc = await collectionRef.doc(docId).get();
  //     return doc.exists;
  //   } catch (e) {
  //     throw e;
  //   }
  // }

  static Future addAdmin() async {
    return db.collection(admin).doc(admin).set({'email': 'e', 'password': 'e'});
  }

  static Future<int> getAdmin(String email, String password) async {
    QuerySnapshot snapshot = await db.collection(admin).get();

    return (email == snapshot.docs[0]['email']) && (password == snapshot.docs[0]['password']) ? 1 : 0;
  }
}
