import 'package:mocktail/mocktail.dart';
import 'package:postgres_builder/postgres_builder.dart';
import 'package:test/test.dart';

import '../../_helpers.dart';

class _MockColumn extends Mock implements Column {}

void main() {
  group('Group', () {
    test('.toSql returns correctly', () {
      final column1 = _MockColumn();
      final column2 = _MockColumn();
      when(() => column1.parameterName).thenReturn('__column1__');
      when(() => column2.parameterName).thenReturn('__column2__');
      expect(
        Group([column1, column2]).toSql(),
        equalsSql(query: 'GROUP BY __column1__, __column2__'),
      );
    });
  });
}
