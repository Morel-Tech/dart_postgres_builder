import 'package:postgres_builder/postgres_builder.dart';
import 'package:test/test.dart';

import '../../_helpers.dart';

void main() {
  group('ForeignKeyConstraint', () {
    test('toSql returns basic foreign key constraint', () {
      const constraint = ForeignKeyConstraint(
        columns: ['user_id'],
        referencesTable: 'users',
        referencesColumns: ['id'],
      );
      expect(
        constraint.toSql(),
        equals('FOREIGN KEY (user_id) REFERENCES users (id)'),
      );
    });

    test('toSql with named constraint', () {
      const constraint = ForeignKeyConstraint(
        name: 'fk_user_id',
        columns: ['user_id'],
        referencesTable: 'users',
        referencesColumns: ['id'],
      );
      expect(
        constraint.toSql(),
        equals(
          'CONSTRAINT fk_user_id FOREIGN KEY (user_id) REFERENCES users (id)',
        ),
      );
    });

    test('toSql with multiple columns', () {
      const constraint = ForeignKeyConstraint(
        columns: ['first_name', 'last_name'],
        referencesTable: 'persons',
        referencesColumns: ['first_name', 'last_name'],
      );
      expect(
        constraint.toSql(),
        equals(
          '''FOREIGN KEY (first_name, last_name) REFERENCES persons (first_name, last_name)''',
        ),
      );
    });

    test('toSql with onDelete CASCADE', () {
      const constraint = ForeignKeyConstraint(
        columns: ['user_id'],
        referencesTable: 'users',
        referencesColumns: ['id'],
        onDelete: ReferentialAction.cascade,
      );
      expect(
        constraint.toSql(),
        equals('FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE'),
      );
    });

    test('toSql with onUpdate SET NULL', () {
      const constraint = ForeignKeyConstraint(
        columns: ['user_id'],
        referencesTable: 'users',
        referencesColumns: ['id'],
        onUpdate: ReferentialAction.setNull,
      );
      expect(
        constraint.toSql(),
        equals(
          '''FOREIGN KEY (user_id) REFERENCES users (id) ON UPDATE SET NULL''',
        ),
      );
    });

    test('toSql with both onDelete and onUpdate', () {
      const constraint = ForeignKeyConstraint(
        columns: ['user_id'],
        referencesTable: 'users',
        referencesColumns: ['id'],
        onDelete: ReferentialAction.cascade,
        onUpdate: ReferentialAction.setDefault,
      );
      expect(
        constraint.toSql(),
        equals(
          '''FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE ON UPDATE SET DEFAULT''',
        ),
      );
    });

    test('toSql with all referential actions', () {
      expect(
        const ForeignKeyConstraint(
          columns: ['user_id'],
          referencesTable: 'users',
          referencesColumns: ['id'],
          onDelete: ReferentialAction.restrict,
        ).toSql(),
        contains('ON DELETE RESTRICT'),
      );

      expect(
        const ForeignKeyConstraint(
          columns: ['user_id'],
          referencesTable: 'users',
          referencesColumns: ['id'],
          onUpdate: ReferentialAction.noAction,
        ).toSql(),
        contains('ON UPDATE NO ACTION'),
      );

      expect(
        const ForeignKeyConstraint(
          columns: ['user_id'],
          referencesTable: 'users',
          referencesColumns: ['id'],
          onDelete: ReferentialAction.setNull,
        ).toSql(),
        contains('ON DELETE SET NULL'),
      );

      expect(
        const ForeignKeyConstraint(
          columns: ['user_id'],
          referencesTable: 'users',
          referencesColumns: ['id'],
          onUpdate: ReferentialAction.setDefault,
        ).toSql(),
        contains('ON UPDATE SET DEFAULT'),
      );
    });

    test('works with AddConstraint', () {
      const fkConstraint = ForeignKeyConstraint(
        name: 'fk_posts_user_id',
        columns: ['user_id'],
        referencesTable: 'users',
        referencesColumns: ['id'],
        onDelete: ReferentialAction.cascade,
      );

      final addConstraint = AddConstraint(constraint: fkConstraint.toSql());
      expect(
        addConstraint.toSql(),
        equalsSql(
          query:
              '''ADD CONSTRAINT fk_posts_user_id FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE''',
        ),
      );
    });

    test('works with CreateTable constraints', () {
      const columns = [
        ColumnDefinition(name: 'id', type: 'SERIAL', primaryKey: true),
        ColumnDefinition(name: 'user_id', type: 'INTEGER'),
        ColumnDefinition(name: 'title', type: 'TEXT'),
      ];

      const fkConstraint = ForeignKeyConstraint(
        name: 'fk_posts_user_id',
        columns: ['user_id'],
        referencesTable: 'users',
        referencesColumns: ['id'],
        onDelete: ReferentialAction.cascade,
        onUpdate: ReferentialAction.setNull,
      );

      const createTable = CreateTable(
        name: 'posts',
        columns: columns,
        constraints: [ForeignKeyTableConstraint(fkConstraint)],
      );

      expect(
        createTable.toSql(),
        equalsSql(
          query:
              '''CREATE TABLE posts (id SERIAL NOT NULL PRIMARY KEY, user_id INTEGER NOT NULL, title TEXT NOT NULL, CONSTRAINT fk_posts_user_id FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE ON UPDATE SET NULL)''',
        ),
      );
    });
  });
}
