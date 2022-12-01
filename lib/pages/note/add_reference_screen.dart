import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:product_buy_sell/helpers/note_color.dart';
import 'package:product_buy_sell/models/notes_model.dart';
import 'package:product_buy_sell/models/reference_model.dart';
import 'package:product_buy_sell/provider/note_provider.dart';
import 'package:product_buy_sell/widgets/custom_button.dart';
import 'package:product_buy_sell/widgets/custom_text_field_2.dart';

import '/helpers/globals.dart' as globals;

class AddReferenceScreen extends StatefulWidget {
  final Notes note;
  final bool isFromUpdate;
  final ReferenceModel? referenceModel;
  final String referenceID;

  const AddReferenceScreen(this.note, this.referenceID,{this.referenceModel, this.isFromUpdate = false, Key? key}) : super(key: key);

  @override
  State<AddReferenceScreen> createState() => _AddReferenceScreenState();
}

class _AddReferenceScreenState extends State<AddReferenceScreen> {
  int selectedPageColor = 0;
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    selectedPageColor = widget.note.noteColor;
    textEditingController = TextEditingController();
    if (widget.isFromUpdate) {
      textEditingController.text = widget.referenceModel!.title;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool darkModeOn = (globals.themeMode == ThemeMode.dark || (brightness == Brightness.dark && globals.themeMode == ThemeMode.system));

    return Scaffold(
      backgroundColor: NoteColor.getColor(selectedPageColor, darkModeOn),
      bottomNavigationBar: Consumer<NoteProvider>(
        builder: (context, noteProvider, child) => Container(
          height: 50,
          margin: const EdgeInsets.only(bottom: 40),
          child: CustomButton(
              btnTxt: '${widget.isFromUpdate ? 'Update' : 'Add'} Reference',
              onTap: () {
                if (textEditingController.text.isEmpty) {
                } else {
                  ReferenceModel referenceModel = ReferenceModel('', '');
                  if (widget.isFromUpdate) {
                    referenceModel = ReferenceModel(widget.referenceModel!.referenceId, textEditingController.text);
                    noteProvider.updateNoteTitle(referenceModel, widget.note.noteId, widget.referenceID, context).then((value) {
                      if (value) {
                        textEditingController.clear();
                        Navigator.of(context).pop();
                      }
                    });
                  } else {
                    referenceModel = ReferenceModel(DateTime.now().microsecondsSinceEpoch.toString(), textEditingController.text);

                    noteProvider.addNoteTitle(referenceModel, widget.note.noteId, widget.referenceID,context).then((value) {
                      if (value) {
                        textEditingController.clear();
                        Navigator.of(context).pop();
                      }
                    });
                  }
                }
              },
              radius: 0,
              backgroundColor: Colors.green),
        ),
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
              child: const Icon(Iconsax.arrow_left_2, size: 15, color: Colors.black)),
        ),
        title: Text(widget.note.noteTitle, style: const TextStyle(color: Colors.black)),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          CustomTextField2(
            controller: textEditingController,
            hintText: 'Write Your reference title',
            maxLines: null,
            fillColor: NoteColor.getColor(selectedPageColor, darkModeOn).withOpacity(0.6),
            isCancelShadow: true,
            inputType: TextInputType.multiline,
            inputAction: TextInputAction.newline,
          ),
        ],
      ),
    );
  }
}
