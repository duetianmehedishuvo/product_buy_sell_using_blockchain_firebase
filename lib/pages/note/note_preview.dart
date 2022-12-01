// ignore_for_file: avoid_print, unused_field, deprecated_member_use

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:product_buy_sell/pages/note/add_reference_screen.dart';
import 'package:product_buy_sell/pages/note/edit_note_page.dart';
import 'package:product_buy_sell/pages/note/reference_details_screen.dart';
import 'package:provider/provider.dart';
import 'package:product_buy_sell/dialog/confirm_dialog.dart';
import 'package:product_buy_sell/dialog/show_color_palette_dialog.dart';
import 'package:product_buy_sell/firebase/firestore_database_helper.dart';
import 'package:product_buy_sell/helpers/color.dart';
import 'package:product_buy_sell/models/reference_model.dart';
import 'package:product_buy_sell/provider/note_provider.dart';
import 'package:product_buy_sell/widgets/fancy_toasts.dart';

import '/helpers/globals.dart' as globals;
import '../../helpers/note_color.dart';
import '../../helpers/utility.dart';
import '../../models/note_list_model.dart';
import '../../models/notes_model.dart';

class NoteReaderPage extends StatefulWidget {
  final Notes note;
  final String noteReferenceID;

  const NoteReaderPage(this.noteReferenceID, {Key? key, required this.note}) : super(key: key);

  @override
  _NoteReaderPageState createState() => _NoteReaderPageState();
}

class _NoteReaderPageState extends State<NoteReaderPage> {
  late Notes note;
  ScrollController scrollController = ScrollController();
  String currentEditingNoteId = "";
  List<String> _checkList = [];
  List<NoteListItem> _noteList = [];
  bool isDesktop = false;

  int selectedPageColor = 0;

  void _noteToList() {
    if (note.noteText.contains('{')) {
      _checkList = note.noteText.replaceAll('[CHECKBOX]\n', '').split('\n');
      final parsed = json.decode(note.noteText).cast<Map<String, dynamic>>();
      _noteList = parsed.map<NoteListItem>((json) => NoteListItem.fromJson(json)).toList();
    }
  }

  @override
  void initState() {
    selectedPageColor = widget.note.noteColor;
    note = widget.note;
    _noteToList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool darkModeOn = (globals.themeMode == ThemeMode.dark || (brightness == Brightness.dark && globals.themeMode == ThemeMode.system));
    print(note.toJson());
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: NoteColor.getColor(selectedPageColor, darkModeOn),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            print(widget.noteReferenceID);
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => AddReferenceScreen(widget.note, widget.noteReferenceID)));
          },
          backgroundColor: NoteColor.getColor(selectedPageColor, darkModeOn),
          child: const Icon(Icons.add, color: Colors.black, size: 35),
        ),
        appBar: AppBar(
          elevation: 0.2,
          backgroundColor: NoteColor.getColor(selectedPageColor, darkModeOn).withOpacity(0.6),
          leading: Container(
            margin: const EdgeInsets.all(8.0),
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () {
                Navigator.pop(context, true);
              },
              child: const Icon(
                Iconsax.arrow_left_2,
                size: 15,
                color: Colors.black,
              ),
            ),
          ),
          actions: [
            IconButton(
              tooltip: "Edit Note",
              onPressed: () {
                _showEdit(context, note);
              },
              color: Colors.black,
              icon: const Icon(Iconsax.edit_2),
            ),
            IconButton(
              tooltip: "Note color swatch",
              onPressed: () {
                bool darkModeOn =
                    (globals.themeMode == ThemeMode.dark || (brightness == Brightness.dark && globals.themeMode == ThemeMode.system));
                showColorPalette(context, note, isDesktop, darkModeOn, (int value) {
                  setState(() {
                    selectedPageColor = value;
                  });
                }, widget.noteReferenceID);
                // _showColorPalette(context, note);
              },
              color: Colors.black,
              icon: const Icon(Iconsax.color_swatch),
            ),

            // Archive
            Visibility(
              visible: note.noteArchived == 0,
              child: IconButton(
                tooltip: 'Add Wishlist',
                onPressed: () async {
                  bool status = await FireStoreDatabaseHelper.checkIfWishlistExists(note.noteId, widget.noteReferenceID);
                  if (!status) {
                    FireStoreDatabaseHelper.addWishlist(note, widget.noteReferenceID);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        content: SuccessToast(
                            body: "Favourite Added Successfully",
                            title: "Message",
                            widget: Icon(Iconsax.tag, size: 16, color: Colors.white)),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        content: FancySnackBar(
                            body: "Already Added in Wishlist",
                            title: "Warning",
                            widget: Icon(Iconsax.warning_2, size: 16, color: Colors.white)),
                      ),
                    );
                  }
                },
                color: Colors.black,
                icon: const Icon(Iconsax.archive_add),
              ),
            ),

            IconButton(
              tooltip: "Delete note",
              onPressed: () {
                setState(() {
                  currentEditingNoteId = note.noteId;
                });
                confirmDeleteDialog(isDesktop, context, note, widget.noteReferenceID);
              },
              color: Colors.black,
              icon: const Icon(Iconsax.trash),
            )
          ],
        ),
        body: Consumer<NoteProvider>(
          builder: (context, noteProvider, child) => ListView(
            controller: scrollController,
            children: [
              const SizedBox(height: 10.0),
              Visibility(
                visible: note.noteTitle.isNotEmpty,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(left: 8),
                  alignment: Alignment.centerLeft,
                  //! Note title
                  child: Text(note.noteTitle, style: GoogleFonts.roboto(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold)),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(left: 8),
                alignment: Alignment.centerLeft,
                child: MarkdownBody(
                  styleSheet: MarkdownStyleSheet(
                    a: const TextStyle(
                      color: Colors.blueAccent,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w600,
                    ),
                    p: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  selectable: true,
                  shrinkWrap: true,
                  onTapLink: (text, href, title) {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            actionsPadding: const EdgeInsets.all(10),
                            title: const Text('Attention!'),
                            content: const Text('Do you want to open the link?'),
                            actions: [
                              OutlinedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('No'),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  // if (await canLaunch(href!)) {
                                  //   await launch(href, forceSafariVC: false, forceWebView: false);
                                  //   Navigator.pop(context);
                                  // } else {
                                  //   throw 'Could not launch';
                                  // }
                                },
                                child: const Text('Yes'),
                              ),
                            ],
                          );
                        });
                  },
                  data: note.noteText,
                  softLineBreak: true,
                  fitContent: true,
                ),
              ),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection(noteDetails)
                      .doc(widget.noteReferenceID)
                      .collection(referenceTitle)
                      .doc(widget.note.noteId)
                      .collection(referenceTitle)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshots) {
                    if (!snapshots.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      if (snapshots.data!.docs.isEmpty) {
                        return emptyReference(context);
                      } else {
                        return ListView.builder(
                            itemCount: snapshots.data!.docs.length,
                            shrinkWrap: true,
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              ReferenceModel referenceModel =
                                  ReferenceModel.fromJson(snapshots.data!.docs[index].data() as Map<String, dynamic>);
                              return InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (_) => ReferenceDetailsScreen(widget.note, referenceModel, widget.noteReferenceID)));
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  margin: const EdgeInsets.only(bottom: 13),
                                  decoration: BoxDecoration(
                                      color: NoteColor.getColor(selectedPageColor, darkModeOn),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.white.withOpacity(.6),
                                            blurRadius: 10.0,
                                            spreadRadius: 3.0,
                                            offset: const Offset(0.0, 0.0))
                                      ],
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          CircleAvatar(
                                              backgroundColor: kPrimaryColor,
                                              radius: 16,
                                              child: Text((index + 1).toString(), style: const TextStyle(color: Colors.white))),
                                          Row(
                                            children: [
                                              InkWell(
                                                  onTap: () {
                                                    Navigator.of(context).push(MaterialPageRoute(
                                                        builder: (_) => AddReferenceScreen(widget.note, widget.noteReferenceID,
                                                            isFromUpdate: true, referenceModel: referenceModel)));
                                                  },
                                                  child: const Icon(Iconsax.edit, color: Colors.green)),
                                              const SizedBox(width: 20),
                                              InkWell(
                                                  onTap: () {
                                                    FireStoreDatabaseHelper.deleteReferenceTitle(
                                                        referenceModel, widget.note.noteId, widget.noteReferenceID);
                                                  },
                                                  child: const Icon(Iconsax.close_circle, color: Colors.red)),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 7),
                                      Text(referenceModel.title),
                                    ],
                                  ),
                                ),
                              );
                            });
                      }
                    }
                  })
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          //color: Colors.transparent.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              children: [
                const Expanded(child: SizedBox()),
                Text("Last Edited: ${Utility.formatDateTime(note.noteDate)}",
                    style: GoogleFonts.roboto(fontSize: 18, fontWeight: FontWeight.w300)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showEdit(BuildContext context, Notes _note) async {
    await Navigator.of(context)
        .push(CupertinoPageRoute(builder: (BuildContext context) => EditNotePage(widget.noteReferenceID, note: _note, isFromUpdate: true)));
  }

  Future<bool> _onBackPressed() async {
    Navigator.pop(context, true);
    return false;
  }

  emptyReference(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 80),
          Image.asset("assets/illustrations/empty_test.png", alignment: Alignment.centerRight, height: 100),
          const SizedBox(height: 15),
          const Text('Your Reference Title List is empty!', style: TextStyle(fontWeight: FontWeight.w300, fontSize: 22)),
        ],
      ),
    );
  }
}
