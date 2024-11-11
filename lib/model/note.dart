class Note {
  int? note_id;
  String? title;
  String? content;
  DateTime? created_at;
  bool? book_marked;

  void toggleBookmark() {
    book_marked = !(book_marked ?? false);
  }

  noteMap() {
    var mapping = <String, dynamic>{};
    mapping['note_id'] = note_id ?? null;
    mapping['title'] = title!;
    mapping['content'] = content!;
    mapping['created_at'] = created_at?.toIso8601String();
    mapping['book_marked'] = book_marked == true ? 1 : 0;
    return mapping;
  }
}
