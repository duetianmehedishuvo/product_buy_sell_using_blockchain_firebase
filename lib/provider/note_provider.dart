import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:product_buy_sell/firebase/firestore_database_helper.dart';
import 'package:product_buy_sell/models/notes_model.dart';
import 'package:product_buy_sell/models/reference_model.dart';
import 'package:product_buy_sell/widgets/snackbar_message.dart';

class NoteProvider with ChangeNotifier {
  bool isLoading = false;

  Future<bool> addNotePre(Notes questionModel, BuildContext context) async {
    isLoading = true;
    await FireStoreDatabaseHelper.addNodeTopic(questionModel);
    isLoading = false;
    showSuccessfullyMessage(message: 'You have created a Note Successfully', title: 'Message', context: context);
    notifyListeners();
    return true;
  }

  Future<bool> addNote(Notes questionModel, String noteID, BuildContext context) async {
    isLoading = true;
    await FireStoreDatabaseHelper.addQuestion(questionModel, noteID);
    isLoading = false;
    showSuccessfullyMessage(message: 'You have created a  Note Successfully', title: 'Message', context: context);
    notifyListeners();
    return true;
  }
  Future<bool> updateNote(Notes questionModel, String noteID, BuildContext context) async {
    isLoading = true;
    await FireStoreDatabaseHelper.updateQuestion(questionModel, noteID);
    isLoading = false;
    showSuccessfullyMessage(message: 'You have Update a  Note Successfully', title: 'Message', context: context);
    notifyListeners();
    return true;
  }

  Future<bool> changeNoteColor(Notes questionModel, String noteID, BuildContext context) async {
    await FireStoreDatabaseHelper.updateQuestion(questionModel, noteID);

    notifyListeners();
    return true;
  }

  Future<bool> addNoteTitle(ReferenceModel referenceModel, String postID,String noteID, BuildContext context) async {
    isLoading = true;
    await FireStoreDatabaseHelper.addReferenceTitle(referenceModel, postID,noteID);
    isLoading = false;
    showSuccessfullyMessage(message: 'You have created a  Reference title Successfully', title: 'Message', context: context);
    notifyListeners();
    return true;
  }

  Future<bool> updateNoteTitle(ReferenceModel referenceModel, String postID,String noteID, BuildContext context) async {
    isLoading = true;
    await FireStoreDatabaseHelper.updateReferenceTitle(referenceModel, postID,noteID);
    isLoading = false;
    showSuccessfullyMessage(message: 'You have Updated a Reference title Successfully', title: 'Message', context: context);
    notifyListeners();
    return true;
  }

  Future<bool> addNoteDescription(ReferenceModel referenceModel, String postID,String noteID, String referenceID, BuildContext context) async {
    isLoading = true;
    await FireStoreDatabaseHelper.addReferenceDetails(referenceModel, postID, referenceID,noteID);
    isLoading = false;
    showSuccessfullyMessage(message: 'You have created a  Reference Description Successfully', title: 'Message', context: context);
    notifyListeners();
    return true;
  }

  Future<bool> updateNoteDetails(ReferenceModel referenceModel, String postID,String noteID, BuildContext context, String referenceID) async {
    isLoading = true;
    await FireStoreDatabaseHelper.updateReferenceDetails(referenceModel, postID, referenceID,noteID);
    isLoading = false;
    showSuccessfullyMessage(message: 'You have Updated a Reference Details Successfully', title: 'Message', context: context);
    notifyListeners();
    return true;
  }
}
