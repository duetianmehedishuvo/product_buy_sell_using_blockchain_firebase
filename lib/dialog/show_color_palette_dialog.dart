import 'package:flutter/material.dart';
import 'package:product_buy_sell/firebase/firestore_database_helper.dart';
import 'package:product_buy_sell/helpers/note_color.dart';
import 'package:product_buy_sell/models/notes_model.dart';
import 'package:product_buy_sell/widgets/color_palette_button.dart';

void showColorPalette(BuildContext context, Notes _note, bool isDesktop, bool darkModeOn, Function callBack,String referenceID) {
  showModalBottomSheet(
      context: context,
      isDismissible: true,
      constraints: isDesktop ? const BoxConstraints(maxWidth: 450, minWidth: 400) : const BoxConstraints(),
      builder: (context) {
        return Container(
          margin: const EdgeInsets.only(bottom: 30),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: SizedBox(
              height: 60,
              child: ListView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                children: [
                  ColorPaletteButton(
                    color: NoteColor.getColor(0, darkModeOn),
                    onTap: () async {
                      Notes n = _note;
                      n.noteColor = 0;

                      FireStoreDatabaseHelper.updateQuestion(n,referenceID);
                      bool status = await FireStoreDatabaseHelper.checkIfWishlistExists(n.noteId,referenceID);
                      if (status) FireStoreDatabaseHelper.updateWishlist(n,referenceID);
                      callBack(0);
                      Navigator.pop(context);
                    },
                    isSelected: _note.noteColor == 0,
                  ),
                  ColorPaletteButton(
                    color: NoteColor.getColor(1, darkModeOn),
                    onTap: () async {
                      Notes n = _note;
                      n.noteColor = 1;

                      FireStoreDatabaseHelper.updateQuestion(n,referenceID);
                      bool status = await FireStoreDatabaseHelper.checkIfWishlistExists(n.noteId,referenceID);
                      if (status) FireStoreDatabaseHelper.updateWishlist(n,referenceID);
                      callBack(1);
                      Navigator.pop(context);
                    },
                    isSelected: _note.noteColor == 1,
                  ),
                  ColorPaletteButton(
                    color: NoteColor.getColor(2, darkModeOn),
                    onTap: () async {
                      Notes n = _note;
                      n.noteColor = 2;

                      FireStoreDatabaseHelper.updateQuestion(n,referenceID);
                      bool status = await FireStoreDatabaseHelper.checkIfWishlistExists(n.noteId,referenceID);
                      if (status) FireStoreDatabaseHelper.updateWishlist(n,referenceID);
                      callBack(2);
                      Navigator.pop(context);
                    },
                    isSelected: _note.noteColor == 2,
                  ),
                  ColorPaletteButton(
                    color: NoteColor.getColor(3, darkModeOn),
                    onTap: () async {
                      Notes n = _note;
                      n.noteColor = 3;

                      FireStoreDatabaseHelper.updateQuestion(n,referenceID);
                      bool status = await FireStoreDatabaseHelper.checkIfWishlistExists(n.noteId,referenceID);
                      if (status) FireStoreDatabaseHelper.updateWishlist(n,referenceID);
                      callBack(3);
                      Navigator.pop(context);
                    },
                    isSelected: _note.noteColor == 3,
                  ),
                  ColorPaletteButton(
                    color: NoteColor.getColor(4, darkModeOn),
                    onTap: () async {
                      Notes n = _note;
                      n.noteColor = 4;

                      FireStoreDatabaseHelper.updateQuestion(n,referenceID);
                      bool status = await FireStoreDatabaseHelper.checkIfWishlistExists(n.noteId,referenceID);
                      if (status) FireStoreDatabaseHelper.updateWishlist(n,referenceID);
                      callBack(4);
                      Navigator.pop(context);
                    },
                    isSelected: _note.noteColor == 4,
                  ),
                  ColorPaletteButton(
                    color: NoteColor.getColor(5, darkModeOn),
                    onTap: () async {
                      Notes n = _note;
                      n.noteColor = 5;

                      FireStoreDatabaseHelper.updateQuestion(n,referenceID);
                      bool status = await FireStoreDatabaseHelper.checkIfWishlistExists(n.noteId,referenceID);
                      if (status) FireStoreDatabaseHelper.updateWishlist(n,referenceID);
                      callBack(5);
                      Navigator.pop(context);
                    },
                    isSelected: _note.noteColor == 5,
                  ),
                ],
              ),
            ),
          ),
        );
      });
}
