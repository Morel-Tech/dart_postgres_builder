import 'package:postgres_builder/postgres_builder.dart';
import 'package:test/test.dart';

import '../../_helpers.dart';

void main() {
  group('AddColumn', () {
    test('toSql returns correctly without ifNotExists', () {
      const column = ColumnDefinition(name: 'age', type: 'INTEGER');
      final statement = AddColumn(
        table: 'users',
        column: column,
      );
      expect(
        statement.toSql(),
        equalsSql(
          query: 'ALTER TABLE users ADD COLUMN age INTEGER NOT NULL;',
          parameters: {},
        ),
      );
    });

    test('toSql returns correctly with ifNotExists', () {
      const column = ColumnDefinition(name: 'email', type: 'TEXT');
      final statement = AddColumn(
        table: 'users',
        column: column,
        ifNotExists: true,
      );
      expect(
        statement.toSql(),
        equalsSql(
          query:
              'ALTER TABLE users ADD COLUMN IF NOT EXISTS email TEXT NOT NULL;',
          parameters: {},
        ),
      );
    });
  });
}
