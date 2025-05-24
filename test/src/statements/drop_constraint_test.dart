import 'package:postgres_builder/postgres_builder.dart';
import 'package:test/test.dart';

import '../../_helpers.dart';

void main() {
  group('$DropConstraint', () {
    test('toSql returns correctly for dropping a constraint', () {
      final operation = DropConstraint(constraintName: 'email_unique');
      expect(
        operation.toSql(),
        equalsSql(
          query: 'DROP CONSTRAINT email_unique',
          parameters: {},
        ),
      );
    });

    test('toSql integrates correctly with AlterColumn', () {
      final statement = AlterColumn(
        column: 'email',
        operations: [DropConstraint(constraintName: 'email_unique')],
      );
      expect(
        statement.toSql(),
        equalsSql(
          query: 'ALTER COLUMN email DROP CONSTRAINT email_unique',
          parameters: {},
        ),
      );
    });
  });
}
