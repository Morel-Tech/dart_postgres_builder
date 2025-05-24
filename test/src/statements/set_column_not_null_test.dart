import 'package:postgres_builder/postgres_builder.dart';
import 'package:test/test.dart';

import '../../_helpers.dart';

void main() {
  group('$SetColumnNotNull', () {
    test('toSql returns correctly for a single column', () {
      final operation = SetColumnNotNull(column: 'age');
      expect(
        operation.toSql(),
        equalsSql(
          query: 'ALTER COLUMN age SET NOT NULL',
          parameters: {},
        ),
      );
    });

    test('toSql integrates correctly with AlterTable', () {
      final statement = AlterTable(
        table: 'users',
        operations: [SetColumnNotNull(column: 'email')],
      );
      expect(
        statement.toSql(),
        equalsSql(
          query: 'ALTER TABLE users ALTER COLUMN email SET NOT NULL;',
          parameters: {},
        ),
      );
    });

    test('toSql integrates correctly with multiple SetColumnNotNull operations',
        () {
      final statement = AlterTable(
        table: 'users',
        operations: [
          SetColumnNotNull(column: 'age'),
          SetColumnNotNull(column: 'email'),
        ],
      );
      expect(
        statement.toSql(),
        equalsSql(
          query:
              '''ALTER TABLE users ALTER COLUMN age SET NOT NULL, ALTER COLUMN email SET NOT NULL;''',
          parameters: {},
        ),
      );
    });
  });
}
