# 🌐 TwitterClon

**TwitterClon** es una aplicación móvil desarrollada con **Flutter** que simula las funciones esenciales de Twitter. Los usuarios pueden publicar mensajes, interactuar con otros (likes y comentarios), seguir o bloquear cuentas, y personalizar su perfil. La app utiliza **Firebase** para la autenticación y el manejo de datos en tiempo real.

---

## ✨ Funcionalidades principales

- 🔐 Registro e inicio de sesión con correo y contraseña  
- 📝 Publicación de mensajes (tweets)  
- 💬 Comentarios en los posts  
- ❤️ Likes en los posts  
- ➕ Seguir y dejar de seguir usuarios  
- 📰 Feed dividido en "Para ti" y "Siguiendo"  
- 👤 Edición de perfil y biografía  
- 🚫 Bloqueo de usuarios  
- ⚠️ Reporte de publicaciones  
- 🗑️ Eliminación de cuenta  
- 📱 Interfaz responsiva, fluida y fácil de usar  

---

## 🛠️ Tecnologías utilizadas

- [Flutter](https://flutter.dev/) – Framework principal para el desarrollo móvil  
- [Dart](https://dart.dev/) – Lenguaje de programación  
- [Firebase Auth](https://firebase.google.com/docs/auth) – Manejo de autenticación de usuarios  
- [Cloud Firestore](https://firebase.google.com/docs/firestore) – Base de datos NoSQL en tiempo real  
- [Provider](https://pub.dev/packages/provider) – Gestión de estado  
- [intl](https://pub.dev/packages/intl) – Formateo de fechas y horas  


## 🗂️ Estructura del proyecto

- `lib/`
  - `pages/` — Pantallas principales (Home, Perfil, etc.)
  - `services/` — Lógica de negocio y acceso a Firebase
  - `models/` — Modelos de datos (User, Post, Comment)
  - `component/` — Widgets reutilizables
  - `helper/` — Utilidades y funciones auxiliares




---

## 🚀 Instalación

1. Clona este repositorio:
   ```sh
   git clone https://github.com/tuusuario/twitterclon.git
   ```

2. Instala las dependencias:
   ```sh
   flutter pub get
   ```

3. Ejecuta la app:
   ```sh
   flutter run
   ```

