import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:iconsax/iconsax.dart';
import 'package:product_buy_sell/helpers/color.dart';
import 'package:product_buy_sell/helpers/note_color.dart';
import 'package:product_buy_sell/models/notes_model.dart';
import 'package:product_buy_sell/models/reference_model.dart';
import 'package:product_buy_sell/pages/note/add_reference_details_screen.dart';
import '../../firebase/firestore_database_helper.dart';
import '/helpers/globals.dart' as globals;

class ReferenceDetailsScreen extends StatefulWidget {
  final Notes notes;
  final ReferenceModel referenceModel;
  final String noteReferenceID;

  const ReferenceDetailsScreen(this.notes, this.referenceModel, this.noteReferenceID, {Key? key}) : super(key: key);

  @override
  State<ReferenceDetailsScreen> createState() => _ReferenceDetailsScreenState();
}

class _ReferenceDetailsScreenState extends State<ReferenceDetailsScreen> {
  int selectedPageColor = 0;

  @override
  void initState() {
    selectedPageColor = widget.notes.noteColor;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool darkModeOn = (globals.themeMode == ThemeMode.dark || (brightness == Brightness.dark && globals.themeMode == ThemeMode.system));

    return Scaffold(
      backgroundColor: NoteColor.getColor(selectedPageColor, darkModeOn),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('Shuvo ${widget.noteReferenceID}');
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => AddReferenceDetailsScreen(widget.notes, widget.noteReferenceID, referenceModel: widget.referenceModel)));
        },
        backgroundColor: NoteColor.getColor(selectedPageColor, darkModeOn),
        child: const Icon(Icons.add, color: Colors.black, size: 35),
      ),
      appBar: AppBar(
        elevation: 0.2,
        backgroundColor: NoteColor.getColor(selectedPageColor, darkModeOn).withOpacity(0.6),
        title: Text(widget.notes.noteTitle, style: const TextStyle(color: Colors.black)),
        leading: Container(
          margin: const EdgeInsets.all(8.0),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () {
              Navigator.pop(context, true);
            },
            child: const Icon(Iconsax.arrow_left_2, size: 15, color: Colors.black),
          ),
        ),
      ),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
                color: NoteColor.getColor(selectedPageColor, darkModeOn).withOpacity(0.6),
                boxShadow: [
                  BoxShadow(color: Colors.white.withOpacity(.3), blurRadius: 10.0, spreadRadius: 3.0, offset: const Offset(0.0, 0.0))
                ],
                borderRadius: BorderRadius.circular(10)),
            child: MarkdownBody(
              styleSheet: MarkdownStyleSheet(
                a: const TextStyle(
                  color: Colors.blueAccent,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w600,
                ),
                p: const TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 20),
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
              data: widget.referenceModel.title,
              softLineBreak: true,
              fitContent: true,
            ),
          ),
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection(noteDetails)
                  .doc(widget.noteReferenceID)
                  .collection(referenceDetails)
                  .doc(widget.notes.noteId + widget.referenceModel.referenceId)
                  .collection(referenceDetails)
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
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          ReferenceModel referenceModel =
                              ReferenceModel.fromJson(snapshots.data!.docs[index].data() as Map<String, dynamic>);
                          return Container(
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.only(bottom: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: NoteColor.getColor(selectedPageColor, darkModeOn),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.white.withOpacity(.6),
                                    blurRadius: 10.0,
                                    spreadRadius: 3.0,
                                    offset: const Offset(0.0, 0.0))
                              ],
                            ),
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
                                        radius: 13,
                                        child: Text((index + 1).toString(), style: const TextStyle(color: Colors.white))),
                                    Row(
                                      children: [
                                        InkWell(
                                            onTap: () {
                                              Navigator.of(context).push(MaterialPageRoute(
                                                  builder: (_) => AddReferenceDetailsScreen(widget.notes, widget.noteReferenceID,
                                                      isFromUpdate: true,
                                                      referenceModel: referenceModel,
                                                      referenceModel2: widget.referenceModel)));
                                            },
                                            child: const Icon(Iconsax.edit, color: Colors.green)),
                                        const SizedBox(width: 20),
                                        InkWell(
                                            onTap: () {
                                              FireStoreDatabaseHelper.deleteReferenceDetails(referenceModel, widget.notes.noteId,
                                                  widget.referenceModel.referenceId, widget.noteReferenceID);
                                            },
                                            child: const Icon(Iconsax.close_circle, color: Colors.red)),
                                      ],
                                    ),
                                  ],
                                ),
                                Container(
                                    margin: const EdgeInsets.only(top: 10),
                                    padding: const EdgeInsets.all(10),
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        border: Border.all(color: NoteColor.getColor(selectedPageColor, darkModeOn).withOpacity(0.4)),
                                        borderRadius: BorderRadius.circular(10)),
                                    child: Text(referenceModel.title)),
                              ],
                            ),
                          );
                        });
                  }
                }
              })
        ],
      ),
    );
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
          const Text('Your Reference Details List is empty!', style: TextStyle(fontWeight: FontWeight.w300, fontSize: 22)),
        ],
      ),
    );
  }
}
