import 'package:flutter/material.dart';
import '../models/note.dart';

class NoteEditor extends StatefulWidget {
  final Note? note;
  final double fontSize;
  final String tempTitle;
  final String tempContent;
  final Function(String) onTitleChanged;
  final Function(String) onContentChanged;
  final Function(double) onFontSizeChanged;

  const NoteEditor({
    super.key,
    required this.note,
    required this.fontSize,
    required this.tempTitle,
    required this.tempContent,
    required this.onTitleChanged,
    required this.onContentChanged,
    required this.onFontSizeChanged,
  });

  @override
  State<NoteEditor> createState() => _NoteEditorState();
}

class _NoteEditorState extends State<NoteEditor> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.tempTitle);
    _contentController = TextEditingController(text: widget.tempContent);
    _titleController.addListener(
      () => widget.onTitleChanged(_titleController.text),
    );
    _contentController.addListener(
      () => widget.onContentChanged(_contentController.text),
    );
  }

  @override
  void didUpdateWidget(NoteEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.note?.id != widget.note?.id) {
      _titleController.text = widget.tempTitle;
      _contentController.text = widget.tempContent;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text
        .split(' ')
        .map((word) {
          if (word.isEmpty) return word;
          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        })
        .join(' ');
  }

  /// Construye el menú contextual flotante con opciones de transformación de texto
  Widget _buildContextMenu(EditableTextState editableTextState) {
    return AdaptiveTextSelectionToolbar(
      anchors: editableTextState.contextMenuAnchors,
      children: [
        // Opción 1: MAYÚSCULAS
        TextButton.icon(
          onPressed: () {
            _applyTextTransformation(
              editableTextState,
              (text) => text.toUpperCase(),
            );
          },
          icon: const Icon(Icons.text_fields, size: 18),
          label: const Text('MAYÚSCULAS'),
        ),
        // Opción 2: minúsculas
        TextButton.icon(
          onPressed: () {
            _applyTextTransformation(
              editableTextState,
              (text) => text.toLowerCase(),
            );
          },
          icon: const Icon(Icons.text_fields, size: 18),
          label: const Text('minúsculas'),
        ),
        // Opción 3: Capitalizar
        TextButton.icon(
          onPressed: () {
            _applyTextTransformation(
              editableTextState,
              (text) => _capitalize(text),
            );
          },
          icon: const Icon(Icons.text_fields, size: 18),
          label: const Text('Capitalizar'),
        ),
      ],
    );
  }

  /// Aplica una transformación al texto seleccionado
  void _applyTextTransformation(
    EditableTextState editableTextState,
    String Function(String) transform,
  ) {
    final text = _contentController.text;
    final selection = _contentController.selection;

    if (selection.isValid && selection.start != selection.end) {
      final selected = text.substring(selection.start, selection.end);
      final transformed = transform(selected);
      final newText = text.replaceRange(
        selection.start,
        selection.end,
        transformed,
      );

      _contentController.text = newText;
      _contentController.selection = TextSelection(
        baseOffset: selection.start,
        extentOffset: selection.start + transformed.length,
      );

      widget.onContentChanged(_contentController.text);
    }

    editableTextState.hideToolbar();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.note == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.note_outlined, size: 64),
            SizedBox(height: 16),
            Text('Selecciona o crea una nota'),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Barra de herramientas
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
          ),
          child: Row(
            children: [
              // MENÚ 2: DropdownMenu
              SizedBox(
                width: 150,
                child: DropdownMenu<double>(
                  label: const Text('Tamaño'),
                  initialSelection: widget.fontSize,
                  dropdownMenuEntries: const [
                    DropdownMenuEntry(value: 12, label: '12pt'),
                    DropdownMenuEntry(value: 14, label: '14pt'),
                    DropdownMenuEntry(value: 16, label: '16pt'),
                    DropdownMenuEntry(value: 18, label: '18pt'),
                    DropdownMenuEntry(value: 20, label: '20pt'),
                    DropdownMenuEntry(value: 24, label: '24pt'),
                  ],
                  onSelected: (value) {
                    if (value != null) widget.onFontSizeChanged(value);
                  },
                ),
              ),
            ],
          ),
        ),
        // Editor título
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              hintText: 'Título',
              border: InputBorder.none,
            ),
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        // Editor contenido
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _contentController,
              decoration: const InputDecoration(
                hintText:
                    '✏️ Escribe aquí...\n\n👉 SELECCIONA TEXTO, luego toca las opciones flotantes',
                border: InputBorder.none,
              ),
              maxLines: null,
              expands: true,
              style: TextStyle(fontSize: widget.fontSize),
              enableInteractiveSelection: true,
              // MENÚ 5: contextMenuBuilder (ARREGLADO para móvil y web)
              contextMenuBuilder: (context, editableTextState) {
                return _buildContextMenu(editableTextState);
              },
            ),
          ),
        ),
      ],
    );
  }
}
