class Note {
  final String id;
  String title;
  String content;
  final DateTime createdAt;
  DateTime updatedAt;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  // Crear una nota nueva
  factory Note.create({String title = '', String content = ''}) {
    final now = DateTime.now();
    return Note(
      id: now.millisecondsSinceEpoch.toString(),
      title: title.isEmpty ? 'Nueva nota' : title,
      content: content,
      createdAt: now,
      updatedAt: now,
    );
  }

  // Crear nota de ejemplo
  factory Note.example(String title, String content) {
    final now = DateTime.now();
    return Note(
      id: now.millisecondsSinceEpoch.toString(),
      title: title,
      content: content,
      createdAt: now,
      updatedAt: now,
    );
  }

  // Copiar nota con cambios
  Note copyWith({String? title, String? content, DateTime? updatedAt}) {
    return Note(
      id: id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  // Duplicar nota
  Note duplicate() {
    return Note(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: '$title (copia)',
      content: content,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}
