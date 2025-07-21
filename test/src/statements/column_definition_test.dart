import 'package:postgres_builder/postgres_builder.dart';
import 'package:test/test.dart';

import '../../_helpers.dart';

void main() {
  group('ColumnDefinition', () {
    test('toSql returns basic column', () {
      expect(
        const ColumnDefinition(name: 'id', type: 'INTEGER').toSql(),
        equalsSql(query: 'id INTEGER NOT NULL'),
      );
    });

    test('toSql with nullable', () {
      expect(
        const ColumnDefinition(name: 'id', type: 'INTEGER', nullable: true)
            .toSql(),
        equalsSql(query: 'id INTEGER'),
      );
    });

    test('toSql with primaryKey', () {
      expect(
        const ColumnDefinition(name: 'id', type: 'INTEGER', primaryKey: true)
            .toSql(),
        equalsSql(query: 'id INTEGER NOT NULL PRIMARY KEY'),
      );
    });

    test('toSql with unique', () {
      expect(
        const ColumnDefinition(name: 'email', type: 'TEXT', unique: true)
            .toSql(),
        equalsSql(query: 'email TEXT NOT NULL UNIQUE'),
      );
    });

    test('toSql with autoIncrement', () {
      expect(
        const ColumnDefinition(name: 'id', type: 'INTEGER', autoIncrement: true)
            .toSql(),
        equalsSql(query: 'id INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY'),
      );
    });

    test('toSql with check', () {
      expect(
        const ColumnDefinition(name: 'age', type: 'INTEGER', check: 'age > 0')
            .toSql(),
        equalsSql(query: 'age INTEGER NOT NULL CHECK (age > 0)'),
      );
    });

    test('toSql with references', () {
      expect(
        const ColumnDefinition(
          name: 'user_id',
          type: 'INTEGER',
          references: 'users(id)',
        ).toSql(),
        equalsSql(query: 'user_id INTEGER NOT NULL REFERENCES users(id)'),
      );
    });

    test('toSql with references and onDelete CASCADE', () {
      expect(
        const ColumnDefinition(
          name: 'user_id',
          type: 'INTEGER',
          references: 'users(id)',
          onDelete: ReferentialAction.cascade,
        ).toSql(),
        equalsSql(
          query:
              'user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE',
        ),
      );
    });

    test('toSql with references and onUpdate SET NULL', () {
      expect(
        const ColumnDefinition(
          name: 'user_id',
          type: 'INTEGER',
          references: 'users(id)',
          onUpdate: ReferentialAction.setNull,
        ).toSql(),
        equalsSql(
          query:
              '''user_id INTEGER NOT NULL REFERENCES users(id) ON UPDATE SET NULL''',
        ),
      );
    });

    test('toSql with references, onDelete CASCADE and onUpdate SET DEFAULT',
        () {
      expect(
        const ColumnDefinition(
          name: 'user_id',
          type: 'INTEGER',
          references: 'users(id)',
          onDelete: ReferentialAction.cascade,
          onUpdate: ReferentialAction.setDefault,
        ).toSql(),
        equalsSql(
          query:
              '''user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE ON UPDATE SET DEFAULT''',
        ),
      );
    });

    test('toSql with references and onDelete RESTRICT', () {
      expect(
        const ColumnDefinition(
          name: 'user_id',
          type: 'INTEGER',
          references: 'users(id)',
          onDelete: ReferentialAction.restrict,
        ).toSql(),
        equalsSql(
          query:
              '''user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE RESTRICT''',
        ),
      );
    });

    test('toSql with references and onUpdate NO ACTION', () {
      expect(
        const ColumnDefinition(
          name: 'user_id',
          type: 'INTEGER',
          references: 'users(id)',
          onUpdate: ReferentialAction.noAction,
        ).toSql(),
        equalsSql(
          query:
              '''user_id INTEGER NOT NULL REFERENCES users(id) ON UPDATE NO ACTION''',
        ),
      );
    });

    test('onDelete/onUpdate only work with references', () {
      // Should not include ON DELETE/ON UPDATE if references is null
      expect(
        const ColumnDefinition(
          name: 'user_id',
          type: 'INTEGER',
          onDelete: ReferentialAction.cascade,
          onUpdate: ReferentialAction.setNull,
        ).toSql(),
        equalsSql(query: 'user_id INTEGER NOT NULL'),
      );
    });

    test('toSql with collate', () {
      expect(
        const ColumnDefinition(name: 'name', type: 'TEXT', collate: 'en_US')
            .toSql(),
        equalsSql(query: 'name TEXT NOT NULL COLLATE en_US'),
      );
    });

    group('defaultValue', () {
      test('simple value', () {
        expect(
          const ColumnDefinition(
            name: 'age',
            type: 'INTEGER',
            defaultValue: '18',
          ).toSql(),
          equalsSql(query: 'age INTEGER DEFAULT 18 NOT NULL'),
        );
      });
      test('null', () {
        expect(
          const ColumnDefinition(
            name: 'foo',
            type: 'TEXT',
            defaultValue: 'null',
          ).toSql(),
          equalsSql(query: 'foo TEXT DEFAULT NULL NOT NULL'),
        );
      });
      test('boolean true', () {
        expect(
          const ColumnDefinition(
            name: 'flag',
            type: 'BOOLEAN',
            defaultValue: 'true',
          ).toSql(),
          equalsSql(query: 'flag BOOLEAN DEFAULT TRUE NOT NULL'),
        );
      });
      test('boolean false', () {
        expect(
          const ColumnDefinition(
            name: 'flag',
            type: 'BOOLEAN',
            defaultValue: 'false',
          ).toSql(),
          equalsSql(query: 'flag BOOLEAN DEFAULT FALSE NOT NULL'),
        );
      });
      test('already quoted string', () {
        expect(
          const ColumnDefinition(
            name: 'foo',
            type: 'TEXT',
            defaultValue: "'bar'",
          ).toSql(),
          equalsSql(query: "foo TEXT DEFAULT 'bar' NOT NULL"),
        );
      });
      test('string with special chars', () {
        expect(
          const ColumnDefinition(
            name: 'foo',
            type: 'TEXT',
            defaultValue: "bar's baz",
          ).toSql(),
          equalsSql(query: "foo TEXT DEFAULT bar's baz NOT NULL"),
        );
      });
      test('string with only safe chars', () {
        expect(
          const ColumnDefinition(
            name: 'foo',
            type: 'TEXT',
            defaultValue: 'bar_baz',
          ).toSql(),
          equalsSql(query: 'foo TEXT DEFAULT bar_baz NOT NULL'),
        );
      });
    });

    group('generated columns', () {
      test('virtual', () {
        expect(
          const ColumnDefinition(
            name: 'total',
            type: 'INTEGER',
            generated: 'price * qty',
          ).toSql(),
          equalsSql(
            query:
                '''total INTEGER GENERATED ALWAYS AS (price * qty) STORED NOT NULL''',
          ),
        );
      });
    });

    test('toSql with all modifiers including referential actions', () {
      expect(
        const ColumnDefinition(
          name: 'id',
          type: 'INTEGER',
          defaultValue: '42',
          nullable: true,
          primaryKey: true,
          unique: true,
          autoIncrement: true,
          check: 'id > 0',
          references: 'other(id)',
          onDelete: ReferentialAction.cascade,
          onUpdate: ReferentialAction.setNull,
          collate: 'en_US',
        ).toSql(),
        equalsSql(
          query:
              '''id INTEGER DEFAULT 42 GENERATED ALWAYS AS IDENTITY PRIMARY KEY UNIQUE CHECK (id > 0) REFERENCES other(id) ON DELETE CASCADE ON UPDATE SET NULL COLLATE en_US''',
        ),
      );
    });
  });
}
