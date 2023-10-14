import 'package:postgres_builder/postgres_builder.dart';
import 'package:test/test.dart';

import '../../_helpers.dart';

void main() {
  group('Not', () {
    test('toSql() returns correctly', () {
      const column = Column('__colName__');
      expect(
        const Not(column).toSql(),
        equalsSql(
          query: 'NOT $column',
        ),
      );
    });
  });
}
