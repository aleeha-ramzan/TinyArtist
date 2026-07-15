import 'package:flutter/material.dart';
import 'package:itry/user_data.dart';
import 'splash_screen.dart';
void main() async {
  //WidgetsFlutterBinding.ensureInitialized();
 // await UserData.loadUsers();
  runApp(const TinyArtist());
}

class TinyArtist extends StatelessWidget {
  const TinyArtist({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
