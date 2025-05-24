import 'package:postgres_builder/postgres_builder.dart';
import 'package:test/test.dart';

import '../../_helpers.dart';

void main() {
  group('$DropColumn', () {
    test('toSql returns correctly without ifExists', () {
      final statement = AlterTable(
        table: 'users',
        operations: [DropColumn(column: 'age')],
      );
      expect(
        statement.toSql(),
        equalsSql(
          query: 'ALTER TABLE users DROP COLUMN age;',
          parameters: {},
        ),
      );
    });

    test('toSql returns correctly with ifExists', () {
      final statement = AlterTable(
        table: 'users',
        operations: [DropColumn(column: 'email', ifExists: true)],
      );
      expect(
        statement.toSql(),
        equalsSql(
          query: 'ALTER TABLE users DROP COLUMN IF EXISTS email;',
          parameters: {},
        ),
      );
    });

    test('toSql returns correctly for a different table and column', () {
      final statement = AlterTable(
        table: 'products',
        operations: [DropColumn(column: 'price')],
      );
      expect(
        statement.toSql(),
        equalsSql(
          query: 'ALTER TABLE products DROP COLUMN price;',
          parameters: {},
        ),
      );
    });

    test('toSql returns correctly with multiple columns', () {
      final statement = AlterTable(
        table: 'users',
        operations: [
          DropColumn(column: 'age'),
          DropColumn(column: 'email'),
        ],
      );
      expect(
        statement.toSql(),
        equalsSql(
          query: 'ALTER TABLE users DROP COLUMN age, DROP COLUMN email;',
          parameters: {},
        ),
      );
    });
  });
}
