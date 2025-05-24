import 'package:postgres_builder/postgres_builder.dart';
import 'package:test/test.dart';

import '../../_helpers.dart';

void main() {
  group('$RenameColumn', () {
    test('toSql returns correctly for a single column', () {
      final operation = RenameColumn(column: 'username', newName: 'user_name');
      expect(
        operation.toSql(),
        equalsSql(
          query: 'RENAME COLUMN username TO user_name',
          parameters: {},
        ),
      );
    });

    test('toSql integrates correctly with AlterTable', () {
      final statement = AlterTable(
        table: 'users',
        operations: [RenameColumn(column: 'username', newName: 'user_name')],
      );
      expect(
        statement.toSql(),
        equalsSql(
          query: 'ALTER TABLE users RENAME COLUMN username TO user_name',
          parameters: {},
        ),
      );
    });

    test('toSql integrates correctly with multiple RenameColumn operations',
        () {
      final statement = AlterTable(
        table: 'users',
        operations: [
          RenameColumn(column: 'username', newName: 'user_name'),
          RenameColumn(column: 'email', newName: 'contact_email'),
        ],
      );
      expect(
        statement.toSql(),
        equalsSql(
          query:
              '''ALTER TABLE users RENAME COLUMN username TO user_name, RENAME COLUMN email TO contact_email''',
          parameters: {},
        ),
      );
    });
  });
}
