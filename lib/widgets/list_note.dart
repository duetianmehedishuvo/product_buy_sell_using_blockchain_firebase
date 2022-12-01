import 'package:flutter/material.dart';
import '/helpers/globals.dart' as globals;
import '../helpers/note_color.dart';
import '../helpers/utility.dart';
import '../models/notes_model.dart';

class NoteCardList extends StatefulWidget {
  final Notes? note;
  final Function onTap;
  final Function? onLongPress;
  final bool isFromPreHome;

  const NoteCardList({Key? key, this.note, required this.onTap, this.onLongPress, this.isFromPreHome = false}) : super(key: key);

  @override
  _NoteCardListState createState() => _NoteCardListState();
}

class _NoteCardListState extends State<NoteCardList> {
  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool darkModeOn = (globals.themeMode == ThemeMode.dark || (brightness == Brightness.dark && globals.themeMode == ThemeMode.system));
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Card(
        color: NoteColor.getColor(widget.note!.noteColor, darkModeOn),
        child: InkWell(
          onTap: () => widget.onTap(),
          onLongPress: () => widget.onLongPress!(),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible: widget.note!.noteTitle.isNotEmpty,
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Text(
                      widget.note!.noteTitle,
                      style: const TextStyle(fontSize: 16.0, color: Colors.black, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                widget.isFromPreHome
                    ? SizedBox.shrink()
                    : Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(widget.note!.noteText,
                            style: const TextStyle(color: Colors.black54), maxLines: 4, overflow: TextOverflow.ellipsis),
                      ),
                widget.isFromPreHome
                    ? Text(Utility.formatDateTime(widget.note!.noteDate), style: const TextStyle(color: Colors.black54, fontSize: 12.0))
                    : Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.note!.noteLabel.replaceAll(",", ", "),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.black54,
                                  fontSize: 12.0,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                Utility.formatDateTime(widget.note!.noteDate),
                                textAlign: TextAlign.end,
                                style: const TextStyle(color: Colors.black54, fontSize: 12.0),
                              ),
                            ),
                          ],
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
