# Mi App Perfil – Flutter Web

App con **Login**, **Registro** y **Perfil de usuario**, lista para desplegar en Render, Vercel, Coolify o Docploy.

## Pantallas

| Pantalla | Descripción |
|----------|-------------|
| `/login` | Inicio de sesión con email y contraseña |
| `/register` | Registro con nombre, apellidos, email, teléfono, fecha de nacimiento y bio |
| `/profile` | Perfil con todos los datos introducidos en el registro |

## Desarrollo local

```bash
# 1. Instalar dependencias
flutter pub get

# 2. Ejecutar en Chrome
flutter run -d chrome

# 3. Compilar para web
flutter build web --release
```

## Despliegue en Render (recomendado – plan gratuito)

1. Sube el proyecto a GitHub
2. Ve a https://render.com → New → Static Site
3. Conecta el repositorio
4. Configura:
   - **Build Command:**
     ```
     git clone https://github.com/flutter/flutter.git --depth 1 -b stable /opt/flutter && export PATH="$PATH:/opt/flutter/bin" && flutter config --enable-web && flutter pub get && flutter build web --release
     ```
   - **Publish directory:** `build/web`
5. Pulsa **Create Static Site**

## Despliegue en Vercel

```bash
npm i -g vercel
flutter build web --release
cd build/web
vercel --prod
```

## Notas

- Los datos del usuario se guardan **en memoria** durante la sesión.  
  Para persistencia real, sustituye `UserStore` por `SharedPreferences` o un backend.
- El plan gratuito de Render tiene arranque en frío (~30-60 s si lleva inactivo).
