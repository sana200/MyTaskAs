class Task {
  int _id;
  String _title;
  int _type;

  Task(
    this._title,
    this._type,
  );

  Task.withId(this._id, this._title, this._type);

  int get id => _id;

  String get title => _title;

  int get type => _type;

  set title(String newTitle) {
    if (newTitle.length <= 255) {
      this._title = newTitle;
    }
  }

  set type(int newType) {
    this._type = newType;
  }

  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['title'] = _title;
    map['type'] = _type;

    return map;
  }

  // Extract a Note object from a Map object
  Task.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._title = map['title'];
    this._type = map['type'];
  }
}
