import 'package:postgres_builder/postgres_builder.dart';
import 'package:test/test.dart';

import '../../_helpers.dart';

void main() {
  group('TrueFilter', () {
    test('extends FilterStatement', () {
      expect(
        const TrueFilter(),
        isA<FilterStatement>(),
      );
    });

    test('toSql() returns TRUE with no parameters', () {
      expect(
        const TrueFilter().toSql(),
        equalsSql(
          query: 'TRUE',
          parameters: {},
        ),
      );
    });

    test('is const constructible', () {
      const filter = TrueFilter();
      expect(filter, isA<TrueFilter>());
    });

    test('multiple instances are equal', () {
      const filter1 = TrueFilter();
      const filter2 = TrueFilter();
      expect(filter1, equals(filter2));
    });
  });
}
