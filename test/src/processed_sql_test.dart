import 'package:postgres_builder/postgres_builder.dart';
import 'package:test/test.dart';

void main() {
  group('ProcessedSql', () {
    test('to String returns correctly', () {
      expect(
        const ProcessedSql(
          query: '__query__',
          parameters: {'__key__': '__value__'},
        ).toString(),
        equals('__query__\n--with--\n{__key__: __value__}'),
      );
    });
  });
}
