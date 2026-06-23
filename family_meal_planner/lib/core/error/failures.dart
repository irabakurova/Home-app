abstract class Failure {
  final String message;
  const Failure(this.message);

  @override
  String toString() => '$runtimeType: $message';
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Ошибка локальной базы данных']);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Нет подключения к интернету']);
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Ошибка сервера']);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Запись не найдена']);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

class InsufficientStockFailure extends Failure {
  final String ingredientName;
  final double available;
  final double required;

  const InsufficientStockFailure({
    required this.ingredientName,
    required this.available,
    required this.required,
  }) : super(
            'Недостаточно "$ingredientName": есть $available, нужно $required');
}

class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Ошибка авторизации']);
}
