import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/note.dart';
import '../providers/note_provider.dart';

class NoteEditorScreen extends StatefulWidget {
  final Note? note; // Nếu có note truyền vào là sửa, không là thêm mới
  const NoteEditorScreen({super.key, this.note});

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'Add Note' : 'Edit Note'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () async {
              final title = _titleController.text;
              final content = _contentController.text;

              if (title.isEmpty || content.isEmpty) return;

              final note = Note(
                id: widget.note?.id, // Giữ ID cũ nếu là sửa
                title: title,
                content: content,
                createdAt: widget.note?.createdAt ?? DateTime.now(),
                updatedAt: DateTime.now(),
              );

              if (widget.note == null) {
                await context.read<NoteProvider>().addNote(note);
              } else {
                await context.read<NoteProvider>().updateNote(note);
              }

              Navigator.of(context).pop();
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(labelText: 'Content', border: OutlineInputBorder()),
              maxLines: 5,
            ),
          ],
        ),
      ),
    );
  }
}