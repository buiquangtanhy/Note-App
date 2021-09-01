final String tableNotes = 'notes';

class NoteFields {
  static final List<String> values = [
    id,
    title,
    content,
    uriImage,
    webLink,
    typeColor
  ];
  static final String id = 'id';
  static final String title = 'title';
  static final String content = 'content';
  static final String uriImage = 'uriImage';
  static final String webLink = 'webLink';
  static final String typeColor = 'typeColor';
}

class Note {
  final int? id;
  final String title;
  final String content;
  final String? uriImage;
  final String? webLink;
  final int typeColor;
  const Note(
      {this.id,
      required this.title,
      required this.content,
      this.uriImage,
      this.webLink,
      required this.typeColor});

  Note copy(
          {int? id,
          String? title,
          String? content,
          String? uriImage,
          String? webLink,
          int? typeColor}) =>
      Note(
          id: id ?? this.id,
          title: title ?? this.title,
          content: content ?? this.content,
          uriImage: uriImage ?? this.uriImage,
          webLink: webLink ?? this.webLink,
          typeColor: typeColor ?? this.typeColor);

  static Note fromJson(Map<String, Object?> json) => Note(
        id: json[NoteFields.id] as int,
        title: json[NoteFields.title] as String,
        content: json[NoteFields.content] as String,
        typeColor: json[NoteFields.typeColor] as int,
        webLink: json[NoteFields.webLink] as String?,
        uriImage: json[NoteFields.uriImage] as String?
      );

  Map<String, Object?> toJson() => {
        NoteFields.id: id,
        NoteFields.title: title,
        NoteFields.content: content,
        NoteFields.typeColor: typeColor,
        NoteFields.uriImage: uriImage,
        NoteFields.webLink: webLink
      };
}
