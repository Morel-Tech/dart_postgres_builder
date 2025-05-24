import 'package:postgres_builder/postgres_builder.dart';
import 'package:test/test.dart';

import '../../_helpers.dart';

void main() {
  group('$DropColumnNotNull', () {
    test('toSql returns correctly for a single column', () {
      final operation = DropColumnNotNull(column: 'age');
      expect(
        operation.toSql(),
        equalsSql(
          query: 'ALTER COLUMN age DROP NOT NULL',
          parameters: {},
        ),
      );
    });

    test('toSql integrates correctly with AlterTable', () {
      final statement = AlterTable(
        table: 'users',
        operations: [DropColumnNotNull(column: 'email')],
      );
      expect(
        statement.toSql(),
        equalsSql(
          query: 'ALTER TABLE users ALTER COLUMN email DROP NOT NULL;',
          parameters: {},
        ),
      );
    });

    test(
        'toSql integrates correctly with multiple DropColumnNotNull operations',
        () {
      final statement = AlterTable(
        table: 'users',
        operations: [
          DropColumnNotNull(column: 'age'),
          DropColumnNotNull(column: 'email'),
        ],
      );
      expect(
        statement.toSql(),
        equalsSql(
          query:
              '''ALTER TABLE users ALTER COLUMN age DROP NOT NULL, ALTER COLUMN email DROP NOT NULL;''',
          parameters: {},
        ),
      );
    });
  });
}
