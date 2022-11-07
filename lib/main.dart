import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_dentist/profile_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<FirebaseApp> _initializeFirebase() async{
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  FutureBuilder(
        future: _initializeFirebase(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done){
            return LoginScreen();
          }
          return const Center(child: CircularProgressIndicator(),
          );
        },
        ),       
      );
  }
}


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  static Future<User?> loginUsingEmailPassword({required String email,required String password,required BuildContext context}) async{
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try{
      UserCredential userCredential = await auth.signInWithEmailAndPassword(email: email, password: password);
      user = userCredential.user;
    } on FirebaseAuthException catch (e){
      if(e.code=="user-not-found"){
        print("No User found for that email");
      }
    }
    return user;
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           const Text("My Dentist",
          style: TextStyle(
            color: Colors.black,
            fontSize: 44.0,
            fontWeight: FontWeight.bold,
            )
          ),
          const Text("login to your account",
            style: TextStyle(
              color: Colors.black,
              fontSize: 28.0,
              fontWeight: FontWeight.bold,
            )
          ),
          const SizedBox(
            height: 44.0,
          ),
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: "enter your email",
              prefixIcon: Icon(Icons.mail,color: Colors.grey,)
            ),
          ),
          const SizedBox(height: 26.0,),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              hintText: "enter your password",
              prefixIcon: Icon(Icons.lock,color: Colors.grey,)
            ),
          ),
          const SizedBox(
            height: 12.0,
          ),
          const Text("forgot your passwors?",
            style: TextStyle(
              color: Colors.blue,
            )
          ),
          const SizedBox(
            height: 88.0,
          ),
          Container(
            width: double.infinity,
            child: RawMaterialButton(
              fillColor: Colors.blue,
              elevation: 0.0,
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
              onPressed: () async{
              //   User? user = await loginUsingEmailPassword(email: _emailController.text, password: _passwordController.text, context: context);
              //   if (user != null){
              //     Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> ProfileScreen()));
              //   }
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()),
);
              },
              child: const Text("Login",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
              ),),
              ),
          )
      ],
    ),
    );
  }
}