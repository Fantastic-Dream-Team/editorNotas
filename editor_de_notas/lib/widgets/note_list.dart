import 'package:flutter/material.dart';
import '../models/note.dart';
import 'menu_contextual_card.dart';

class NoteList extends StatelessWidget {
  final List<Note> notes;
  final Note? selectedNote;
  final Function(Note) onSelectNote;
  final Function(Note) onDeleteNote;
  final Function(Note) onDuplicateNote;
  final VoidCallback onCreateNote; // ← NUEVO: callback para crear nota

  const NoteList({
    super.key,
    required this.notes,
    required this.selectedNote,
    required this.onSelectNote,
    required this.onDeleteNote,
    required this.onDuplicateNote,
    required this.onCreateNote, // ← NUEVO
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Column(
        children: [
          // Botón nueva nota - AHORA USA onCreateNote
          Padding(
            padding: const EdgeInsets.all(8),
            child: ElevatedButton.icon(
              onPressed: onCreateNote, // ← CORREGIDO
              icon: const Icon(Icons.add),
              label: const Text('Nueva nota'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 40),
              ),
            ),
          ),
          // Lista de notas
          Expanded(
            child: notes.isEmpty
                ? const Center(child: Text('No hay notas'))
                : ListView.builder(
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      final note = notes[index];
                      final isSelected = selectedNote?.id == note.id;
                      return ContextualNoteCard(
                        note: note,
                        isSelected: isSelected,
                        onTap: () => onSelectNote(note),
                        onDelete: () => onDeleteNote(note),
                        onDuplicate: () => onDuplicateNote(note),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
