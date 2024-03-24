enum ExtraType { delete, edit }

class NoteListPageExtra {
  final ExtraType type;
  final String className;
  final String oldClassName;

  NoteListPageExtra({
    required this.type,
    required this.className,
    this.oldClassName = '',
  });
}

class NoteDetailsExtra {
  final ExtraType type;
  final String className;
  final String noteName;
  final String oldNoteName;

  NoteDetailsExtra({
    required this.type,
    required this.className,
    required this.noteName,
    this.oldNoteName = '',
  });
}
