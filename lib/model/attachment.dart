class Attachment {
  int? id;
  String? name;

  attachmentMap() {
    var mapping = <String, dynamic>{};
    mapping['id'] = id ?? null;
    mapping['name'] = name!;
    return mapping;
  }
}
