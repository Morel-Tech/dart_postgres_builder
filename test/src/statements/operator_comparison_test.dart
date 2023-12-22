// ignore_for_file: unnecessary_lambdas

import 'package:mocktail/mocktail.dart';
import 'package:postgres_builder/postgres_builder.dart';
import 'package:test/test.dart';

import '../../_helpers.dart';

class _MockColumn extends Mock implements Column {
  @override
  String toString() {
    return '__colName__';
  }
}

void main() {
  group('OperatorComparison', () {
    test('toSql() returns correctly', () {
      final column = _MockColumn();
      when(() => column.toSql())
          .thenReturn(const ProcessedSql(query: '__sql__', parameters: {}));

      final comparison = OperatorComparision(
        column,
        '__value__',
        operator: '__operator__',
      );
      expect(
        comparison.toSql(),
        equalsSql(
          query: '__sql__ __operator__ @__operator__Parameter',
          parameters: {'__operator__Parameter': '__value__'},
        ),
      );
    });

    test('toSql() returns correctly when use', () {
      final column = _MockColumn();
      when(() => column.toSql())
          .thenReturn(const ProcessedSql(query: '__sql__', parameters: {}));
      final comparison = OperatorComparision(
        column,
        '__value__',
        operator: '__operator__',
        columnFirst: false,
      );
      expect(
        comparison.toSql(),
        equalsSql(
          query: '@__operator__Parameter __operator__ __sql__',
          parameters: {'__operator__Parameter': '__value__'},
        ),
      );
    });
  });
  group('OperatorComparison.otherColumn', () {
    test('toSql() returns correctly', () {
      final column1 = _MockColumn();
      final column2 = _MockColumn();
      when(() => column1.toSql())
          .thenReturn(const ProcessedSql(query: '__sql__', parameters: {}));

      final comparison = OperatorComparision.otherColumn(
        column1,
        column2,
        operator: '__operator__',
      );
      expect(
        comparison.toSql(),
        equalsSql(
          query: '__sql__ __operator__ __colName__',
          parameters: {},
        ),
      );
    });
  });
}
