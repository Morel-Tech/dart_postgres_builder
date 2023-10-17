import 'package:mocktail/mocktail.dart';
import 'package:postgres_builder/postgres_builder.dart';
import 'package:test/test.dart';

import '../../_helpers.dart';

class _MockFilterStatement extends Mock implements FilterStatement {}

void main() {
  group('Delete', () {
    test('toSql returns correctly', () {
      final statement = _MockFilterStatement();
      when(statement.toSql).thenReturn(
        const ProcessedSql(
          query: '__query__',
          parameters: {'__key__': '__value__'},
        ),
      );
      expect(
        Delete(from: '__table__', where: statement).toSql(),
        equalsSql(
          query: 'DELETE FROM __table__ WHERE __query__ RETURNING *',
          parameters: {'__key__': '__value__'},
        ),
      );
    });
  });
}
