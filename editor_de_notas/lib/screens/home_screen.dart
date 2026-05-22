import 'package:flutter/material.dart';

import '../components_screen.dart'; // Asegúrate de que la ruta coincida con tu estructura de carpetas
import '../models/note.dart';
import '../widgets/menu_anchor_actions.dart';
import '../widgets/note_editor.dart';
import '../widgets/note_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Note> _notes = [];
  Note? _selectedNote;
  double _fontSize = 16;
  bool _isMobile = false;

  String _tempTitle = '';
  String _tempContent = '';

  @override
  void initState() {
    super.initState();
    _notes = [
      Note.example(
        'Bienvenido',
        'Esta es tu app de notas.\n\n✓ Crea notas nuevas\n✓ Edita título y contenido\n✓ Cambia el tamaño de la fuente\n✓ Guarda manualmente con el botón',
      ),
      Note.example(
        'Ejemplo de formato',
        'Selecciona texto y usa el menú contextual para:\n• Convertir a MAYÚSCULAS\n• Convertir a minúsculas\n• Capitalizar palabras',
      ),
    ];
    _selectedNote = _notes.first;
    _loadTempData();
  }

  void _loadTempData() {
    if (_selectedNote != null) {
      _tempTitle = _selectedNote!.title;
      _tempContent = _selectedNote!.content;
    } else {
      _tempTitle = '';
      _tempContent = '';
    }
  }

  void _createNewNote() {
    setState(() {
      final newNote = Note.create(title: 'Nota sin título', content: '');
      _notes.insert(0, newNote);
      _selectedNote = newNote;
      _loadTempData();
    });
  }

  void _duplicateNote(Note note) {
    setState(() {
      final duplicated = note.duplicate();
      final index = _notes.indexOf(note);
      if (index != -1) {
        _notes.insert(index + 1, duplicated);
      } else {
        _notes.add(duplicated);
      }
      _selectedNote = duplicated;
      _loadTempData();
    });
  }

  void _deleteNote(Note note) {
    setState(() {
      _notes.remove(note);
      if (_notes.isNotEmpty) {
        _selectedNote = _notes.first;
      } else {
        _selectedNote = null;
      }
      _loadTempData();
    });
  }

  void _saveCurrentNote() {
    if (_selectedNote != null) {
      setState(() {
        _selectedNote!.title = _tempTitle;
        _selectedNote!.content = _tempContent;
        _selectedNote!.updatedAt = DateTime.now();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nota guardada correctamente')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Notas 📝'),
        backgroundColor: Colors.blue.shade100,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'nueva':
                  _createNewNote();
                  break;
                case 'faltantes':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MissingComponentsScreen(),
                    ),
                  );
                  break;
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: 'nueva',
                child: Row(
                  children: [
                    Icon(Icons.add, size: 20),
                    SizedBox(width: 8),
                    Text('Nueva Nota rápido'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'faltantes',
                child: Row(
                  children: [
                    Icon(Icons.science, size: 20, color: Colors.orange),
                    SizedBox(width: 8),
                    Text('🧪 Ver componentes faltantes'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: _isMobile ? _buildMobileLayout() : _buildDesktopLayout(),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        NoteList(
          notes: _notes,
          selectedNote: _selectedNote,
          onSelectNote: (note) {
            setState(() {
              _selectedNote = note;
              _loadTempData();
            });
          },
          onDeleteNote: _deleteNote,
          onDuplicateNote: _duplicateNote,
          onCreateNote: _createNewNote,
        ),
        Expanded(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                color: Colors.grey.shade100,
                child: Row(
                  children: [
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.save),
                      onPressed: _saveCurrentNote,
                      tooltip: 'Guardar cambios',
                    ),
                    const SizedBox(width: 8),
                    MenuAnchorActions(
                      hasNote: _selectedNote != null,
                      onNewNote: _createNewNote,
                      onDuplicateNote: () => _duplicateNote(_selectedNote!),
                      onDeleteNote: () => _deleteNote(_selectedNote!),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: NoteEditor(
                  note: _selectedNote,
                  fontSize: _fontSize,
                  tempTitle: _tempTitle,
                  tempContent: _tempContent,
                  onTitleChanged: (value) => _tempTitle = value,
                  onContentChanged: (value) => _tempContent = value,
                  onFontSizeChanged: (size) => setState(() => _fontSize = size),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    if (_selectedNote == null) {
      return NoteList(
        notes: _notes,
        selectedNote: _selectedNote,
        onSelectNote: (note) {
          setState(() {
            _selectedNote = note;
            _loadTempData();
          });
        },
        onDeleteNote: _deleteNote,
        onDuplicateNote: _duplicateNote,
        onCreateNote: _createNewNote,
      );
    }

    return Column(
      children: [
        Container(
          color: Colors.grey.shade200,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => setState(() => _selectedNote = null),
              ),
              Expanded(
                child: Text(
                  _tempTitle.isEmpty ? 'Sin título' : _tempTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.save),
                onPressed: _saveCurrentNote,
                tooltip: 'Guardar',
              ),
              MenuAnchorActions(
                hasNote: true,
                onNewNote: _createNewNote,
                onDuplicateNote: () => _duplicateNote(_selectedNote!),
                onDeleteNote: () => _deleteNote(_selectedNote!),
              ),
            ],
          ),
        ),
        Expanded(
          child: NoteEditor(
            note: _selectedNote,
            fontSize: _fontSize,
            tempTitle: _tempTitle,
            tempContent: _tempContent,
            onTitleChanged: (value) => _tempTitle = value,
            onContentChanged: (value) => _tempContent = value,
            onFontSizeChanged: (size) => setState(() => _fontSize = size),
          ),
        ),
      ],
    );
  }
}