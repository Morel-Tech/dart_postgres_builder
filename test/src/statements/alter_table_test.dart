import 'package:postgres_builder/postgres_builder.dart';
import 'package:test/test.dart';

import '../../_helpers.dart';

void main() {
  group('$AlterTable', () {
    test('toSql returns correctly with a single operation', () {
      final operation = SetColumnNotNull(column: 'age');
      final statement = AlterTable(
        table: 'users',
        operations: [operation],
      );
      expect(
        statement.toSql(),
        equalsSql(
          query: 'ALTER TABLE users ALTER COLUMN age SET NOT NULL;',
          parameters: {},
        ),
      );
    });

    test('toSql returns correctly with multiple operations', () {
      final op1 = SetColumnNotNull(column: 'age');
      final op2 = RenameColumn(column: 'username', newName: 'user_name');
      final op3 = DropColumnDefault(column: 'email');
      final statement = AlterTable(
        table: 'users',
        operations: [op1, op2, op3],
      );
      expect(
        statement.toSql(),
        equalsSql(
          query:
              '''ALTER TABLE users ALTER COLUMN age SET NOT NULL, RENAME COLUMN username TO user_name, ALTER COLUMN email DROP DEFAULT;''',
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
          query: 'ALTER TABLE users;',
          parameters: {},
        ),
      );
    });
  });
}
