import 'package:postgres_builder/postgres_builder.dart';
import 'package:test/test.dart';

import '../../_helpers.dart';

void main() {
  group('$SetNotNull', () {
    test('toSql returns correctly for a single operation', () {
      final operation = SetNotNull();
      expect(
        operation.toSql(),
        equalsSql(
          query: 'SET NOT NULL',
          parameters: {},
        ),
      );
    });

    test('toSql integrates correctly with AlterColumn', () {
      final statement = AlterColumn(
        column: 'email',
        operations: [SetNotNull()],
      );
      expect(
        statement.toSql(),
        equalsSql(
          query: 'ALTER COLUMN email SET NOT NULL',
          parameters: {},
        ),
      );
    });

    test('toSql integrates correctly with multiple SetNotNull operations', () {
      final statement = AlterColumn(
        column: 'age',
        operations: [SetNotNull(), SetNotNull()],
      );
      expect(
        statement.toSql(),
        equalsSql(
          query: '''ALTER COLUMN age SET NOT NULL, SET NOT NULL''',
          parameters: {},
        ),
      );
    });
  });
}
