import 'package:postgres_builder/postgres_builder.dart';
import 'package:test/test.dart';

void main() {
  group('PostgresBuilderException', () {
    test('can be created', () {
      expect(
        const PostgresBuilderException('__message__'),
        isA<PostgresBuilderException>(),
      );
    });
  });
}
