import 'package:postgres_builder/postgres_builder.dart';
import 'package:test/test.dart';

import '../../_helpers.dart';

void main() {
  group('$DropColumnDefault', () {
    test('toSql returns correctly for a single column', () {
      final operation = DropColumnDefault(column: 'age');
      expect(
        operation.toSql(),
        equalsSql(
          query: 'ALTER COLUMN age DROP DEFAULT',
          parameters: {},
        ),
      );
    });

    test('toSql integrates correctly with AlterTable', () {
      final statement = AlterTable(
        table: 'users',
        operations: [DropColumnDefault(column: 'email')],
      );
      expect(
        statement.toSql(),
        equalsSql(
          query: 'ALTER TABLE users ALTER COLUMN email DROP DEFAULT;',
          parameters: {},
        ),
      );
    });

    test(
        'toSql integrates correctly with multiple DropColumnDefault operations',
        () {
      final statement = AlterTable(
        table: 'users',
        operations: [
          DropColumnDefault(column: 'age'),
          DropColumnDefault(column: 'email'),
        ],
      );
      expect(
        statement.toSql(),
        equalsSql(
          query:
              '''ALTER TABLE users ALTER COLUMN age DROP DEFAULT, ALTER COLUMN email DROP DEFAULT;''',
          parameters: {},
        ),
      );
    });
  });
}
