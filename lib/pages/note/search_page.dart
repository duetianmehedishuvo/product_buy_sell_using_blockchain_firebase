// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:product_buy_sell/models/notes_model.dart';
import 'package:product_buy_sell/widgets/list_note.dart';
import 'package:provider/provider.dart';
import 'package:product_buy_sell/firebase/firestore_database_helper.dart';
import 'package:product_buy_sell/helpers/adaptive.dart';
import 'package:product_buy_sell/helpers/note_color.dart';
import 'package:product_buy_sell/provider/note_provider.dart';
import 'package:product_buy_sell/widgets/color_palette_button.dart';
import '/helpers/globals.dart' as globals;
import 'note_preview.dart';

class SearchPage extends StatefulWidget {
  final String referenceID;

  const SearchPage(this.referenceID, {Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Notes> notesList = [];
  int selectedPageColor = 1;
  final TextEditingController _searchController = TextEditingController();
  String name = "";
  final FocusNode searchFocusNode = FocusNode();
  bool isDesktop = false;

  bool _showClearButton = false;

  @override
  void initState() {
    // loadNotes();
    _searchController.addListener(() {
      setState(() {
        _showClearButton = _searchController.text.isNotEmpty;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool darkModeOn = (globals.themeMode == ThemeMode.dark || (brightness == Brightness.dark && globals.themeMode == ThemeMode.system));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          tooltip: "Back",
          icon: Icon(Icons.adaptive.arrow_back,color: Colors.black),
          splashRadius: 24,
        ),
        title: Text(
          "Search notes",
          textAlign: TextAlign.start,
          style: GoogleFonts.roboto(letterSpacing: 0.5, fontSize: 25, fontWeight: FontWeight.w500, color: Colors.black),
        ),
        actions: [
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  offset: const Offset(12, 26),
                  blurRadius: 50,
                  spreadRadius: 0,
                  color: Colors.grey.withOpacity(.25),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 25,
              backgroundColor: Theme.of(context).cardColor,
              child: const Icon(
                Iconsax.search_favorite,
                size: 25,
                color: Colors.greenAccent,
              ),
            ),
          )
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          searchTextField(darkModeOn),
          Expanded(
              child: Consumer<NoteProvider>(
            builder: (context, noteProvider, child) => StreamBuilder(
                stream: FirebaseFirestore.instance.collection(noteTopic).snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshots) {
                  if (!snapshots.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    if (snapshots.data!.docs.isEmpty) {
                      return emptySearchIllustration(context);
                    } else {
                      return listedNotes(snapshots.data!.docs, noteProvider);
                    }
                  }
                }),
          )),
        ],
      ),
    );
  }

  listedNotes(List<QueryDocumentSnapshot> questionLists, NoteProvider noteProvider) {
    return Container(
      alignment: Alignment.center,
      child: ListView.builder(
        itemCount: questionLists.length,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        itemBuilder: (context, index) {
          Notes note = Notes.fromJson(questionLists[index].data() as Map<String, dynamic>);

          if (name.isEmpty) {
            return Container();
          }

          if (note.noteTitle.toLowerCase().startsWith(name.toLowerCase())) {
            return NoteCardList(
              note: note,
              onTap: () {
                setState(() {
                  selectedPageColor = note.noteColor;
                });
                _showNoteReader(context, note);
              },
              onLongPress: () {
                _showOptionsSheet(context, note, noteProvider);
              },
              isFromPreHome: true,
            );
          }
          return Container();
        },
      ),
    );
  }

//! Bottom sheet onhold
  void _showOptionsSheet(BuildContext context, Notes _note, NoteProvider noteProvider) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool darkModeOn = brightness == Brightness.dark;
    isDesktop = isDisplayDesktop(context);
    showModalBottomSheet(
        context: context,
        isDismissible: true,
        isScrollControlled: true,
        constraints: isDesktop ? const BoxConstraints(maxWidth: 150, minWidth: 150) : const BoxConstraints(),
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
              return SizedBox(
                height: 240,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    // mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      InkWell(
                        borderRadius: BorderRadius.circular(15),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: const <Widget>[
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(Iconsax.color_swatch),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Color Tone'),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 60,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            children: [
                              ColorPaletteButton(
                                color: NoteColor.getColor(0, darkModeOn),
                                onTap: () async {
                                  Notes n = _note;
                                  n.noteColor = 0;

                                  FireStoreDatabaseHelper.updateNodeTopic(n);

                                  Navigator.pop(context);
                                },
                                isSelected: _note.noteColor == 0,
                              ),
                              ColorPaletteButton(
                                color: NoteColor.getColor(1, darkModeOn),
                                onTap: () async {
                                  Notes n = _note;
                                  n.noteColor = 1;
                                  FireStoreDatabaseHelper.updateNodeTopic(n);

                                  Navigator.pop(context);
                                },
                                isSelected: _note.noteColor == 1,
                              ),
                              ColorPaletteButton(
                                color: NoteColor.getColor(2, darkModeOn),
                                onTap: () async {
                                  Notes n = _note;
                                  n.noteColor = 2;
                                  FireStoreDatabaseHelper.updateNodeTopic(n);

                                  Navigator.pop(context);
                                },
                                isSelected: _note.noteColor == 2,
                              ),
                              ColorPaletteButton(
                                color: NoteColor.getColor(3, darkModeOn),
                                onTap: () async {
                                  Notes n = _note;
                                  n.noteColor = 3;
                                  FireStoreDatabaseHelper.updateNodeTopic(n);

                                  Navigator.pop(context);
                                },
                                isSelected: _note.noteColor == 3,
                              ),
                              ColorPaletteButton(
                                color: NoteColor.getColor(4, darkModeOn),
                                onTap: () async {
                                  Notes n = _note;
                                  n.noteColor = 4;
                                  FireStoreDatabaseHelper.updateNodeTopic(n);

                                  Navigator.pop(context);
                                },
                                isSelected: _note.noteColor == 4,
                              ),
                              ColorPaletteButton(
                                color: NoteColor.getColor(5, darkModeOn),
                                onTap: () async {
                                  Notes n = _note;
                                  n.noteColor = 5;
                                  FireStoreDatabaseHelper.updateNodeTopic(n);

                                  Navigator.pop(context);
                                },
                                isSelected: _note.noteColor == 5,
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(15),
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: const <Widget>[
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(Iconsax.close_circle),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Cancel'),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              );
            },
          );
        });
  }

  searchTextField(bool darkModeOn) {
    return Row(
      children: [
        const SizedBox(width: 20),
        Expanded(
          child: TextField(
            controller: _searchController,
            focusNode: searchFocusNode,
            decoration: InputDecoration(
              hintText: 'Search',
              prefixIcon: const Icon(Iconsax.search_favorite),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: Colors.blue),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: Colors.purple),
              ),
            ),
            onChanged: (val) {
              setState(() {
                name = val;
              });
            },
          ),
        ),
        const SizedBox(width: 10),
        Visibility(
          visible: _showClearButton,
          child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () {
                setState(() {
                  _searchController.clear();
                });
                notesList.clear();
              },
              child: const Icon(Iconsax.close_circle)),
        ),
        const SizedBox(width: 10),
      ],
    );
  }

//simlple searching illustration
  emptySearchIllustration(BuildContext context) {
    return Visibility(
      visible: _searchController.text.isEmpty,
      child: Expanded(
        child: Container(
          alignment: Alignment.topCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 19,
              ),
              Image.asset("assets/illustrations/fogg-searching-a-book.png"),
              const SizedBox(height: 20),
              const Text(
                'Browse your notes',
                style: TextStyle(fontWeight: FontWeight.w300, fontSize: 22),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showNoteReader(BuildContext context, Notes _note) async {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (BuildContext context) => NoteReaderPage(
          widget.referenceID,
          note: _note,
        ),
      ),
    );
  }
}
