import 'package:flutter/material.dart';
import 'package:flutter_notes_app/models/note.dart';
import 'package:flutter_notes_app/provider/notes_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddNewNote extends StatefulWidget {
  final bool isupdate;
  final Note? note;
  const AddNewNote({super.key, required this.isupdate, this.note});

  @override
  State<AddNewNote> createState() => AddNewNoteState();
}

class AddNewNoteState extends State<AddNewNote> {
  FocusNode noteFocus = FocusNode();
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  void addNewNote() {
    Note newNote = Note(
        id: Uuid().v1(),
        userid: "ayush",
        title: titleController.text,
        content: contentController.text,
        dateAdded: DateTime.now());

    Provider.of<NotesProvider>(context, listen: false).addNote(newNote);
    Navigator.pop(context);
  }

  void updateNote() {
    widget.note!.title = titleController.text;
    widget.note!.content = contentController.text;
    widget.note!.dateAdded = DateTime.now();
    Provider.of<NotesProvider>(context, listen: false).updateNote(widget.note!);
    Navigator.pop(context);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.isupdate) {
      titleController.text = widget.note!.title!;
      contentController.text = widget.note!.content!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              if (widget.isupdate) {
                updateNote();
              } else {
                addNewNote();
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              onSubmitted: ((value) {
                if (value != "") {
                  noteFocus.requestFocus();
                }
              }),
              autofocus: (widget.isupdate == true) ? false : true,
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Title",
              ),
            ),
            Expanded(
              child: TextField(
                controller: contentController,
                focusNode: noteFocus,
                maxLines: null,
                style: TextStyle(fontSize: 25),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Notes",
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
