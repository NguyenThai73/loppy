import 'package:flutter/material.dart';
import '../models/note_model.dart';

class NotePage extends StatefulWidget {
  const NotePage({super.key});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  final List<Note> _notes = [
    Note(id: '1', title: 'Cho Loppy an sang - Ngo va rau cu'),
    Note(id: '2', title: 'Thay nuoc bon tam cho Loppy'),
    Note(id: '3', title: 'Kiem tra rang cua Loppy', isDone: true),
    Note(id: '4', title: 'Mua them go cho Loppy gam'),
    Note(id: '5', title: 'Don dep chuong cua Loppy'),
    Note(id: '6', title: 'Dat lich kham thu y', isDone: true),
  ];

  void _addNote() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Them cong viec'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Nhap cong viec cham soc Loppy...',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Huy'),
          ),
          FilledButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                setState(() {
                  _notes.add(
                    Note(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      title: controller.text.trim(),
                    ),
                  );
                });
              }
              Navigator.pop(ctx);
            },
            child: const Text('Them'),
          ),
        ],
      ),
    );
  }

  void _deleteNote(Note note) {
    setState(() {
      _notes.remove(note);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Da xoa: ${note.title}'),
        action: SnackBarAction(
          label: 'Hoan tac',
          onPressed: () {
            setState(() {
              _notes.add(note);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pending = _notes.where((n) => !n.isDone).toList();
    final done = _notes.where((n) => n.isDone).toList();

    return Scaffold(
      body: _notes.isEmpty
          ? const Center(child: Text('Chua co cong viec nao'))
          : ListView(
              padding: const EdgeInsets.all(8),
              children: [
                if (pending.isNotEmpty) ...[
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Text(
                      'Can lam (${pending.length})',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  ...pending.map((note) => _buildNoteItem(note)),
                ],
                if (done.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Text(
                      'Da xong (${done.length})',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                    ),
                  ),
                  ...done.map((note) => _buildNoteItem(note)),
                ],
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNote,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildNoteItem(Note note) {
    return Dismissible(
      key: Key(note.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => _deleteNote(note),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red.shade400,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Card(
        child: CheckboxListTile(
          value: note.isDone,
          onChanged: (val) {
            setState(() {
              note.isDone = val ?? false;
            });
          },
          title: Text(
            note.title,
            style: TextStyle(
              decoration: note.isDone ? TextDecoration.lineThrough : null,
              color: note.isDone ? Colors.grey : null,
            ),
          ),
          controlAffinity: ListTileControlAffinity.leading,
        ),
      ),
    );
  }
}
