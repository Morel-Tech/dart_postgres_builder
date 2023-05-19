// ignore_for_file: prefer_const_constructors
import 'package:postgres_builder/postgres_builder.dart';
import 'package:test/test.dart';

void main() {
  group('PostgresBuilder', () {
    test('can be instantiated', () {
      expect(PostgresBuilder(), isNotNull);
    });
  });
}
