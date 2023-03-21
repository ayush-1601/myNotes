import 'package:flutter/cupertino.dart';
import 'package:flutter_notes_app/models/note.dart';
import 'package:flutter_notes_app/services/api_service.dart';

class NotesProvider with ChangeNotifier {
  bool isLoading = true;
  List<Note> notes = [];

  NotesProvider() {
    fetchNotes();
  }

  void sortNotes() {
    notes.sort(((a, b) => b.dateAdded!.compareTo(a.dateAdded!)));
  }

  List<Note> getSearchNotes(String searchQuery) {
    return notes
        .where((element) =>
            element.title!.toLowerCase().contains(searchQuery.toLowerCase()) ||
            element.content!.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
  }

  void addNote(Note note) {
    notes.add(note);
    sortNotes();
    notifyListeners();
    APIservice.addNote(note);
  }

  void updateNote(Note note) {
    int indexOfNote =
        notes.indexOf(notes.firstWhere((element) => element.id == note.id));
    notes[indexOfNote] = note;
    sortNotes();
    notifyListeners();
    APIservice.addNote(note);
  }

  void deleteNote(Note note) {
    int indexOfNote =
        notes.indexOf(notes.firstWhere((element) => element.id == note.id));
    notes.removeAt(indexOfNote);
    sortNotes();
    notifyListeners();
    APIservice.deleteNote(note);
  }

  void fetchNotes() async {
    notes = await APIservice.fetchNotes("ayush");
    isLoading = false;
    sortNotes();
    notifyListeners();
  }
}
