import 'package:tdd_clean/core/usecase/usecase.dart';
import 'package:tdd_clean/core/utils/typedef.dart';
import 'package:tdd_clean/src/authentication/domain/entities/user.dart';
import 'package:tdd_clean/src/authentication/domain/repositories/authentication_repository.dart';

class GetUsers extends UsecaseWithoutParams<List<User>> {
  final AuthenticationRepository _repository;

  const GetUsers(this._repository);

  @override
  ResultFuture<List<User>> call() async => _repository.getUsers();
}