import 'package:postgres_builder/postgres_builder.dart';
import 'package:test/test.dart';

import '../../_helpers.dart';

void main() {
  group('$SetColumnType', () {
    test('toSql returns correctly for a single column without using', () {
      final operation = SetColumnType(column: 'age', newType: 'BIGINT');
      expect(
        operation.toSql(),
        equalsSql(
          query: 'ALTER COLUMN age TYPE BIGINT',
          parameters: {},
        ),
      );
    });

    test('toSql returns correctly for a single column with using', () {
      final operation =
          SetColumnType(column: 'age', newType: 'BIGINT', using: 'age::bigint');
      expect(
        operation.toSql(),
        equalsSql(
          query: 'ALTER COLUMN age TYPE BIGINT USING age::bigint',
          parameters: {},
        ),
      );
    });

    test('toSql integrates correctly with AlterTable', () {
      final statement = AlterTable(
        table: 'users',
        operations: [SetColumnType(column: 'email', newType: 'TEXT')],
      );
      expect(
        statement.toSql(),
        equalsSql(
          query: 'ALTER TABLE users ALTER COLUMN email TYPE TEXT;',
          parameters: {},
        ),
      );
    });

    test('toSql integrates correctly with multiple SetColumnType operations',
        () {
      final statement = AlterTable(
        table: 'users',
        operations: [
          SetColumnType(column: 'age', newType: 'BIGINT'),
          SetColumnType(column: 'email', newType: 'TEXT', using: 'email::text'),
        ],
      );
      expect(
        statement.toSql(),
        equalsSql(
          query:
              '''ALTER TABLE users ALTER COLUMN age TYPE BIGINT, ALTER COLUMN email TYPE TEXT USING email::text;''',
          parameters: {},
        ),
      );
    });
  });
}
