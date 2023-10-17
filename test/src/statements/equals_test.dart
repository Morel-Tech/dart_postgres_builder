import 'package:mocktail/mocktail.dart';
import 'package:postgres_builder/postgres_builder.dart';
import 'package:test/test.dart';

class _MockColumn extends Mock implements Column {
  @override
  String toString() => '__colName__';
}

void main() {
  group('Equals', () {
    test('extends OperatorComparison', () {
      expect(
        Equals(_MockColumn(), '__value__'),
        isA<OperatorComparision>()
            .having((e) => e.operator, 'operator', equals('=')),
      );
    });
  });
  group('Equals.otherColumn', () {
    test('extends OperatorComparison', () {
      expect(
        Equals.otherColumn(_MockColumn(), _MockColumn()),
        isA<OperatorComparision>()
            .having((e) => e.operator, 'operator', equals('=')),
      );
    });
  });
}
