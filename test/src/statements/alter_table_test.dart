import 'package:postgres_builder/postgres_builder.dart';
import 'package:test/test.dart';

import '../../_helpers.dart';

void main() {
  group('$AlterTable', () {
    test('toSql returns correctly with a single operation', () {
      final operation = RenameTable(newName: 'users_new');
      final statement = AlterTable(
        table: 'users',
        operations: [operation],
      );
      expect(
        statement.toSql(),
        equalsSql(
          query: 'ALTER TABLE users RENAME TO users_new',
          parameters: {},
        ),
      );
    });

    test('toSql returns correctly with multiple operations', () {
      final op1 = RenameTable(newName: 'users_new');
      final op2 = RenameColumn(column: 'username', newName: 'user_name');
      final op3 = RenameTable(newName: 'users_new_2');
      final statement = AlterTable(
        table: 'users',
        operations: [op1, op2, op3],
      );
      expect(
        statement.toSql(),
        equalsSql(
          query:
              '''ALTER TABLE users RENAME TO users_new, RENAME COLUMN username TO user_name, RENAME TO users_new_2''',
          parameters: {},
        ),
      );
    });

    test('toSql returns correctly with no operations', () {
      final statement = AlterTable(
        table: 'users',
        operations: [],
      );
      expect(
        statement.toSql(),
        equalsSql(
          query: 'ALTER TABLE users',
          parameters: {},
        ),
      );
    });

    test('toSql returns correctly when adding foreign key constraint', () {
      const fkConstraint = ForeignKeyConstraint(
        name: 'fk_posts_user_id',
        columns: ['user_id'],
        referencesTable: 'users',
        referencesColumns: ['id'],
        onDelete: ReferentialAction.cascade,
        onUpdate: ReferentialAction.setNull,
      );

      final statement = AlterTable(
        table: 'posts',
        operations: [AddConstraint(constraint: fkConstraint.toSql())],
      );

      expect(
        statement.toSql(),
        equalsSql(
          query:
              '''ALTER TABLE posts ADD CONSTRAINT fk_posts_user_id FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE ON UPDATE SET NULL''',
          parameters: {},
        ),
      );
    });

    test('toSql returns correctly when adding multiple constraints', () {
      const fkConstraint1 = ForeignKeyConstraint(
        name: 'fk_posts_user_id',
        columns: ['user_id'],
        referencesTable: 'users',
        referencesColumns: ['id'],
        onDelete: ReferentialAction.cascade,
      );

      const fkConstraint2 = ForeignKeyConstraint(
        name: 'fk_posts_category_id',
        columns: ['category_id'],
        referencesTable: 'categories',
        referencesColumns: ['id'],
        onUpdate: ReferentialAction.setNull,
      );

      final statement = AlterTable(
        table: 'posts',
        operations: [
          AddConstraint(constraint: fkConstraint1.toSql()),
          AddConstraint(constraint: fkConstraint2.toSql()),
        ],
      );

      expect(
        statement.toSql(),
        equalsSql(
          query:
              '''ALTER TABLE posts ADD CONSTRAINT fk_posts_user_id FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE, ADD CONSTRAINT fk_posts_category_id FOREIGN KEY (category_id) REFERENCES categories (id) ON UPDATE SET NULL''',
          parameters: {},
        ),
      );
    });
  });
}
