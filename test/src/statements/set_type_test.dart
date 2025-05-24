import 'package:postgres_builder/postgres_builder.dart';
import 'package:test/test.dart';

import '../../_helpers.dart';

void main() {
  group('$SetType', () {
    test('toSql returns correctly for a single column without using', () {
      final operation = SetType(newType: 'BIGINT');
      expect(
        operation.toSql(),
        equalsSql(
          query: 'TYPE BIGINT',
          parameters: {},
        ),
      );
    });

    test('toSql returns correctly for a single column with using', () {
      final operation = SetType(newType: 'BIGINT', using: 'age::bigint');
      expect(
        operation.toSql(),
        equalsSql(
          query: 'TYPE BIGINT USING age::bigint',
          parameters: {},
        ),
      );
    });

    test('toSql integrates correctly with AlterTable', () {
      final statement = AlterTable(
        table: 'users',
        operations: [
          AlterColumn(column: 'email', operations: [SetType(newType: 'TEXT')]),
        ],
      );
      expect(
        statement.toSql(),
        equalsSql(
          query: 'ALTER TABLE users ALTER COLUMN email TYPE TEXT',
          parameters: {},
        ),
      );
    });

    test('toSql integrates correctly with multiple $SetType operations', () {
      final statement = AlterTable(
        table: 'users',
        operations: [
          AlterColumn(column: 'age', operations: [SetType(newType: 'BIGINT')]),
          AlterColumn(
            column: 'email',
            operations: [SetType(newType: 'TEXT', using: 'email::text')],
          ),
        ],
      );
      expect(
        statement.toSql(),
        equalsSql(
          query:
              '''ALTER TABLE users ALTER COLUMN age TYPE BIGINT, ALTER COLUMN email TYPE TEXT USING email::text''',
          parameters: {},
        ),
      );
    });
  });
}
