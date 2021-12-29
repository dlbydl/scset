import 'package:cse_flutter_application/all_libraries.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'CSE AUTOMATION',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Montserrat',
          primarySwatch: Colors.deepOrange,
        ),
        
        home: AnimatedSplashScreen(
            duration: 1500,
            splash: const Padding(
              padding: EdgeInsets.all(0.8),
              child: Text("SCSET",
                  style: TextStyle(
                      fontSize: 60,
                      fontWeight: FontWeight.w800,
                      color: Colors.white)),
            ),
            nextScreen: LoginPage1(),
            splashTransition: SplashTransition.fadeTransition,
            backgroundColor: Colors.deepOrangeAccent),
            );
  }
}
