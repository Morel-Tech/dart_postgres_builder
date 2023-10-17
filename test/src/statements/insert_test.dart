import 'package:postgres_builder/postgres_builder.dart';
import 'package:test/test.dart';

import '../../_helpers.dart';

void main() {
  group('Insert', () {
    test('toSql() returns correctly', () {
      expect(
        const Insert(
          [
            {'__param1__': '__value1__', '__param2__': '__value3__'},
            {'__param1__': '__value2__', '__param2__': '__value4__'},
            {'__param3__': '__value5__'},
          ],
          into: '__table__',
        ).toSql(),
        equalsSql(
          query:
              '''INSERT INTO __table__ (__param1__, __param2__, __param3__) VALUES (@__param1__0, @__param2__0, @__param3__0), (@__param1__1, @__param2__1, @__param3__1), (@__param1__2, @__param2__2, @__param3__2) RETURNING *''',
          parameters: {
            '__param1__0': '__value1__',
            '__param1__1': '__value2__',
            '__param1__2': null,
            '__param2__0': '__value3__',
            '__param2__1': '__value4__',
            '__param2__2': null,
            '__param3__0': null,
            '__param3__1': null,
            '__param3__2': '__value5__',
          },
        ),
      );
    });
  });
}
