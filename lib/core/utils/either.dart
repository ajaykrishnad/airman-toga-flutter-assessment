class Either<L, R> {
  final L? _left;
  final R? _right;
  final bool _isLeft;

  const Either._(this._left, this._right, this._isLeft);

  factory Either.left(L value) => Either._(value, null, true);
  factory Either.right(R value) => Either._(null, value, false);

  bool get isLeft => _isLeft;
  bool get isRight => !_isLeft;

  L? get left => _left;
  R? get right => _right;

  T fold<T>(
    T Function(L left) onLeft,
    T Function(R right) onRight,
  ) {
    if (_isLeft) {
      return onLeft(_left as L);
    } else {
      return onRight(_right as R);
    }
  }

  Either<L, R2> map<R2>(R2 Function(R right) fn) {
    if (_isLeft) {
      return Either.left(_left as L);
    } else {
      return Either.right(fn(_right as R));
    }
  }
}
