
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

//import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:product_buy_sell/helpers/adaptive.dart';
import 'package:product_buy_sell/models/notes_model.dart';
import 'package:product_buy_sell/notes_navigation.dart';
import 'package:product_buy_sell/pages/note/edit_note_page.dart';
import 'package:product_buy_sell/widgets/grid_note.dart';
import 'package:product_buy_sell/widgets/list_note.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:product_buy_sell/dialog/confirm_dialog.dart';
import 'package:product_buy_sell/firebase/firestore_database_helper.dart';
import 'package:product_buy_sell/helpers/note_color.dart';
import 'package:product_buy_sell/provider/note_provider.dart';
import 'package:product_buy_sell/widgets/color_palette_button.dart';
import 'package:universal_platform/universal_platform.dart';

import '/helpers/globals.dart' as globals;
import 'note_preview.dart';

class FavouriteScreen extends StatefulWidget {
  final String referenceID;

  const FavouriteScreen(this.referenceID, {Key? key}) : super(key: key);

  @override
  _FavouriteScreenState createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  bool isLoading = false;
  late ViewType _viewType;

  late SharedPreferences sharedPreferences;

  int selectedPageColor = 1;

  bool isDesktop = false;

  getPref() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      bool isTile = sharedPreferences.getBool("is_tile") ?? false;
      _viewType = isTile ? ViewType.Tile : ViewType.Grid;
    });
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool darkModeOn = (globals.themeMode == ThemeMode.dark || (brightness == Brightness.dark && globals.themeMode == ThemeMode.system));
    isDesktop = isDisplayDesktop(context);
    bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
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
          "My Favourite",
          textAlign: TextAlign.start,
          style: GoogleFonts.roboto(letterSpacing: 0.5, fontSize: 25, fontWeight: FontWeight.w500, color: Colors.black),
        ),

      ),
      body: Consumer<NoteProvider>(
        builder: (context, noteProvider, child) => StreamBuilder(
        stream: FirebaseFirestore.instance.collection(noteDetails).doc(widget.referenceID).collection(wishlist).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshots) {
          if (!snapshots.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (snapshots.data!.docs.isEmpty) {
              return emptyArchive(context);
            } else {
              return _viewType == ViewType.Grid
                  ? staggeredNotes(snapshots.data!.docs, isPortrait, noteProvider)
                  : listedNotes(snapshots.data!.docs, noteProvider);
            }
          }
        }),
      ),
    );
  }

//for list type noted
  listedNotes(List<QueryDocumentSnapshot> questionLists, NoteProvider noteProvider) {
    return Container(
      alignment: Alignment.center,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: questionLists.length,
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        itemBuilder: (context, index) {
          Notes note = Notes.fromJson(questionLists[index].data() as Map<String, dynamic>);

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
          );
        },
      ),
    );
  }

//staggerded grid notes
  staggeredNotes(List<QueryDocumentSnapshot> questionLists, bool isPortrait, NoteProvider noteProvider) {
    return MasonryGridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 8,
      mainAxisSpacing: 0,
      padding: EdgeInsets.zero,
      physics: const BouncingScrollPhysics(),
      itemCount: questionLists.length,
      // staggeredTileBuilder: (index) {
      //   return StaggeredTile.count(1, index.isOdd ? 0.9 : 1.02);
      // },
      itemBuilder: (context, index) {
        Notes note = Notes.fromJson(questionLists[index].data() as Map<String, dynamic>);
        return NoteCardGrid(
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
        );
      },
    );
  }

  archiveTopBar(BuildContext context, darkModeOn) {
    return Container(
      padding: const EdgeInsets.only(top: 35.0, left: 5, right: 25.0),
      color: Colors.teal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  tooltip: "Back",
                  icon: Icon(Icons.adaptive.arrow_back, color: Colors.white),
                  splashRadius: 24),
              Text("My Favourite",
                  style: GoogleFonts.roboto(color: Colors.white, letterSpacing: 0.5, fontSize: 20, fontWeight: FontWeight.w400)),
            ],
          ),
        ],
      ),
    );
  }

//an emty archive
  emptyArchive(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 80,
          ),
          Image.asset(
            "assets/illustrations/empty_test.png",
            alignment: Alignment.centerRight,
            height: MediaQuery.of(context).size.height * 0.4,
          ),
          SizedBox(height: 15),
          const Text(
            'Your Favourite List is empty!',
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 22,
            ),
          ),
        ],
      ),
    );
  }

  String getDateString() {
    var formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    DateTime dt = DateTime.now();
    return formatter.format(dt);
  }

  openDialog(Widget page) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool darkModeOn = (globals.themeMode == ThemeMode.dark || (brightness == Brightness.dark && globals.themeMode == ThemeMode.system));
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            backgroundColor: darkModeOn ? Colors.black : Colors.white,
            shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: darkModeOn ? Colors.white24 : Colors.black12,
                ),
                borderRadius: BorderRadius.circular(10)),
            child: Container(
              decoration: BoxDecoration(
                color: darkModeOn ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              constraints: const BoxConstraints(maxWidth: 600, minWidth: 400, minHeight: 600, maxHeight: 600),
              padding: const EdgeInsets.all(8),
              child: page,
            ),
          );
        });
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
        constraints: isDesktop ? const BoxConstraints(maxWidth: 450, minWidth: 400) : const BoxConstraints(),
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
              return SizedBox(
                height: 350,
                child: SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      // mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        InkWell(
                          borderRadius: BorderRadius.circular(15),
                          onTap: () {
                            Navigator.of(context).pop();
                            setState(() {
                              // _noteTextController.text = Utility.stripTags(_note.noteText);
                              // _noteTitleController.text = _note.noteTitle;
                              // currentEditingNoteId = _note.noteId;
                            });
                            _showEdit(context, _note);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: const <Widget>[
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(Iconsax.edit_2),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Edit'),
                                ),
                              ],
                            ),
                          ),
                        ),
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
                                  onTap: () {
                                    Notes n = _note;
                                    n.noteColor = 0;
                                    FireStoreDatabaseHelper.updateQuestion(n, widget.referenceID);
                                    FireStoreDatabaseHelper.updateWishlist(n, widget.referenceID);
                                    Navigator.pop(context);
                                  },
                                  isSelected: _note.noteColor == 0,
                                ),
                                ColorPaletteButton(
                                  color: NoteColor.getColor(1, darkModeOn),
                                  onTap: () {
                                    Notes n = _note;
                                    n.noteColor = 1;
                                    FireStoreDatabaseHelper.updateQuestion(n, widget.referenceID);
                                    FireStoreDatabaseHelper.updateWishlist(n, widget.referenceID);
                                    Navigator.pop(context);
                                  },
                                  isSelected: _note.noteColor == 1,
                                ),
                                ColorPaletteButton(
                                  color: NoteColor.getColor(2, darkModeOn),
                                  onTap: () {
                                    Notes n = _note;
                                    n.noteColor = 2;
                                    FireStoreDatabaseHelper.updateQuestion(n, widget.referenceID);
                                    FireStoreDatabaseHelper.updateWishlist(n, widget.referenceID);
                                    Navigator.pop(context);
                                  },
                                  isSelected: _note.noteColor == 2,
                                ),
                                ColorPaletteButton(
                                  color: NoteColor.getColor(3, darkModeOn),
                                  onTap: () {
                                    Notes n = _note;
                                    n.noteColor = 3;
                                    FireStoreDatabaseHelper.updateQuestion(n, widget.referenceID);
                                    FireStoreDatabaseHelper.updateWishlist(n, widget.referenceID);
                                    Navigator.pop(context);
                                  },
                                  isSelected: _note.noteColor == 3,
                                ),
                                ColorPaletteButton(
                                  color: NoteColor.getColor(4, darkModeOn),
                                  onTap: () {
                                    Notes n = _note;
                                    n.noteColor = 4;
                                    FireStoreDatabaseHelper.updateQuestion(n, widget.referenceID);
                                    FireStoreDatabaseHelper.updateWishlist(n, widget.referenceID);
                                    Navigator.pop(context);
                                  },
                                  isSelected: _note.noteColor == 4,
                                ),
                                ColorPaletteButton(
                                  color: NoteColor.getColor(5, darkModeOn),
                                  onTap: () {
                                    Notes n = _note;
                                    n.noteColor = 5;
                                    FireStoreDatabaseHelper.updateQuestion(n, widget.referenceID);
                                    FireStoreDatabaseHelper.updateWishlist(n, widget.referenceID);
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
                            Navigator.of(context).pop();
                            setState(() {
                              // currentEditingNoteId = _note.noteId;
                            });
                            confirmDeleteDialog(isDesktop, context, _note, isWishlist: true, widget.referenceID);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: const <Widget>[
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(Iconsax.trash),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Un-Favourite'),
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
                        const SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        });
  }

  void _showNoteReader(BuildContext context, Notes _note) async {
    isDesktop = isDisplayDesktop(context);
    if (isDesktop) {
      bool res = await showDialog(
          context: context,
          builder: (context) {
            // ignore: avoid_unnecessary_containers
            return Container(
              child: Dialog(
                child: SizedBox(
                  width: isDesktop ? 800 : MediaQuery.of(context).size.width,
                  child: NoteReaderPage(
                    widget.referenceID,
                    note: _note,
                  ),
                ),
              ),
            );
          });
    } else {
      bool res = await Navigator.of(context).push(CupertinoPageRoute(
          builder: (BuildContext context) => NoteReaderPage(
            widget.referenceID,
                note: _note,
              )));
    }
  }

  void _showEdit(BuildContext context, Notes _note) async {
    if (!UniversalPlatform.isDesktop) {
      final res = await Navigator.of(context)
          .push(CupertinoPageRoute(builder: (BuildContext context) => EditNotePage(widget.referenceID, note: _note)));
    } else {
      openDialog(EditNotePage(widget.referenceID, note: _note));
    }
  }

// Future<bool> _onBackPressed() async {
//   if (!(_noteTitleController.text.isEmpty ||
//       _noteTextController.text.isEmpty)) {
//     _saveNote();
//   }
//   return true;
// }

}
