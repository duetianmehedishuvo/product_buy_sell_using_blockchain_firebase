// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:product_buy_sell/provider/note_provider.dart';
import 'package:uuid/uuid.dart';

import '../../models/note_list_model.dart';
import '../../models/notes_model.dart';
import '../../widgets/nest_notes_appbar.dart';

class EditNotePagePre extends StatefulWidget {
  final Notes note;

  const EditNotePagePre({Key? key, required this.note}) : super(key: key);

  @override
  _EditNotePagePreState createState() => _EditNotePagePreState();
}

class _EditNotePagePreState extends State<EditNotePagePre> {
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
            child: SAppBar(backgroundColor: Colors.teal, title: 'Add Topic', onTap: _onBackPressed),
          ),
          floatingActionButton: Consumer<NoteProvider>(
            builder: (context, noteProvider, child) => noteProvider.isLoading
                ? FloatingActionButton(
                    onPressed: () {},
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
                      width: 80,
                      decoration: BoxDecoration(color: Colors.teal, borderRadius: BorderRadius.circular(40), shape: BoxShape.rectangle),
                      child: MaterialButton(
                        onPressed: () {
                          if (_noteTitleController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please write title at first')));
                          } else {
                            Notes note =
                                Notes(DateTime.now().microsecondsSinceEpoch.toString(), DateTime.now().toString(), _noteTitleController.text, '', '', 0, 0, _noteListJsonString);
                            noteProvider.addNotePre(note, context).then((value) {
                              if (value == true) {
                                Navigator.of(context).pop();
                              }
                            });
                          }
                        },
                        child: Text('Save', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
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
                    maxLines: null,
                    decoration: InputDecoration(
                      hintStyle: GoogleFonts.roboto(fontSize: 25, fontWeight: FontWeight.w500),
                      hintText: 'Write Title...',
                      fillColor: Colors.transparent,
                      enabledBorder: const OutlineInputBorder(borderSide: BorderSide.none),
                      focusedBorder: const OutlineInputBorder(borderSide: BorderSide.none),
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



  Future<bool> _onBackPressed() async {
    if (_noteTextController.text.isNotEmpty) {
      Navigator.pop(context, note);
    } else {
      Navigator.pop(context, false);
    }
    return false;
  }
}
