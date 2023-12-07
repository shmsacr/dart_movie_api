typedef FactoryType = Map<dynamic, Function>;
typedef RepositoryType = Map<dynamic, dynamic>;

class Provider {
  final FactoryType _factories = {};
  final RepositoryType _repository = {};

  /// Unique instance of Provider
  Provider._sharedInstance();
  static final Provider _instance = Provider._sharedInstance();
  static Provider get of => _instance;

  register(name, object) => _factories[name] = object;
  _add(name) => _repository[name] = _factories[name]!();
  T fetch<T>() => _repository.containsKey(T) ? _repository[T] : _add(T);
}
