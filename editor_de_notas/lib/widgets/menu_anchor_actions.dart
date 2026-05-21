import 'package:flutter/material.dart';

/// MENÚ 3: MenuAnchor (el moderno, funciona en Flutter 3.13+)
class MenuAnchorActions extends StatefulWidget {
  final bool hasNote;
  final VoidCallback onNewNote;
  final VoidCallback onDuplicateNote;
  final VoidCallback onDeleteNote;

  const MenuAnchorActions({
    super.key,
    required this.hasNote,
    required this.onNewNote,
    required this.onDuplicateNote,
    required this.onDeleteNote,
  });

  @override
  State<MenuAnchorActions> createState() => _MenuAnchorActionsState();
}

class _MenuAnchorActionsState extends State<MenuAnchorActions> {
  late MenuController _menuController;

  @override
  void initState() {
    super.initState();
    _menuController = MenuController();
  }

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      controller: _menuController,
      style: MenuStyle(
        elevation: WidgetStateProperty.all(4.0),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      menuChildren: [
        MenuItemButton(
          leadingIcon: const Icon(Icons.add, size: 18),
          onPressed: () {
            widget.onNewNote();
          },
          child: const Text('Nueva nota'),
        ),
        const Divider(),
        SubmenuButton(
          leadingIcon: const Icon(Icons.format_paint, size: 18),
          menuChildren: const [
            MenuItemButton(child: Text('Negrita (demo)')),
            MenuItemButton(child: Text('Cursiva (demo)')),
            MenuItemButton(child: Text('Subrayado (demo)')),
          ],
          child: const Text('🎨 Formato (demo)'),
        ),
        const Divider(),
        MenuItemButton(
          leadingIcon: const Icon(Icons.copy_all, size: 18),
          onPressed: widget.hasNote ? widget.onDuplicateNote : null,
          child: const Text('Duplicar nota'),
        ),
        MenuItemButton(
          leadingIcon: const Icon(Icons.delete, size: 18, color: Colors.red),
          onPressed: widget.hasNote ? widget.onDeleteNote : null,
          style: ButtonStyle(
            foregroundColor: WidgetStateProperty.all(Colors.red),
          ),
          child: const Text(
            'Eliminar nota',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
      // 🔑 LO IMPORTANTE: El child debe ser un widget que recibe clics
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
        child: ElevatedButton.icon(
          onPressed: () => _menuController.open(),
          icon: const Icon(Icons.menu),
          label: const Text('Acciones'),
        ),
      ),
    );
  }
}
