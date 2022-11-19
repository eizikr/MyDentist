// import 'package:flutter/material.dart';
// import '../auth.dart';

// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:google_fonts/google_fonts.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({Key? key}) : super(key: key);

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   bool isLoginState = true;
//   late String pass;
//   late String email;
//   final formKey = GlobalKey<FormState>();

//   final TextEditingController _controllerEmail = TextEditingController();
//   final TextEditingController _controllerPassword = TextEditingController();

//   String signInError(String errorCode) {
//     switch (errorCode) {
//       case "user-not-found":
//         {
//           return "Wrong email!";
//         }
//       case "wrong-password":
//         {
//           return "Wrong password!";
//         }
//       case "invalid-email":
//         {
//           return "Invalid email!";
//         }
//       default:
//         {
//           return "General error!";
//         }
//     }
//   }

//   Future<void> signIn() async {
//     try {
//       if (formKey.currentState!.validate()) {
//         await Auth().signIn(
//           email: email,
//           password: pass,
//         );
//       }
//     } on FirebaseAuthException catch (e) {
//       //print(e.code.toString());
//       Fluttertoast.showToast(
//         msg: signInError(e.code.toString()),
//         gravity: ToastGravity.TOP,
//         fontSize: 16.0,
//         webShowClose: true,
//         backgroundColor: Colors.red,
//         toastLength: Toast.LENGTH_LONG,
//         webPosition: "center",
//         webBgColor: "red",
//         timeInSecForIosWeb: 5,
//       );
//     }
//   }

//   // Future<void> signUp() async {
//   //   try {
//   //     await Auth().signUp(
//   //       email: _controllerEmail.text,
//   //       password: _controllerPassword.text,
//   //     );
//   //   } on FirebaseAuthException catch (e) {
//   //     setState(() {
//   //       print("Auth (sign up)  problem: " + e.toString());
//   //     });
//   //   }
//   // }

//   Widget _submitButton() {
//     return SizedBox(
//         width: 365.0,
//         child: RawMaterialButton(
//           fillColor: Colors.lightBlue[200],
//           elevation: 0.0,
//           padding: const EdgeInsets.symmetric(vertical: 20.0),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12.0),
//           ),
//           onPressed: signIn,
//           child: const Text('Login'),
//           // child: Text(isLoginState ? 'Login' : 'Register'),
//         ));
//   }

//   // Widget _loginOrRegisterButton() {
//   //   return TextButton(
//   //     onPressed: () {
//   //       setState(() {
//   //         isLoginState = !isLoginState;
//   //       });
//   //     },
//   //     child: Text(isLoginState ? 'Register instead' : 'Login instead'),
//   //   );
//   // }

//   Widget _entryField(
//     String title,
//     TextEditingController controller,
//     IconData icon,
//   ) {
//     return TextFormField(
//       // controller: controller,
//       onChanged: (inputValue) {
//         title == 'email' ? email = inputValue : pass = inputValue;
//       },
//       decoration: InputDecoration(
//         labelText: title,
//         prefixIcon: Icon(
//           icon,
//           color: Colors.grey,
//         ),
//       ),
//       validator: (val) {
//         if (val == null || val.isEmpty) {
//           return "$title cannot be empty";
//         }
//         return null;
//       },
//       autovalidateMode: AutovalidateMode.onUserInteraction,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Center(
//           child: Form(
//             key: formKey,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   'My Dentist',
//                   style: GoogleFonts.caveat(
//                     fontSize: 75,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 const Text(
//                   'Hey Doctor, Welcome Back!',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 20,
//                   ),
//                 ),
//                 const SizedBox(height: 50),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 25.0),
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: Colors.lightBlue[50],
//                       border: Border.all(color: Colors.white10),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.only(left: 20.0),
//                       child: _entryField(
//                         'email',
//                         _controllerEmail,
//                         Icons.email_outlined,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 25.0),
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: Colors.lightBlue[50],
//                       border: Border.all(color: Colors.white10),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.only(left: 20.0),
//                       child: _entryField(
//                         'password',
//                         _controllerPassword,
//                         Icons.lock_outline,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 _submitButton(),
//                 // Padding(
//                 //   padding: const EdgeInsets.symmetric(horizontal: 25.0),
//                 //   child: Container(
//                 //     padding: const EdgeInsets.all(20),
//                 //     decoration: BoxDecoration(
//                 //       color: Colors.blue[200],
//                 //       borderRadius: BorderRadius.circular(12),
//                 //     ),
//                 //     child: const Center(
//                 //       child: Text(
//                 //         "Sign In",
//                 //         style: TextStyle(color: Colors.white),
//                 //       ),
//                 //     ),
//                 //   ),
//                 // ),
//                 const SizedBox(height: 10),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: const [
//                     Text(
//                       'Dont have a user?',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Text(
//                       ' Register now',
//                       style: TextStyle(
//                         color: Colors.blue,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     )
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
