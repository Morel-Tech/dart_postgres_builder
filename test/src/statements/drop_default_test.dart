import 'package:postgres_builder/postgres_builder.dart';
import 'package:test/test.dart';

import '../../_helpers.dart';

void main() {
  group('$DropDefault', () {
    test('toSql returns correctly for a single column', () {
      final operation = DropDefault();
      expect(
        operation.toSql(),
        equalsSql(
          query: 'DROP DEFAULT',
          parameters: {},
        ),
      );
    });

    test('toSql integrates correctly with AlterTable', () {
      final statement = AlterTable(
        table: 'users',
        operations: [
          AlterColumn(column: 'email', operations: [DropDefault()]),
        ],
      );
      expect(
        statement.toSql(),
        equalsSql(
          query: 'ALTER TABLE users ALTER COLUMN email DROP DEFAULT',
          parameters: {},
        ),
      );
    });

    test('toSql integrates correctly with multiple $DropDefault operations',
        () {
      final statement = AlterTable(
        table: 'users',
        operations: [
          AlterColumn(column: 'age', operations: [DropDefault()]),
          AlterColumn(column: 'email', operations: [DropDefault()]),
        ],
      );
      expect(
        statement.toSql(),
        equalsSql(
          query:
              '''ALTER TABLE users ALTER COLUMN age DROP DEFAULT, ALTER COLUMN email DROP DEFAULT''',
          parameters: {},
        ),
      );
    });
  });
}
