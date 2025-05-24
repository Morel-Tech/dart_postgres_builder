import 'package:postgres_builder/postgres_builder.dart';
import 'package:test/test.dart';

import '../../_helpers.dart';

void main() {
  group('$RenameTable', () {
    test('toSql returns correctly for renaming a table', () {
      final operation = RenameTable(newName: 'new_users');
      expect(
        operation.toSql(),
        equalsSql(
          query: 'RENAME TO new_users',
          parameters: {},
        ),
      );
    });

    test('toSql integrates correctly with AlterTable', () {
      final statement = AlterTable(
        table: 'users',
        operations: [RenameTable(newName: 'new_users')],
      );
      expect(
        statement.toSql(),
        equalsSql(
          query: 'ALTER TABLE users RENAME TO new_users',
          parameters: {},
        ),
      );
    });
  });
}
