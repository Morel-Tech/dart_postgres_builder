import 'package:postgres_builder/postgres_builder.dart';
import 'package:test/test.dart';

import '../../_helpers.dart';

void main() {
  group('$SetSchema', () {
    test('toSql returns correctly for setting schema', () {
      final operation = SetSchema(schema: 'archive');
      expect(
        operation.toSql(),
        equalsSql(
          query: 'SET SCHEMA archive',
          parameters: {},
        ),
      );
    });

    test('toSql integrates correctly with AlterTable', () {
      final statement = AlterTable(
        table: 'users',
        operations: [SetSchema(schema: 'archive')],
      );
      expect(
        statement.toSql(),
        equalsSql(
          query: 'ALTER TABLE users SET SCHEMA archive',
          parameters: {},
        ),
      );
    });
  });
}
