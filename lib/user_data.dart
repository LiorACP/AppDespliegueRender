/// Almacén en memoria para los datos del usuario registrado.
/// En una app real usarías SharedPreferences o una base de datos.
class UserStore {
  static final UserStore _instance = UserStore._internal();
  factory UserStore() => _instance;
  UserStore._internal();

  String nombre = '';
  String apellidos = '';
  String email = '';
  String telefono = '';
  String fechaNacimiento = '';
  String bio = '';
  String password = '';

  bool get isRegistered => email.isNotEmpty;

  void clear() {
    nombre = '';
    apellidos = '';
    email = '';
    telefono = '';
    fechaNacimiento = '';
    bio = '';
    password = '';
  }
}
