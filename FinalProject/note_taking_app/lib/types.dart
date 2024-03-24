enum NoteListPageExtraType { delete, edit }

class NoteListPageExtra {
  final NoteListPageExtraType type;
  final String className;
  final String oldClassName;

  NoteListPageExtra({
    required this.type,
    required this.className,
    this.oldClassName = '',
  });
}
