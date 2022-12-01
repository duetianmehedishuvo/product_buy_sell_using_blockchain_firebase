import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:product_buy_sell/pages/note/edit_note_page_pre.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:product_buy_sell/dialog/confirm_dialog.dart';
import 'package:product_buy_sell/firebase/firestore_database_helper.dart';
import 'package:product_buy_sell/pages/note/home_page.dart';
import 'package:product_buy_sell/provider/note_provider.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:uuid/uuid.dart';

import '/helpers/globals.dart' as globals;
import '../../helpers/adaptive.dart';
import '../../helpers/note_color.dart';
import '../../helpers/utility.dart';
import '../../models/labels_model.dart';
import '../../models/notes_model.dart';
import '../../notes_navigation.dart';
import '../../widgets/color_palette_button.dart';
import '../../widgets/fancy_toasts.dart';
import '../../widgets/grid_note.dart';
import '../../widgets/list_note.dart';

class HomePagePre extends StatefulWidget {
  HomePagePre({Key? key}) : super(key: HomePagePre.staticGlobalKey);

  static final GlobalKey<_HomePagePre> staticGlobalKey = GlobalKey<_HomePagePre>();

  @override
  _HomePagePre createState() => _HomePagePre();
}

class _HomePagePre extends State<HomePagePre> {
  late SharedPreferences sharedPreferences;
  late ViewType _viewType;
  ViewType viewType = ViewType.Tile;
  ScrollController scrollController = ScrollController();
  List<Notes> notesListAll = [];
  List<Notes> notesList = [];
  List<Labels> labelList = [];
  bool isLoading = false;
  bool hasData = false;
  String name = "";
  bool isAndroid = UniversalPlatform.isAndroid;
  bool isIOS = UniversalPlatform.isIOS;
  bool isWeb = UniversalPlatform.isWeb;
  bool isDesktop = false;
  String currentLabel = "";
  bool labelChecked = false;

  var uuid = const Uuid();
  final TextEditingController _noteTitleController = TextEditingController();
  final TextEditingController _noteTextController = TextEditingController();
  String currentEditingNoteId = "";
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int selectedPageColor = 1;

  getPref() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      bool isTile = sharedPreferences.getBool("is_tile") ?? false;
      _viewType = isTile ? ViewType.Tile : ViewType.Grid;
      viewType = isTile ? ViewType.Tile : ViewType.Grid;
    });
  }

  void toggleView(ViewType viewType) {
    setState(() {
      _viewType = viewType;
      sharedPreferences.setBool("is_tile", _viewType == ViewType.Tile);
    });
  }

  @override
  void initState() {
    getPref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool darkModeOn = (globals.themeMode == ThemeMode.dark || (brightness == Brightness.dark && globals.themeMode == ThemeMode.system));
    isDesktop = isDisplayDesktop(context);
    bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 0,
        title: Text(
          "In Search Of Truth",
          textAlign: TextAlign.start,
          style: GoogleFonts.roboto(letterSpacing: 0.5, fontSize: 25, fontWeight: FontWeight.w500, color: Colors.black),
        ),
        actions: [
          Visibility(
            visible: viewType == ViewType.Tile,
            child: CircleAvatar(
              radius: 25,
              backgroundColor: darkModeOn ? Colors.grey.shade800 : Colors.white,
              child: IconButton(
                splashRadius: 24,
                icon: SvgPicture.asset(
                  "assets/svg/apps-delete.svg",
                  color: Colors.teal,
                  height: 23,
                ),
                onPressed: () {
                  setState(() {
                    viewType = ViewType.Grid;
                    HomePagePre.staticGlobalKey.currentState!.toggleView(viewType);
                  });
                },
              ),
            ),
          ),
          Visibility(
            visible: viewType == ViewType.Grid,
            child: CircleAvatar(
              radius: 25,
              backgroundColor: darkModeOn ? Colors.grey.shade800 : Colors.white,
              child: IconButton(
                splashRadius: 23,
                icon: SvgPicture.asset(
                  "assets/svg/apps-sort.svg",
                  color: Colors.teal,
                  height: 25,
                ),
                onPressed: () {
                  setState(() {
                    viewType = ViewType.Tile;
                    HomePagePre.staticGlobalKey.currentState!.toggleView(viewType);
                  });
                },
              ),
            ),
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            TextField(
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
            Expanded(
                child: Consumer<NoteProvider>(
              builder: (context, noteProvider, child) => StreamBuilder(
                  stream: FirebaseFirestore.instance.collection(noteTopic).snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshots) {
                    if (!snapshots.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      if (snapshots.data!.docs.isEmpty) {
                        return emptyNotes();
                      } else {
                        return _viewType == ViewType.Grid
                            ? staggeredNotes(snapshots.data!.docs, isPortrait, noteProvider)
                            : listedNotes(snapshots.data!.docs, noteProvider);
                      }
                    }
                  }),
            )),
          ],
        ),
      ),
      floatingActionButton: addNoteFAB(context, darkModeOn),
    );
  }

  addNoteFAB(BuildContext context, darkModeOn) {
    return FloatingActionButton(
      backgroundColor: darkModeOn ? Colors.grey.shade800 : Colors.white,
      elevation: 0,
      focusElevation: 0,
      hoverElevation: 0,
      highlightElevation: 0,
      onPressed: () {
        setState(() {
          _noteTextController.text = '';
          _noteTitleController.text = '';
          currentEditingNoteId = "";
        });
        _showEdit(context, Notes('', '', '', '', '', 0, 0, ''));
      },
      child: SvgPicture.asset("assets/svg/add-document.svg", color: Colors.teal),
    );
  }

//for list type noted
  listedNotes(List<QueryDocumentSnapshot> questionLists, NoteProvider noteProvider) {
    return Container(
      alignment: Alignment.center,
      margin: isDesktop ? const EdgeInsets.symmetric(horizontal: 200) : const EdgeInsets.all(0),
      child: ListView.builder(
        itemCount: questionLists.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          Notes note = Notes.fromJson(questionLists[index].data() as Map<String, dynamic>);

          if (name.isEmpty) {
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

//staggerded grid notes
  staggeredNotes(List<QueryDocumentSnapshot> questionLists, bool isPortrait, NoteProvider noteProvider) {
    return Container(
      margin: isPortrait ? EdgeInsets.zero : const EdgeInsets.symmetric(horizontal: 200),
      child: MasonryGridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 0,
        physics: const BouncingScrollPhysics(),
        itemCount: questionLists.length,
        itemBuilder: (context, index) {
          Notes note = Notes.fromJson(questionLists[index].data() as Map<String, dynamic>);

          if (name.isEmpty) {
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
              isFromPreHome: true,
            );
          }

          if (note.noteTitle.toLowerCase().startsWith(name.toLowerCase())) {
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
              isFromPreHome: true,
            );
          }
          return Container();
        },
      ),
    );
  }

//illustration for empty notes
  emptyNotes() {
    return Container(
      alignment: Alignment.topCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 150),
          //TODO: Edit image colors to match across app
          Image.asset("assets/illustrations/pixeltrue-vision-1.png"),
          const SizedBox(height: 20),
          Text(
            'Tap the add button\nto add a note!',
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(fontWeight: FontWeight.w300, fontSize: 22),
          ),
        ],
      ),
    );
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
                side: BorderSide(color: darkModeOn ? Colors.white24 : Colors.black12), borderRadius: BorderRadius.circular(10)),
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
        constraints: isDesktop ? const BoxConstraints(maxWidth: 350, minWidth: 350) : const BoxConstraints(),
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
                              _noteTextController.text = Utility.stripTags(_note.noteText);
                              _noteTitleController.text = _note.noteTitle;
                              currentEditingNoteId = _note.noteId;
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
                            Navigator.of(context).pop();
                            setState(() {
                              currentEditingNoteId = _note.noteId;
                            });
                            confirmDeleteDialog(isDesktop, context, _note, "", isFromHome: true, isWishlist: true);
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
                                  child: Text('Delete'),
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
            return Dialog(
              child: SizedBox(width: isDesktop ? 800 : MediaQuery.of(context).size.width, child: HomePage(notes: _note)),
            );
          });
    } else {
      bool res = await Navigator.of(context).push(CupertinoPageRoute(builder: (BuildContext context) => HomePage(notes: _note)));
    }
  }

  void _confirmDelete() async {
    isDesktop = isDisplayDesktop(context);
    showModalBottomSheet(
        context: context,
        isDismissible: true,
        constraints: isDesktop ? const BoxConstraints(maxWidth: 450, minWidth: 400) : const BoxConstraints(),
        builder: (context) {
          return Container(
            decoration: const BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))),
            margin: const EdgeInsets.only(bottom: 10.0),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: SizedBox(
                height: 170,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text('Confirm', style: GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.w700)),
                      ),
                      const Padding(padding: EdgeInsets.all(10), child: Text('Are you sure you want to delete?')),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                    foregroundColor: const Color.fromARGB(255, 204, 118, 112),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('No'),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(255, 204, 118, 112),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      backgroundColor: Colors.transparent,
                                      elevation: 0,
                                      content: InfoToast(
                                        body: "You have deleted a note",
                                        title: "Deleted",
                                        widget: Icon(
                                          Iconsax.trash,
                                          size: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  );
                                  Navigator.pop(context, true);
                                },
                                child: const Text('Yes'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  void _showEdit(BuildContext context, Notes _note) async {
    if (!UniversalPlatform.isDesktop) {
      final res = await Navigator.of(context).push(CupertinoPageRoute(builder: (BuildContext context) => EditNotePagePre(note: _note)));
    } else {
      openDialog(EditNotePagePre(note: _note));
    }
  }

  String getDateString() {
    var formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    DateTime dt = DateTime.now();
    return formatter.format(dt);
  }
}
