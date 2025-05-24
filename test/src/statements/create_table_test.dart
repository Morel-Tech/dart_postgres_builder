import 'package:postgres_builder/postgres_builder.dart';
import 'package:test/test.dart';

import '../../_helpers.dart';

void main() {
  group('CreateTable', () {
    test('toSql returns correctly', () {
      final columns = [
        const ColumnDefinition(name: 'id', type: 'SERIAL', primaryKey: true),
        const ColumnDefinition(name: 'name', type: 'TEXT'),
      ];
      final statement = CreateTable(
        name: 'users',
        columns: columns,
        ifNotExists: true,
      );
      expect(
        statement.toSql(),
        equalsSql(
          query:
              '''CREATE TABLE IF NOT EXISTS users (id SERIAL NOT NULL PRIMARY KEY, name TEXT NOT NULL)''',
          parameters: {},
        ),
      );
    });
  });
}
