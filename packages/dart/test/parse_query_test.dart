import 'package:mockito/mockito.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:test/test.dart';

class MockClient extends Mock implements ParseClient {}

void main() {
  group('queryBuilder', () {
    test('whereRelatedTo', () async {
      final MockClient client = MockClient();

      await Parse().initialize(
        'tanesco-crm',
        'https://tanescocrm-server.herokuapp.com',
        debug: true,
        // to prevent automatic detection
        fileDirectory: 'someDirectory',
        // to prevent automatic detection
        appName: 'appName',
        // to prevent automatic detection
        appPackageName: 'somePackageName',
        // to prevent automatic detection
        appVersion: 'someAppVersion',
      );

      final QueryBuilder<ParseObject> queryBuilder =
          QueryBuilder<ParseObject>(ParseObject('_User', client: client));
      queryBuilder.whereRelatedTo('likes', 'Post', '8TOXdXf3tz');

      when(client.data).thenReturn(ParseCoreData());
      await queryBuilder.query();

      final Uri result =
          Uri.parse(verify(client.get(captureAny)).captured.single);

      expect(result.path, '/classes/_User');

      final Uri expectedQuery = Uri(
          query:
              'where={"\$relatedTo":{"object":{"__type":"Pointer","className":"Post","objectId":"8TOXdXf3tz"},"key":"likes"}}');
      expect(result.query, expectedQuery.query);
    });
  });
}
