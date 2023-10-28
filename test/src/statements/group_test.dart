import 'package:postgres_builder/postgres_builder.dart';
import 'package:test/test.dart';

import '../../_helpers.dart';

void main() {
  group('Group', () {
    test('.toSql returns correctly', () {
      const column1 = Column('__column1__');
      const column2 = Column('__column2__');
      expect(
        Group([column1, column2]).toSql(),
        equalsSql(query: 'GROUP BY __column1__, __column2__'),
      );
    });
  });
}
