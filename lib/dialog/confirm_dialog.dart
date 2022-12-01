import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:product_buy_sell/firebase/firestore_database_helper.dart';
import 'package:product_buy_sell/models/notes_model.dart';
import 'package:product_buy_sell/widgets/fancy_toasts.dart';

void confirmDeleteDialog(bool isDesktop, BuildContext context, Notes notes, String noteID,
    {bool isWishlist = false, bool isFromHome = false}) async {
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
                      child: Text(
                        'Confirm',
                        style: GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.w700),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(10),
                      child: Text('Are you sure you want to delete?'),
                    ),
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
                              onPressed: () async {
                                if (isFromHome == true) {
                                  FireStoreDatabaseHelper.deleteNodeTopic(notes);
                                } else {
                                  bool status = await FireStoreDatabaseHelper.checkIfWishlistExists(notes.noteId, noteID);
                                  if (status) {
                                    FireStoreDatabaseHelper.deleteWishlist(notes, noteID);
                                  } else if (isWishlist == false && isFromHome == false) {
                                    FireStoreDatabaseHelper.deleteQuestion(notes, noteID);
                                  }
                                }

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    backgroundColor: Colors.transparent,
                                    elevation: 0,
                                    content: InfoToast(
                                        body: "You have deleted a note",
                                        title: "Deleted",
                                        widget: Icon(Iconsax.trash, size: 16, color: Colors.white)),
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
