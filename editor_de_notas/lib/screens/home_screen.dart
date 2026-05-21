import 'package:flutter/material.dart';
import '../models/note.dart';
import '../widgets/note_list.dart';
import '../widgets/note_editor.dart';
import '../widgets/menu_anchor_actions.dart';

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

  // Controladores temporales para edición
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
    }
  }

  void _createNewNote() {
    final newNote = Note.create();
    setState(() {
      _notes.insert(0, newNote);
      _selectedNote = newNote;
      _tempTitle = newNote.title;
      _tempContent = newNote.content;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✅ Nueva nota creada'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _saveCurrentNote() {
    if (_selectedNote == null) return;

    setState(() {
      final updatedNote = _selectedNote!.copyWith(
        title: _tempTitle.isEmpty ? 'Sin título' : _tempTitle,
        content: _tempContent,
      );
      final index = _notes.indexWhere((n) => n.id == _selectedNote!.id);
      if (index != -1) _notes[index] = updatedNote;
      _selectedNote = updatedNote;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('💾 Nota guardada'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _deleteNote(Note note) {
    _showConfirmDialog('Eliminar nota', '¿Eliminar "${note.title}"?', () {
      setState(() {
        _notes.removeWhere((n) => n.id == note.id);
        if (_selectedNote?.id == note.id) {
          _selectedNote = _notes.isNotEmpty ? _notes.first : null;
          if (_selectedNote != null) {
            _tempTitle = _selectedNote!.title;
            _tempContent = _selectedNote!.content;
          }
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🗑️ Nota eliminada'),
          duration: Duration(seconds: 1),
        ),
      );
    });
  }

  void _deleteAllNotes() {
    if (_notes.isEmpty) return;
    _showConfirmDialog('Eliminar todo', '¿Eliminar TODAS las notas?', () {
      setState(() {
        _notes.clear();
        _selectedNote = null;
        _tempTitle = '';
        _tempContent = '';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🗑️ Todas las notas eliminadas'),
          duration: Duration(seconds: 1),
        ),
      );
    });
  }

  void _duplicateNote(Note note) {
    final duplicated = note.duplicate();
    setState(() {
      _notes.insert(0, duplicated);
      _selectedNote = duplicated;
      _tempTitle = duplicated.title;
      _tempContent = duplicated.content;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('📋 Nota duplicada'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Acerca de'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('📝 Editor de Notas con Menús'),
            SizedBox(height: 8),
            Text('Menús demostrados:'),
            Text('1️⃣ PopupMenuButton (⋮ en AppBar)'),
            Text('2️⃣ DropdownMenu (tamaño de fuente)'),
            Text('3️⃣ MenuAnchor (botón "Acciones")'),
            Text('4️⃣ Menú contextual (clic derecho en nota)'),
            Text('5️⃣ contextMenuBuilder (selecciona texto)'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _showConfirmDialog(
    String title,
    String content,
    VoidCallback onConfirm,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              onConfirm();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Notas'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          // MENÚ 1: PopupMenuButton
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              switch (value) {
                case 'nueva':
                  _createNewNote();
                  break;
                case 'borrar_todo':
                  _deleteAllNotes();
                  break;
                case 'acerca':
                  _showAboutDialog();
                  break;
              }
            },
            itemBuilder: (ctx) => [
              const PopupMenuItem(value: 'nueva', child: Text('➕ Nueva nota')),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'borrar_todo',
                child: Text(
                  '🗑️ Eliminar todo',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(value: 'acerca', child: Text('ℹ️ Acerca de')),
            ],
          ),
        ],
      ),
      body: _isMobile ? _buildMobileLayout() : _buildDesktopLayout(),
    );
  }

  // VISTA ESCRITORIO
  Widget _buildDesktopLayout() {
    return Row(
      children: [
        NoteList(
          notes: _notes,
          selectedNote: _selectedNote,
          onSelectNote: (note) {
            setState(() {
              _selectedNote = note;
              _tempTitle = note.title;
              _tempContent = note.content;
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
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade200),
                  ),
                ),
                child: Row(
                  children: [
                    MenuAnchorActions(
                      hasNote: _selectedNote != null,
                      onNewNote: _createNewNote, // ✅
                      onDuplicateNote: () {
                        if (_selectedNote != null) {
                          _duplicateNote(_selectedNote!);
                        }
                      },
                      onDeleteNote: () {
                        if (_selectedNote != null) _deleteNote(_selectedNote!);
                        {}
                      },
                    ),
                    const Spacer(),
                    if (_selectedNote != null)
                      Text(
                        'Actualizado: ${_selectedNote!.updatedAt.day}/${_selectedNote!.updatedAt.month}',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
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

  // VISTA MÓVIL
  Widget _buildMobileLayout() {
    if (_selectedNote == null) {
      return NoteList(
        notes: _notes,
        selectedNote: _selectedNote,
        onSelectNote: (note) {
          setState(() {
            _selectedNote = note;
            _tempTitle = note.title;
            _tempContent = note.content;
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
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
          ),
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
              // Botón GUARDAR en móvil
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
