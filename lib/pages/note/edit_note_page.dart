// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
//import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:product_buy_sell/dialog/confirm_dialog.dart';
import 'package:product_buy_sell/firebase/firestore_database_helper.dart';
import 'package:product_buy_sell/firebase/firestore_database_helper.dart';
import 'package:product_buy_sell/helpers/adaptive.dart';
import 'package:product_buy_sell/helpers/note_color.dart';
import 'package:product_buy_sell/models/note_list_model.dart';
import 'package:product_buy_sell/models/notes_model.dart';
import 'package:product_buy_sell/models/question_model.dart';
import 'package:product_buy_sell/notes_navigation.dart';
import 'package:product_buy_sell/pages/note/edit_note_page.dart';
import 'package:product_buy_sell/provider/note_provider.dart';
import 'package:product_buy_sell/provider/note_provider.dart';
import 'package:product_buy_sell/widgets/color_palette_button.dart';
import 'package:product_buy_sell/widgets/grid_note.dart';
import 'package:product_buy_sell/widgets/list_note.dart';
import 'package:product_buy_sell/widgets/nest_notes_appbar.dart';
import 'package:product_buy_sell/widgets/note_edit_list_textfield.dart';
import 'package:provider/provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:uuid/uuid.dart';

import '/helpers/globals.dart' as globals;
import 'note_preview.dart';
class EditNotePage extends StatefulWidget {
  final Notes note;
  final String referenceID;
  final bool isFromUpdate;

  const EditNotePage(this.referenceID, {Key? key, required this.note, this.isFromUpdate = false}) : super(key: key);

  @override
  _EditNotePageState createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {
  final FocusNode titleFocusNode = FocusNode();
  final FocusNode contentFocusNode = FocusNode();
  final TextEditingController _noteTitleController = TextEditingController();
  final TextEditingController _noteTextController = TextEditingController();
  final TextEditingController _noteListTextController = TextEditingController();
  final bool _noteListCheckValue = false;
  String currentEditingNoteId = "";
  final String _noteListJsonString = "";
  var uuid = const Uuid();
  late Notes note;
  bool isCheckList = false;
  final List<NoteListItem> _noteListItems = [];

  void onSubmitListItem() async {
    _noteListItems.add(NoteListItem(_noteListTextController.text, 'false'));
    _noteListTextController.text = "";
    print(_noteListCheckValue);
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      note = widget.note;
      _noteTextController.text = note.noteText;
      _noteTitleController.text = note.noteTitle;
      currentEditingNoteId = note.noteId;
      isCheckList = note.noteList.contains('{');
    });
    titleFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Builder(builder: (context) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(56),
            child: SAppBar(
              backgroundColor: Colors.teal,
              title: '${widget.isFromUpdate ? "Update" : "Add"} Note',
              onTap: _onBackPressed,
            ),
          ),
          floatingActionButton: Consumer<NoteProvider>(
            builder: (context, noteProvider, child) => noteProvider.isLoading
                ? FloatingActionButton(
                    onPressed: () {
                      print('khan');
                    },
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    child: const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.teal)),
                  )
                : FloatingActionButton.extended(
                    onPressed: () {},
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    label: Container(
                      height: 50,
                      width: widget.isFromUpdate?100:80,
                      decoration: BoxDecoration(color: Colors.teal, borderRadius: BorderRadius.circular(40), shape: BoxShape.rectangle),
                      child: MaterialButton(
                        onPressed: () {
                          if (widget.isFromUpdate) {
                            Notes note = widget.note;
                            note.noteTitle = _noteTitleController.text;
                            note.noteText = _noteTextController.text;
                            note.noteDate = DateTime.now().toString();
                            noteProvider.updateNote(note, widget.referenceID, context).then((value) {
                              if (value == true) {
                                Navigator.of(context).pop();
                              }
                            });
                          } else {
                            Notes note = Notes(DateTime.now().microsecondsSinceEpoch.toString(), DateTime.now().toString(), _noteTitleController.text, _noteTextController.text,
                                '', 0, 0, _noteListJsonString);
                            noteProvider.addNote(note, widget.referenceID, context).then((value) {
                              if (value == true) {
                                Navigator.of(context).pop();
                              }
                            });
                          }
                        },
                        child: Text('${widget.isFromUpdate ? "Update" : "Save"}', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                      ),
                    )),
          ),
          body: GestureDetector(
            onTap: () {
              contentFocusNode.requestFocus();
            },
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: ListView(
                children: [
                  TextField(
                    style: GoogleFonts.roboto(fontSize: 25, fontWeight: FontWeight.bold),
                    controller: _noteTitleController,
                    focusNode: titleFocusNode,
                    onSubmitted: (value) {
                      contentFocusNode.requestFocus();
                    },
                    decoration: InputDecoration(
                      hintStyle: GoogleFonts.roboto(fontSize: 25, fontWeight: FontWeight.bold),
                      hintText: 'Title',
                      fillColor: Colors.transparent,
                      enabledBorder: const OutlineInputBorder(borderSide: BorderSide.none),
                      focusedBorder: const OutlineInputBorder(borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Divider(
                    thickness: 1.2,
                    endIndent: 10,
                    indent: 10,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextField(
                    //style: GoogleFonts.roboto(fontSize:25,fontWeight: FontWeight.bold),
                    controller: _noteTextController,
                    focusNode: contentFocusNode,
                    maxLines: null,
                    onSubmitted: (value) {
                      contentFocusNode.requestFocus();
                    },
                    decoration: const InputDecoration(
                      hintText: 'Short Description. try to max 10 to 100 words..',
                      fillColor: Colors.transparent,
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
                    ),
                  ),
                  if (isCheckList) ...List.generate(_noteListItems.length, generatenoteListItems),
                  Visibility(
                    visible: isCheckList,
                    child: NoteEditListTextField(
                      checkValue: _noteListCheckValue,
                      controller: _noteListTextController,
                      onSubmit: () => onSubmitListItem(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget generatenoteListItems(int index) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
      child: Row(
        children: [
          const Icon(Icons.check_box),
          const SizedBox(
            width: 5.0,
          ),
          Expanded(
            child: Text(_noteListItems[index].value),
          ),
        ],
      ),
    );
  }

  Future<bool> _onBackPressed() async {
    if (_noteTextController.text.isNotEmpty) {
      Navigator.pop(context, note);
    } else {
      Navigator.pop(context, false);
    }
    return false;
  }
}
