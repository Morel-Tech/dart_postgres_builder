import 'package:postgres_builder/postgres_builder.dart';
import 'package:test/test.dart';

import '../../_helpers.dart';

void main() {
  group('$DropNotNull', () {
    test('toSql returns correctly for a single operation', () {
      final operation = DropNotNull();
      expect(
        operation.toSql(),
        equalsSql(
          query: 'DROP NOT NULL',
          parameters: {},
        ),
      );
    });

    test('toSql integrates correctly with AlterColumn', () {
      final statement = AlterColumn(
        column: 'email',
        operations: [DropNotNull()],
      );
      expect(
        statement.toSql(),
        equalsSql(
          query: 'ALTER COLUMN email DROP NOT NULL',
          parameters: {},
        ),
      );
    });

    test('toSql integrates correctly with multiple DropNotNull operations', () {
      final statement = AlterColumn(
        column: 'age',
        operations: [DropNotNull(), DropNotNull()],
      );
      expect(
        statement.toSql(),
        equalsSql(
          query: '''ALTER COLUMN age DROP NOT NULL, DROP NOT NULL''',
          parameters: {},
        ),
      );
    });
  });
}
