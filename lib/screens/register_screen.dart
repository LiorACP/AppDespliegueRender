import 'package:flutter/material.dart';
import '../user_data.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nombreCtrl = TextEditingController();
  final _apellidosCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _telefonoCtrl = TextEditingController();
  final _fechaCtrl = TextEditingController();
  final _bioCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _pass2Ctrl = TextEditingController();
  bool _obscure1 = true;
  bool _obscure2 = true;
  bool _loading = false;
  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    for (final c in [
      _nombreCtrl, _apellidosCtrl, _emailCtrl, _telefonoCtrl,
      _fechaCtrl, _bioCtrl, _passCtrl, _pass2Ctrl
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 700));

    final store = UserStore();
    store.nombre = _nombreCtrl.text.trim();
    store.apellidos = _apellidosCtrl.text.trim();
    store.email = _emailCtrl.text.trim();
    store.telefono = _telefonoCtrl.text.trim();
    store.fechaNacimiento = _fechaCtrl.text.trim();
    store.bio = _bioCtrl.text.trim();
    store.password = _passCtrl.text;

    setState(() => _loading = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('¡Cuenta creada! Inicia sesión.'),
          backgroundColor: const Color(0xFF6C63FF),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1940),
      lastDate: now,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF6C63FF),
            surface: Color(0xFF302B63),
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      _fechaCtrl.text =
          '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0F0C29), Color(0xFF302B63), Color(0xFF24243e)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
              child: FadeTransition(
                opacity: _fadeAnim,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: Column(
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 28),
                      _buildCard(),
                      const SizedBox(height: 20),
                      _buildLoginLink(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 68,
          height: 68,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xFFB06AB3), Color(0xFF6C63FF)],
            ),
            boxShadow: [
              BoxShadow(
                  color: const Color(0xFFB06AB3).withOpacity(0.5),
                  blurRadius: 20,
                  spreadRadius: 4)
            ],
          ),
          child:
              const Icon(Icons.person_add_rounded, color: Colors.white, size: 34),
        ),
        const SizedBox(height: 14),
        const Text('Crear cuenta',
            style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        const SizedBox(height: 6),
        Text('Rellena tus datos para registrarte',
            style:
                TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.55))),
      ],
    );
  }

  Widget _buildCard() {
    return Container(
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 30,
              offset: const Offset(0, 10))
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _sectionLabel('Datos personales'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                    child: _field(_nombreCtrl, 'Nombre', Icons.badge_outlined,
                        validator: _required)),
                const SizedBox(width: 12),
                Expanded(
                    child: _field(_apellidosCtrl, 'Apellidos',
                        Icons.badge_outlined,
                        validator: _required)),
              ],
            ),
            const SizedBox(height: 14),
            _field(_emailCtrl, 'Email', Icons.email_outlined,
                keyboard: TextInputType.emailAddress,
                validator: (v) {
              if (v == null || v.isEmpty) return 'Requerido';
              if (!v.contains('@')) return 'Email no válido';
              return null;
            }),
            const SizedBox(height: 14),
            _field(_telefonoCtrl, 'Teléfono', Icons.phone_outlined,
                keyboard: TextInputType.phone),
            const SizedBox(height: 14),
            GestureDetector(
              onTap: _pickDate,
              child: AbsorbPointer(
                child: _field(
                    _fechaCtrl, 'Fecha de nacimiento', Icons.cake_outlined),
              ),
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _bioCtrl,
              maxLines: 3,
              style: const TextStyle(color: Colors.white),
              decoration: _inputDeco('Bio / Descripción', Icons.edit_note_rounded),
            ),
            const SizedBox(height: 22),
            _sectionLabel('Seguridad'),
            const SizedBox(height: 12),
            _field(_passCtrl, 'Contraseña', Icons.lock_outline_rounded,
                obscure: _obscure1,
                suffix: _eyeBtn(
                    _obscure1, () => setState(() => _obscure1 = !_obscure1)),
                validator: (v) {
              if (v == null || v.length < 6)
                return 'Mínimo 6 caracteres';
              return null;
            }),
            const SizedBox(height: 14),
            _field(_pass2Ctrl, 'Repetir contraseña',
                Icons.lock_outline_rounded,
                obscure: _obscure2,
                suffix: _eyeBtn(
                    _obscure2, () => setState(() => _obscure2 = !_obscure2)),
                validator: (v) {
              if (v != _passCtrl.text) return 'Las contraseñas no coinciden';
              return null;
            }),
            const SizedBox(height: 26),
            _buildButton(),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Row(
      children: [
        Container(
            width: 3,
            height: 16,
            decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [Color(0xFF6C63FF), Color(0xFFB06AB3)]),
                borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 8),
        Text(text,
            style: const TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w600,
                fontSize: 13,
                letterSpacing: 0.5)),
      ],
    );
  }

  InputDecoration _inputDeco(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 13),
      prefixIcon: Icon(icon, color: const Color(0xFF6C63FF), size: 20),
      filled: true,
      fillColor: Colors.white.withOpacity(0.07),
      border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF6C63FF), width: 1.5),
      ),
      errorStyle: const TextStyle(color: Colors.redAccent, fontSize: 11),
    );
  }

  Widget _field(
    TextEditingController ctrl,
    String label,
    IconData icon, {
    TextInputType? keyboard,
    bool obscure = false,
    Widget? suffix,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: ctrl,
      obscureText: obscure,
      keyboardType: keyboard,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      validator: validator,
      decoration: _inputDeco(label, icon).copyWith(suffixIcon: suffix),
    );
  }

  Widget _eyeBtn(bool hidden, VoidCallback onTap) {
    return IconButton(
      icon: Icon(hidden ? Icons.visibility_off : Icons.visibility,
          color: Colors.white38, size: 19),
      onPressed: onTap,
    );
  }

  String? _required(String? v) =>
      (v == null || v.isEmpty) ? 'Requerido' : null;

  Widget _buildButton() {
    return SizedBox(
      height: 52,
      child: ElevatedButton(
        onPressed: _loading ? null : _register,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 0,
        ).copyWith(backgroundColor: WidgetStateProperty.all(Colors.transparent)),
        child: Ink(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
                colors: [Color(0xFFB06AB3), Color(0xFF6C63FF)]),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(
            child: _loading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2.5))
                : const Text('Crear cuenta',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white)),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('¿Ya tienes cuenta? ',
            style: TextStyle(color: Colors.white.withOpacity(0.5))),
        GestureDetector(
          onTap: () => Navigator.pushReplacementNamed(context, '/login'),
          child: const Text('Inicia sesión',
              style: TextStyle(
                  color: Color(0xFF6C63FF), fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }
}
