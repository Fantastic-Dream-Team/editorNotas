import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MissingComponentsScreen extends StatefulWidget {
  const MissingComponentsScreen({super.key});

  @override
  State<MissingComponentsScreen> createState() => _MissingComponentsScreenState();
}

class _MissingComponentsScreenState extends State<MissingComponentsScreen> {
  bool _isOptionActive = false;
  int _radioValue = 1;
  String _selectedColor = "Azul";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Componentes Faltantes'),
        backgroundColor: Colors.orange.shade300,
      ),
      body: Column(
        children: [
          // 1. MenuBar (Barra superior)
          MenuBar(
            children: [
              SubmenuButton(
                menuChildren: [
                  MenuItemButton(
                    // 2. SingleActivator (Atajos de teclado)
                    shortcut: const SingleActivator(LogicalKeyboardKey.keyN, control: true),
                    onPressed: () => _showMsg("Nuevo archivo creado"),
                    child: const Text('Nuevo (Ctrl+N)'),
                  ),
                  // 3. CheckmarkMenuItem (Implementación nativa correcta M3)
                  MenuItemButton(
                    onPressed: () {
                      setState(() {
                        _isOptionActive = !_isOptionActive;
                      });
                    },
                    leadingIcon: Icon(
                      _isOptionActive ? Icons.check_box : Icons.check_box_outline_blank
                    ),
                    child: const Text("Modo lectura"),
                  ),
                ],
                child: const Text('Archivo'),
              ),
              SubmenuButton(
                menuChildren: [
                  // 4. RadioMenuItem (Implementación nativa correcta M3)
                  MenuItemButton(
                    onPressed: () => setState(() => _radioValue = 1),
                    leadingIcon: Icon(
                      _radioValue == 1 ? Icons.radio_button_checked : Icons.radio_button_off
                    ),
                    child: const Text("Prioridad Alta"),
                  ),
                  MenuItemButton(
                    onPressed: () => setState(() => _radioValue = 2),
                    leadingIcon: Icon(
                      _radioValue == 2 ? Icons.radio_button_checked : Icons.radio_button_off
                    ),
                    child: const Text("Prioridad Baja"),
                  ),
                ],
                child: const Text('Opciones'),
              ),
            ],
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("5. DropdownMenu (Selector moderno):", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  // 5. DropdownMenu (Firma correcta de items)
                  DropdownMenu<String>(
                    initialSelection: _selectedColor,
                    label: const Text("Color de etiqueta"),
                    onSelected: (String? value) {
                      if (value != null) {
                        setState(() => _selectedColor = value);
                      }
                    },
                    dropdownMenuEntries: const [
                      DropdownMenuEntry(value: "Rojo", label: "Rojo"),
                      DropdownMenuEntry(value: "Azul", label: "Azul"),
                      DropdownMenuEntry(value: "Verde", label: "Verde"),
                    ],
                  ),

                  const SizedBox(height: 40),
                  const Text("6. CupertinoContextMenu (Mantén presionado):", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  // 6. CupertinoContextMenu
                  Center(
                    child: SizedBox(
                      width: 150,
                      height: 150,
                      child: CupertinoContextMenu(
                        actions: [
                          CupertinoContextMenuAction(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Ver detalle'),
                          ),
                          CupertinoContextMenuAction(
                            onPressed: () => Navigator.pop(context),
                            isDestructiveAction: true,
                            child: const Text('Borrar'),
                          ),
                        ],
                        child: Container(
                          color: Colors.orange.shade200,
                          child: const Icon(Icons.image, size: 50, color: Colors.white),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                  const Text("7. AdaptiveTextSelectionToolbar:", style: TextStyle(fontWeight: FontWeight.bold)),
                  const Text("(Selecciona el texto para ver el menú adaptativo)", style: TextStyle(fontSize: 12)),
                  const SizedBox(height: 10),
                  // 7. AdaptiveTextSelectionToolbar (Firma de construcción sin errores)
                  TextField(
                    maxLines: 2,
                    decoration: const InputDecoration(border: OutlineInputBorder()),
                    controller: TextEditingController(text: "Este texto usa AdaptiveTextSelectionToolbar nativo de Flutter."),
                    contextMenuBuilder: (context, editableTextState) {
                      return AdaptiveTextSelectionToolbar.buttonItems(
                        anchors: editableTextState.contextMenuAnchors,
                        buttonItems: editableTextState.contextMenuButtonItems,
                      );
                    },
                  ),

                  const SizedBox(height: 40),
                  const Divider(thickness: 2),
                  const Text("8. PlatformMenuBar (Nota técnica):", style: TextStyle(fontWeight: FontWeight.bold)),
                  const Text(
                    "Este componente no es un widget visual dentro de la pantalla, sino que se inyecta en la barra de tareas de macOS mediante código del sistema operativo. Se encuentra documentado en la arquitectura del proyecto.",
                    style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}