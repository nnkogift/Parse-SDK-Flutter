part of flutter_parse_sdk;

// ignore_for_file: always_specify_types
class ParseRelation<T extends ParseObject> {
  ParseRelation({ParseObject? parent, String? key}) {
    _parent = parent;
    _key = key;
  }

  String? _targetClass;
  ParseObject? _parent;
  String? _key;
  Set<T>? _objects;

  QueryBuilder getQuery() {
    return QueryBuilder(ParseObject(_targetClass!));
  }

  void add(T object) {
    _targetClass = object.parseClassName;
    _objects!.add(object);
    _parent?.addRelation(_key!, _objects!.toList());
  }

  void remove(T object) {
    _targetClass = object.parseClassName;
    _objects!.remove(object);
    _parent?.removeRelation(_key!, _objects!.toList());
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        '__type': keyRelation,
        'className': _objects!.first.parseClassName,
        'objects': parseEncode(_objects!.toList())
      };

  ParseRelation<T> fromJson(Map<String, dynamic> map) => ParseRelation<T>()
    .._objects = parseDecode(map['objects']) ?? Set<T>()
    .._targetClass = map['className'];
}
