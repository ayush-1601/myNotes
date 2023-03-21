import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_notes_app/models/note.dart';
import 'package:flutter_notes_app/pages/Add_new_note.dart';
import 'package:flutter_notes_app/provider/notes_provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String searchQuery = "";
  @override
  Widget build(BuildContext context) {
    NotesProvider notesProvider = Provider.of<NotesProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Notes app",
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: (notesProvider.isLoading == false)
          ? SafeArea(
              child: (notesProvider.notes.length > 0)
                  ? ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: TextField(
                            decoration: InputDecoration(hintText: "Search"),
                            onChanged: ((value) {
                              setState(() {
                                searchQuery = value;
                              });
                            }),
                          ),
                        ),
                        (notesProvider.getSearchNotes(searchQuery).length > 0)
                            ? MasonryGridView.count(
                                crossAxisSpacing: 0.5,
                                mainAxisSpacing: 0.5,
                                scrollDirection: Axis.vertical,
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                crossAxisCount: 2,
                                itemCount: notesProvider
                                    .getSearchNotes(searchQuery)
                                    .length,
                                itemBuilder: (BuildContext context, int index) {
                                  Note currNote = notesProvider
                                      .getSearchNotes(searchQuery)[index];
                                  return GestureDetector(
                                    onTap: (() {
                                      Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                              builder: (context) => AddNewNote(
                                                    isupdate: true,
                                                    note: currNote,
                                                  )));
                                    }),
                                    onLongPress: () {
                                      notesProvider.deleteNote(currNote);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.all(8),
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.black),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      // color: Colors.deepPurpleAccent,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            currNote.title.toString(),
                                            style: TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            currNote.content.toString(),
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.blueGrey,
                                            ),
                                            maxLines: 6,
                                            overflow: TextOverflow.ellipsis,
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Padding(
                                padding: const EdgeInsets.all(20),
                                child: Text(
                                  "No Notes Found",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                      ],
                    )
                  : Center(child: Text("No notes yet!!")),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (context) => AddNewNote(
                        isupdate: false,
                      ),
                  fullscreenDialog: true));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
