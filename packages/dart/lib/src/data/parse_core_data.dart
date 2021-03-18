part of flutter_parse_sdk;

/// Singleton class that defines all user keys and data
class ParseCoreData {
  factory ParseCoreData() => _instance!;

  ParseCoreData._init(this.applicationId, this.serverUrl);

  static ParseCoreData? _instance;

  static ParseCoreData get instance => _instance!;

  /// Creates an instance of Parse Server
  ///
  /// This class should not be user unless switching servers during the app,
  /// which is odd. Should only be user by Parse.init
  static Future<void> init(
    String appId,
    String serverUrl, {
    bool debug = false,
    String? appName,
    String? appVersion,
    String? appPackageName,
    String? locale,
    String? liveQueryUrl,
    String? masterKey,
    String? clientKey,
    String? sessionId,
    bool autoSendSessionId = true,
    SecurityContext? securityContext,
    CoreStore? store,
    Map<String, ParseObjectConstructor>? registeredSubClassMap,
    ParseUserConstructor? parseUserConstructor,
    ParseFileConstructor? parseFileConstructor,
    List<int>? liveListRetryIntervals,
    ParseConnectivityProvider? connectivityProvider,
    String? fileDirectory,
    Stream<void>? appResumedStream,
    ParseClientCreator? clientCreator,
  }) async {
    _instance = ParseCoreData._init(appId, serverUrl);

    _instance!.storage ??= store ?? CoreStoreMemoryImp();

    _instance!.debug = debug;

    _instance!.appName = appName;

    _instance!.appVersion = appVersion;

    _instance!.appPackageName = appPackageName;

    _instance!.locale = locale;

    _instance!.liveQueryURL = liveQueryUrl;

    _instance!.clientKey = clientKey;

    _instance!.masterKey = masterKey;

    _instance!.sessionId = sessionId;

    _instance!.autoSendSessionId = autoSendSessionId;

    _instance!.securityContext = securityContext;

    if (liveListRetryIntervals != null) {
      _instance!.liveListRetryIntervals = liveListRetryIntervals;
    } else {
      _instance!.liveListRetryIntervals = parseIsWeb
          ? <int>[0, 500, 1000, 2000, 5000]
          : <int>[0, 500, 1000, 2000, 5000, 10000];
    }

    _instance!._subClassHandler = ParseSubClassHandler(
      registeredSubClassMap: registeredSubClassMap,
      parseUserConstructor: parseUserConstructor,
      parseFileConstructor: parseFileConstructor,
    );

    _instance!.connectivityProvider = connectivityProvider;

    _instance!.fileDirectory = fileDirectory;

    _instance!.appResumedStream = appResumedStream;

    if (clientCreator != null) {
      _instance!.clientCreator = clientCreator;
    }
  }

  String applicationId;
  String serverUrl;
  String? appName;
  String? appVersion;
  String? appPackageName;
  String? locale;
  String? liveQueryURL;
  String? masterKey;
  String? clientKey;
  String? sessionId;
  bool autoSendSessionId = true;
  SecurityContext? securityContext;
  bool debug = false;
  CoreStore? storage;
  ParseSubClassHandler? _subClassHandler;
  List<int>? liveListRetryIntervals;
  ParseConnectivityProvider? connectivityProvider;
  String? fileDirectory;
  Stream<void>? appResumedStream;
  ParseClientCreator clientCreator = (
          {bool? sendSessionId, SecurityContext? securityContext}) =>
      ParseHTTPClient(
          sendSessionId: sendSessionId, securityContext: securityContext);

  void registerSubClass(
      String className, ParseObjectConstructor objectConstructor) {
    _subClassHandler?.registerSubClass(className, objectConstructor);
  }

  void registerUserSubClass(ParseUserConstructor parseUserConstructor) {
    _subClassHandler?.registerUserSubClass(parseUserConstructor);
  }

  void registerFileSubClass(ParseFileConstructor parseFileConstructor) {
    _subClassHandler?.registerFileSubClass(parseFileConstructor);
  }

  ParseObject createObject(String classname) {
    return _subClassHandler!.createObject(classname);
  }

  ParseUser createParseUser(
      String? username, String? password, String? emailAddress,
      {String? sessionToken, bool? debug, ParseClient? client}) {
    return _subClassHandler!.createParseUser(username, password, emailAddress,
        sessionToken: sessionToken, debug: debug, client: client);
  }

  ParseFileBase createFile({String? url, String? name}) =>
      _subClassHandler!.createFile(name: name, url: url);

  /// Sets the current sessionId.
  ///
  /// This is generated when a users logs in, or calls currentUser to update
  /// their keys
  void setSessionId(String sessionId) {
    this.sessionId = sessionId;
  }

  CoreStore getStore() {
    return storage!;
  }

  @override
  String toString() => '$applicationId $masterKey';
}
