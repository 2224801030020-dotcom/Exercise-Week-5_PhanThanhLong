import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/note.dart';

class NoteProvider extends ChangeNotifier {
  List<Note> _notes = [];
  List<Note> get notes => _notes;

  // Tải danh sách ghi chú từ database
  Future<void> loadNotes() async {
    _notes = await DatabaseHelper.instance.readAllNotes();
    notifyListeners();
  }

  // Thêm ghi chú
  Future<void> addNote(Note note) async {
    await DatabaseHelper.instance.create(note);
    await loadNotes(); // Tải lại danh sách sau khi thêm
  }

  // Cập nhật ghi chú
  Future<void> updateNote(Note note) async {
    await DatabaseHelper.instance.update(note);
    await loadNotes();
  }

  // Xóa ghi chú
  Future<void> deleteNote(int id) async {
    await DatabaseHelper.instance.delete(id);
    await loadNotes();
  }
}