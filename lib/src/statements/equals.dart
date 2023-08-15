import 'package:postgres_builder/src/statements/operator_comparison.dart';

class Equals extends OperatorComparision {
  Equals(super.column, super.value) : super(operator: '=');
  Equals.otherColumn(
    super.column1,
    super.column2,
  ) : super.otherColumn(operator: '=');
}
