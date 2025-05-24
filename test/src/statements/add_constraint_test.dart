import 'package:postgres_builder/postgres_builder.dart';
import 'package:test/test.dart';

import '../../_helpers.dart';

void main() {
  group('$AddConstraint', () {
    test('toSql returns correctly for adding a constraint', () {
      final operation = AddConstraint(constraint: 'UNIQUE');
      expect(
        operation.toSql(),
        equalsSql(
          query: 'ADD UNIQUE',
          parameters: {},
        ),
      );
    });

    test('toSql integrates correctly with AlterColumn', () {
      final statement = AlterColumn(
        column: 'email',
        operations: [AddConstraint(constraint: 'UNIQUE')],
      );
      expect(
        statement.toSql(),
        equalsSql(
          query: 'ALTER COLUMN email ADD UNIQUE',
          parameters: {},
        ),
      );
    });
  });
}
