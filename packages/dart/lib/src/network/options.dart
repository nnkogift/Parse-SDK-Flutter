part of flutter_parse_sdk;

class ParseNetworkOptions {
  ParseNetworkOptions({this.headers = const <String, String>{}});

  final Map<String, String>? headers;
  // final ParseNetworkResponseType responseType;
}

enum ParseNetworkResponseType { json, stream, plain, bytes }
