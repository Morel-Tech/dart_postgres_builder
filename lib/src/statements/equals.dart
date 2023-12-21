import 'package:postgres_builder/src/statements/operator_comparison.dart';

class Equals extends OperatorComparision {
  const Equals(super.column, super.value)
      : super(operator: '=', columnFirst: false);
  const Equals.otherColumn(
    super.column1,
    super.column2,
  ) : super.otherColumn(operator: '=');
}
