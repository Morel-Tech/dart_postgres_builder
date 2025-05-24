import 'package:postgres_builder/postgres_builder.dart';
import 'package:test/test.dart';

import '../../_helpers.dart';

void main() {
  group('DropTable', () {
    test('toSql returns correctly without ifExists', () {
      expect(
        const DropTable(name: '__table__').toSql(),
        equalsSql(
          query: 'DROP TABLE __table__',
          parameters: {},
        ),
      );
    });

    test('toSql returns correctly with ifExists', () {
      expect(
        const DropTable(name: '__table__', ifExists: true).toSql(),
        equalsSql(
          query: 'DROP TABLE IF EXISTS __table__',
          parameters: {},
        ),
      );
    });
  });
}
