import 'package:postgres_builder/postgres_builder.dart';
import 'package:test/test.dart';

import '../../_helpers.dart';

void main() {
  group('$AlterTable', () {
    test('toSql returns correctly with a single operation', () {
      final operation = RenameTable(newName: 'users_new');
      final statement = AlterTable(
        table: 'users',
        operations: [operation],
      );
      expect(
        statement.toSql(),
        equalsSql(
          query: 'ALTER TABLE users RENAME TO users_new',
          parameters: {},
        ),
      );
    });

    test('toSql returns correctly with multiple operations', () {
      final op1 = RenameTable(newName: 'users_new');
      final op2 = RenameColumn(column: 'username', newName: 'user_name');
      final op3 = RenameTable(newName: 'users_new_2');
      final statement = AlterTable(
        table: 'users',
        operations: [op1, op2, op3],
      );
      expect(
        statement.toSql(),
        equalsSql(
          query:
              '''ALTER TABLE users RENAME TO users_new, RENAME COLUMN username TO user_name, RENAME TO users_new_2''',
          parameters: {},
        ),
      );
    });

    test('toSql returns correctly with no operations', () {
      final statement = AlterTable(
        table: 'users',
        operations: [],
      );
      expect(
        statement.toSql(),
        equalsSql(
          query: 'ALTER TABLE users',
          parameters: {},
        ),
      );
    });
  });
}
