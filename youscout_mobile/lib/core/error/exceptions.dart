// Data-layer exceptions — thrown by datasources, caught by repository impls
// and converted into Failure types so domain and presentation stay clean.

class NetworkException implements Exception {
  final String message;
  final int? statusCode;
  const NetworkException({this.message = 'Network error', this.statusCode});
}

class UnauthorizedException implements Exception {
  const UnauthorizedException();
}

class NotFoundException implements Exception {
  const NotFoundException();
}

class ServerException implements Exception {
  final String message;
  const ServerException([this.message = 'Server error']);
}
