import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_clean/core/errors/failure.dart';
import 'package:tdd_clean/src/authentication/domain/usecases/create_user.dart';
import 'package:tdd_clean/src/authentication/domain/usecases/get_users.dart';
import 'package:tdd_clean/src/authentication/presentation/cubit/authentication_cubit.dart';

class MockCreateUser extends Mock implements CreateUser {}

class MockGetUsers extends Mock implements GetUsers {}

void main() {
  late CreateUser createUser;
  late GetUsers getUsers;
  late AuthenticationCubit cubit;

  const tCreateUserParams = CreateUserParams.empty();
  const tAPIFailure = APIFailure(message: 'message', statusCode: 400);

  setUp(() {
    createUser = MockCreateUser();
    getUsers = MockGetUsers();
    cubit = AuthenticationCubit(createUser: createUser, getUsers: getUsers);
    registerFallbackValue(tCreateUserParams);
  });

  tearDown(() => cubit.close());

  test('initial state should be AuthenticationInitial', () async {
    expect(cubit.state, const AuthenticationInitial());
  });

  group('createUser', () {
    blocTest<AuthenticationCubit, AuthenticationState>(
      'should emit [CreatingUser, UserCreated] when successful',
      build: () {
        when(() => createUser(any()))
            .thenAnswer((_) async => const Right(null));
        return cubit;
      },
      act: (cubit) {
        cubit.createUser(
          createdAt: tCreateUserParams.createdAt,
          name: tCreateUserParams.name,
          avatar: tCreateUserParams.avatar,
        );
      },
      expect: () => const [
        CreatingUser(),
        UserCreated(),
      ],
      verify: (_) {
        verify(() => createUser(tCreateUserParams));
        verifyNoMoreInteractions(createUser);
      }
    );

    blocTest<AuthenticationCubit, AuthenticationState>(
        'should emit [CreatingUser, AuthenticationError] when unsuccessful',
        build: () {
          when(() => createUser(any()))
              .thenAnswer((_) async => const Left(tAPIFailure));
          return cubit;
        },
        act: (cubit) {
          cubit.createUser(
            createdAt: tCreateUserParams.createdAt,
            name: tCreateUserParams.name,
            avatar: tCreateUserParams.avatar,
          );
        },
        expect: () => [
          const CreatingUser(),
          AuthenticationError(tAPIFailure.errorMessage),
        ],
        verify: (_) {
          verify(() => createUser(tCreateUserParams));
          verifyNoMoreInteractions(createUser);
        }
    );
  });

  group('getUsers', () {
    blocTest<AuthenticationCubit, AuthenticationState>(
        'should emit [GettingUsers, UsersLoaded] when successful',
        build: () {
          when(() => getUsers()).thenAnswer((_) async => const Right([]));
          return cubit;
        },
        act: (cubit) {
          cubit.getUsers();
        },
        expect: () => const [
          GettingUsers(),
          UserLoaded([]),
        ],
        verify: (_) {
          verify(() => getUsers()).called(1);
          verifyNoMoreInteractions(getUsers);
        }
    );
  });

  blocTest<AuthenticationCubit, AuthenticationState>(
      'should emit [GettingUsers, AuthenticationError] when unsuccessful',
      build: () {
        when(() => getUsers()).thenAnswer((_) async => const Left(tAPIFailure));
        return cubit;
      },
      act: (cubit) {
        cubit.getUsers();
      },
      expect: () => [
        const GettingUsers(),
        AuthenticationError(tAPIFailure.errorMessage),
      ],
      verify: (_) {
        verify(() => getUsers()).called(1);
        verifyNoMoreInteractions(getUsers);
      }
  );
}
