// ignore_for_file: unnecessary_lambdas

import 'package:mocktail/mocktail.dart';
import 'package:postgres_builder/postgres_builder.dart';
import 'package:test/test.dart';

import '../../_helpers.dart';

class _MockColumn extends Mock implements Column {
  @override
  String toString() => '__colName__';
}

void main() {
  group('OperatorComparison', () {
    test('toSql() returns correctly', () {
      final column = _MockColumn();
      when(() => column.parameterName).thenReturn('__paramName__');

      final comparison = OperatorComparision(
        column,
        '__value__',
        operator: '__operator__',
      );
      expect(
        comparison.toSql(),
        equalsSql(
          query: '__colName__ __operator__ @__paramName__',
          parameters: {'__paramName__': '__value__'},
        ),
      );
    });
  });
  group('OperatorComparison.otherColumn', () {
    test('toSql() returns correctly', () {
      final column1 = _MockColumn();
      final column2 = _MockColumn();

      final comparison = OperatorComparision.otherColumn(
        column1,
        column2,
        operator: '__operator__',
      );
      expect(
        comparison.toSql(),
        equalsSql(
          query: '__colName__ __operator__ __colName__',
          parameters: {},
        ),
      );
    });
  });
}
