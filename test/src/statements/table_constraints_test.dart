import 'package:postgres_builder/postgres_builder.dart';
import 'package:test/test.dart';

import '../../_helpers.dart';

void main() {
  group('Table Constraints', () {
    group('PrimaryKeyConstraint', () {
      test('single column primary key', () {
        final constraint = PrimaryKeyConstraint(['id']);
        expect(
          constraint.toSql(),
          equalsSql(
            query: 'PRIMARY KEY (id)',
            parameters: {},
          ),
        );
      });

      test('composite primary key', () {
        final constraint = PrimaryKeyConstraint(['user_id', 'tenant_id']);
        expect(
          constraint.toSql(),
          equalsSql(
            query: 'PRIMARY KEY (user_id, tenant_id)',
            parameters: {},
          ),
        );
      });

      test('named primary key constraint', () {
        final constraint = PrimaryKeyConstraint(['id'], name: 'pk_users');
        expect(
          constraint.toSql(),
          equalsSql(
            query: 'CONSTRAINT pk_users PRIMARY KEY (id)',
            parameters: {},
          ),
        );
      });

      test('named composite primary key', () {
        final constraint = PrimaryKeyConstraint(
          ['user_id', 'tenant_id'],
          name: 'pk_user_tenants',
        );
        expect(
          constraint.toSql(),
          equalsSql(
            query:
                'CONSTRAINT pk_user_tenants PRIMARY KEY (user_id, tenant_id)',
            parameters: {},
          ),
        );
      });
    });

    group('UniqueConstraint', () {
      test('single column unique', () {
        final constraint = UniqueConstraint(['email']);
        expect(
          constraint.toSql(),
          equalsSql(
            query: 'UNIQUE (email)',
            parameters: {},
          ),
        );
      });

      test('composite unique constraint', () {
        final constraint = UniqueConstraint(['email', 'tenant_id']);
        expect(
          constraint.toSql(),
          equalsSql(
            query: 'UNIQUE (email, tenant_id)',
            parameters: {},
          ),
        );
      });

      test('named unique constraint', () {
        final constraint = UniqueConstraint(['email'], name: 'unique_email');
        expect(
          constraint.toSql(),
          equalsSql(
            query: 'CONSTRAINT unique_email UNIQUE (email)',
            parameters: {},
          ),
        );
      });
    });

    group('CheckConstraint', () {
      test('simple check constraint', () {
        const constraint = CheckConstraint('age > 0');
        expect(
          constraint.toSql(),
          equalsSql(
            query: 'CHECK (age > 0)',
            parameters: {},
          ),
        );
      });

      test('complex check constraint', () {
        const constraint = CheckConstraint(
          '''created_at >= '2020-01-01'::date AND status IN ('active', 'inactive')''',
        );
        expect(
          constraint.toSql(),
          equalsSql(
            query:
                '''CHECK (created_at >= '2020-01-01'::date AND status IN ('active', 'inactive'))''',
            parameters: {},
          ),
        );
      });

      test('named check constraint', () {
        const constraint =
            CheckConstraint('age > 0', name: 'check_positive_age');
        expect(
          constraint.toSql(),
          equalsSql(
            query: 'CONSTRAINT check_positive_age CHECK (age > 0)',
            parameters: {},
          ),
        );
      });
    });

    group('ForeignKeyTableConstraint', () {
      test('wraps existing ForeignKeyConstraint', () {
        const fkConstraint = ForeignKeyConstraint(
          columns: ['user_id'],
          referencesTable: 'users',
          referencesColumns: ['id'],
        );
        const constraint = ForeignKeyTableConstraint(fkConstraint);
        expect(
          constraint.toSql(),
          equalsSql(
            query: 'FOREIGN KEY (user_id) REFERENCES users (id)',
            parameters: {},
          ),
        );
      });

      test('wraps named ForeignKeyConstraint with cascades', () {
        const fkConstraint = ForeignKeyConstraint(
          name: 'fk_post_user',
          columns: ['user_id'],
          referencesTable: 'users',
          referencesColumns: ['id'],
          onDelete: ReferentialAction.cascade,
          onUpdate: ReferentialAction.setNull,
        );
        const constraint = ForeignKeyTableConstraint(fkConstraint);
        expect(
          constraint.toSql(),
          equalsSql(
            query:
                '''CONSTRAINT fk_post_user FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE ON UPDATE SET NULL''',
            parameters: {},
          ),
        );
      });

      test('non-const constructor covers super call', () {
        const fkConstraint = ForeignKeyConstraint(
          columns: ['user_id'],
          referencesTable: 'users',
          referencesColumns: ['id'],
        );
        const constraint = ForeignKeyTableConstraint(fkConstraint);
        expect(
          constraint.toSql(),
          equalsSql(
            query: 'FOREIGN KEY (user_id) REFERENCES users (id)',
            parameters: {},
          ),
        );
      });
    });

    group('Mixed constraints in CreateTable', () {
      test('table with all constraint types', () {
        final columns = [
          const ColumnDefinition(name: 'id', type: 'SERIAL'),
          const ColumnDefinition(name: 'user_id', type: 'INTEGER'),
          const ColumnDefinition(name: 'tenant_id', type: 'INTEGER'),
          const ColumnDefinition(name: 'email', type: 'TEXT'),
          const ColumnDefinition(name: 'age', type: 'INTEGER'),
          const ColumnDefinition(name: 'created_at', type: 'TIMESTAMP'),
        ];

        const fkConstraint = ForeignKeyConstraint(
          columns: ['user_id'],
          referencesTable: 'users',
          referencesColumns: ['id'],
          onDelete: ReferentialAction.cascade,
        );

        final statement = CreateTable(
          name: 'profiles',
          columns: columns,
          constraints: [
            PrimaryKeyConstraint(['id', 'tenant_id'], name: 'pk_profiles'),
            UniqueConstraint(
              ['email', 'tenant_id'],
              name: 'unique_profile_email',
            ),
            const CheckConstraint('age >= 13', name: 'check_min_age'),
            const ForeignKeyTableConstraint(fkConstraint),
          ],
        );

        expect(
          statement.toSql(),
          equalsSql(
            query:
                '''CREATE TABLE profiles (id SERIAL NOT NULL, user_id INTEGER NOT NULL, tenant_id INTEGER NOT NULL, email TEXT NOT NULL, age INTEGER NOT NULL, created_at TIMESTAMP NOT NULL, CONSTRAINT pk_profiles PRIMARY KEY (id, tenant_id), CONSTRAINT unique_profile_email UNIQUE (email, tenant_id), CONSTRAINT check_min_age CHECK (age >= 13), FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE)''',
            parameters: {},
          ),
        );
      });
    });
  });
}
