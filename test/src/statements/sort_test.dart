import 'package:mocktail/mocktail.dart';
import 'package:postgres_builder/postgres_builder.dart';
import 'package:test/test.dart';

import '../../_helpers.dart';

class _MockColumn extends Mock implements Column {
  @override
  String toString() => '__colName__';
}

void main() {
  group('Sort', () {
    late Column column;

    setUp(() {
      column = _MockColumn();
      when(() => column.toSql()).thenReturn(
        const ProcessedSql(query: '__column__', parameters: {}),
      );
    });

    test('constructor sets properties correctly', () {
      final sort = Sort(column);
      expect(sort.column, equals(column));
      expect(sort.direction, equals(SortDirection.ascending));
    });

    test('constructor with direction sets properties correctly', () {
      final sort = Sort(column, direction: SortDirection.descending);
      expect(sort.column, equals(column));
      expect(sort.direction, equals(SortDirection.descending));
    });

    test('toSql returns correctly with ascending direction', () {
      expect(
        Sort(column).toSql(),
        equalsSql(
          query: '__column__ ASC',
          parameters: {},
        ),
      );
    });

    test('toSql returns correctly with descending direction', () {
      expect(
        Sort(column, direction: SortDirection.descending).toSql(),
        equalsSql(
          query: '__column__ DESC',
          parameters: {},
        ),
      );
    });

    test('~ operator returns Sort with same properties', () {
      final original = Sort(column, direction: SortDirection.descending);
      final result = ~original;
      expect(result, isA<Sort>());
      expect(result.column, equals(column));
      expect(result.direction, equals(SortDirection.descending));
    });
  });

  group('SortDirection', () {
    test('toSql() returns correctly', () {
      expect(
        SortDirection.ascending.toSql(),
        equalsSql(query: 'ASC', parameters: {}),
      );
      expect(
        SortDirection.descending.toSql(),
        equalsSql(query: 'DESC', parameters: {}),
      );
    });
  });
}
