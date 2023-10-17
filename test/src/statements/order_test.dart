import 'package:mocktail/mocktail.dart';
import 'package:postgres_builder/postgres_builder.dart';
import 'package:test/test.dart';

import '../../_helpers.dart';

class _MockColumn extends Mock implements Column {
  @override
  String toString() => '__colName__';
}

void main() {
  group('Order', () {
    test('toSql() returns correctly', () {
      final column = _MockColumn();
      expect(
        Order([column]).toSql(),
        equalsSql(
          query: 'ORDER BY __colName__ ASC',
          parameters: {},
        ),
      );
    });
  });

  group('SortOrder', () {
    test('toSql() returns correctly', () {
      expect(
        SortOrder.ascending.toSql(),
        equalsSql(query: 'ASC', parameters: {}),
      );
      expect(
        SortOrder.descending.toSql(),
        equalsSql(query: 'DESC', parameters: {}),
      );
    });
  });
}
