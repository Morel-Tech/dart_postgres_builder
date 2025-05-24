import 'package:postgres_builder/postgres_builder.dart';
import 'package:test/test.dart';

import '../../_helpers.dart';

void main() {
  group('$SetColumnDefault', () {
    test('toSql returns correctly for a single column', () {
      final operation = SetColumnDefault(column: 'age', defaultValue: '18');
      expect(
        operation.toSql(),
        equalsSql(
          query: 'ALTER COLUMN age SET DEFAULT 18',
          parameters: {},
        ),
      );
    });

    test('toSql integrates correctly with AlterTable', () {
      final statement = AlterTable(
        table: 'users',
        operations: [SetColumnDefault(column: 'email', defaultValue: "'none'")],
      );
      expect(
        statement.toSql(),
        equalsSql(
          query: "ALTER TABLE users ALTER COLUMN email SET DEFAULT 'none';",
          parameters: {},
        ),
      );
    });

    test('toSql integrates correctly with multiple SetColumnDefault operations',
        () {
      final statement = AlterTable(
        table: 'users',
        operations: [
          SetColumnDefault(column: 'age', defaultValue: '18'),
          SetColumnDefault(column: 'email', defaultValue: "'none'"),
        ],
      );
      expect(
        statement.toSql(),
        equalsSql(
          query:
              '''ALTER TABLE users ALTER COLUMN age SET DEFAULT 18, ALTER COLUMN email SET DEFAULT 'none';''',
          parameters: {},
        ),
      );
    });
  });
}
