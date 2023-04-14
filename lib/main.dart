import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:privatenotes/views/login_view.dart';
import 'package:privatenotes/views/register_view.dart';
import 'package:privatenotes/views/verify_email_view.dart';
import 'dart:developer' as devtools show log;

import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: const HomePage(),
    routes: {
      '/login/': (context) => const LoginView(),
      '/register/': (context) => const RegisterView(),
      '/notes/': (context) => const NoteView(),
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;
            final emailVerified = user?.emailVerified ?? false;
            if (user == null) {
              return const LoginView();
            } else {
              if (emailVerified) {
                return const NoteView();
              } else {
                return const VerifyEmailView();
              }
            }
          default:
            return const CircularProgressIndicator();
        }
      },
    ));
  }
}

enum MenuOptions { logout }

class NoteView extends StatefulWidget {
  const NoteView({super.key});

  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notes'), actions: [
        PopupMenuButton<MenuOptions>(
          onSelected: (option) async {
            devtools.log(option.toString());
            switch (option) {
              case MenuOptions.logout:
                final showDialog = await showLogOutDialog(context);
                if (showDialog) {
                  await FirebaseAuth.instance.signOut();
                }
                break;
            }
          },
          itemBuilder: (context) {
            return const [
              PopupMenuItem(
                value: MenuOptions.logout,
                child: Text('Logout'),
              ),
            ];
          },
        ),
      ]),
      body: const Text('Notes'),
    );
  }
}

Future<bool> showLogOutDialog(BuildContext context) async {
  return await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('Yes'),
          ),
        ],
      );
    },
  ).then((value) => value ?? false);
}
