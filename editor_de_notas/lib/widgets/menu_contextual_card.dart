import 'package:flutter/material.dart';
import '../models/note.dart';

/// MENÚ 4: Tarjeta con menú contextual (clic derecho / long press)
class ContextualNoteCard extends StatelessWidget {
  final Note note;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onDuplicate;

  const ContextualNoteCard({
    super.key,
    required this.note,
    required this.isSelected,
    required this.onTap,
    required this.onDelete,
    required this.onDuplicate,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      // Clic derecho (Desktop/Web)
      onSecondaryTapDown: (details) async {
        final RenderBox overlay =
            Overlay.of(context).context.findRenderObject() as RenderBox;
        final position = overlay.globalToLocal(details.globalPosition);

        final result = await showMenu<String>(
          context: context,
          position: RelativeRect.fromLTRB(
            position.dx,
            position.dy,
            position.dx + 1,
            position.dy + 1,
          ),
          items: const [
            PopupMenuItem(
              value: 'editar',
              child: Row(
                children: [
                  Icon(Icons.edit),
                  SizedBox(width: 8),
                  Text('Editar'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'duplicar',
              child: Row(
                children: [
                  Icon(Icons.copy),
                  SizedBox(width: 8),
                  Text('Duplicar'),
                ],
              ),
            ),
            PopupMenuDivider(),
            PopupMenuItem(
              value: 'eliminar',
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Eliminar', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        );

        if (result == 'editar') onTap();
        if (result == 'duplicar') onDuplicate();
        if (result == 'eliminar') onDelete();
      },
      // Long press (Móvil)
      onLongPress: () {
        showModalBottomSheet(
          context: context,
          builder: (ctx) => SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.edit),
                  title: const Text('Editar'),
                  onTap: () {
                    Navigator.pop(ctx);
                    onTap();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.copy),
                  title: const Text('Duplicar'),
                  onTap: () {
                    Navigator.pop(ctx);
                    onDuplicate();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text(
                    'Eliminar',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    onDelete();
                  },
                ),
              ],
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade50 : Colors.transparent,
          border: isSelected
              ? Border(left: BorderSide(color: Colors.blue, width: 4))
              : null,
        ),
        child: ListTile(
          title: Text(note.title, maxLines: 1, overflow: TextOverflow.ellipsis),
          subtitle: Text(
            note.content.replaceAll('\n', ' '),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
          trailing: isSelected
              ? const Icon(Icons.check_circle, color: Colors.blue)
              : null,
        ),
      ),
    );
  }
}
