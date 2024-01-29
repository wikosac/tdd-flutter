import 'package:tdd_clean/core/utils/typedef.dart';

abstract class UsecaseWithParams<Type, Params> {
  ResultFuture<Type> call(Params params);

  const UsecaseWithParams();
}

abstract class UsecaseWithoutParams<Type> {
  ResultFuture<Type> call();

  const UsecaseWithoutParams();
}
