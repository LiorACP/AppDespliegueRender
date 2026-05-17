import 'package:flutter/material.dart';
import '../user_data.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = UserStore();
    final initials = _initials(store.nombre, store.apellidos);

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
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Column(
                  children: [
                    _buildTopBar(context),
                    const SizedBox(height: 32),
                    _buildAvatar(initials),
                    const SizedBox(height: 16),
                    Text('${store.nombre} ${store.apellidos}',
                        style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    const SizedBox(height: 6),
                    Text(store.email,
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.55))),
                    if (store.bio.isNotEmpty) ...[
                      const SizedBox(height: 14),
                      Text(store.bio,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.65),
                              height: 1.5)),
                    ],
                    const SizedBox(height: 32),
                    _buildInfoCard(store),
                    const SizedBox(height: 24),
                    _buildLogoutBtn(context),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Row(
      children: [
        const Spacer(),
        const Text('Mi Perfil',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white)),
        const Spacer(),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.edit_outlined, color: Colors.white70),
        )
      ],
    );
  }

  Widget _buildAvatar(String initials) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF6C63FF), Color(0xFFB06AB3)],
            ),
            boxShadow: [
              BoxShadow(
                  color: const Color(0xFF6C63FF).withOpacity(0.5),
                  blurRadius: 24,
                  spreadRadius: 4)
            ],
          ),
          child: Center(
            child: Text(initials,
                style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
          ),
        ),
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF302B63),
            border: Border.all(color: Colors.white12, width: 1.5),
          ),
          child: const Icon(Icons.camera_alt_outlined,
              size: 14, color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildInfoCard(UserStore store) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel('Información personal'),
          const SizedBox(height: 16),
          _infoRow(Icons.person_outline, 'Nombre completo',
              '${store.nombre} ${store.apellidos}'),
          _divider(),
          _infoRow(Icons.email_outlined, 'Email', store.email),
          if (store.telefono.isNotEmpty) ...[
            _divider(),
            _infoRow(Icons.phone_outlined, 'Teléfono', store.telefono),
          ],
          if (store.fechaNacimiento.isNotEmpty) ...[
            _divider(),
            _infoRow(Icons.cake_outlined, 'Fecha de nacimiento',
                store.fechaNacimiento),
          ],
        ],
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
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(text,
            style: const TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w600,
                fontSize: 13,
                letterSpacing: 0.4)),
      ],
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFF6C63FF).withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFF6C63FF), size: 19),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(
                        fontSize: 11,
                        color: Colors.white.withOpacity(0.45),
                        letterSpacing: 0.3)),
                const SizedBox(height: 2),
                Text(value,
                    style: const TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _divider() {
    return Divider(
        color: Colors.white.withOpacity(0.08), height: 1, thickness: 1);
  }

  Widget _buildLogoutBtn(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton.icon(
        onPressed: () {
          UserStore().clear();
          Navigator.pushReplacementNamed(context, '/login');
        },
        icon: const Icon(Icons.logout_rounded,
            color: Colors.redAccent, size: 20),
        label: const Text('Cerrar sesión',
            style: TextStyle(color: Colors.redAccent, fontSize: 15)),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.redAccent.withOpacity(0.5)),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }

  String _initials(String nombre, String apellidos) {
    final n = nombre.isNotEmpty ? nombre[0].toUpperCase() : '';
    final a = apellidos.isNotEmpty ? apellidos[0].toUpperCase() : '';
    return '$n$a';
  }
}
