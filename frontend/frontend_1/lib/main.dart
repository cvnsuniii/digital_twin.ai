import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'planning.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Accenture model 1'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    final LocalAuthentication auth = LocalAuthentication();
    Future<void> Auth() async {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text,
        );

        // Login successful
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );

      } on FirebaseAuthException catch (e) {
        print(e.code);
      }
    }
    Future<void> authenticate() async {
      try {
        bool authenticated = await auth.authenticate(
          localizedReason: 'Use your fingerprint to sign in',
          options: const AuthenticationOptions(
            biometricOnly: true,
            stickyAuth: true,
          ),
        );

        if (authenticated) {
          print("Authentication successful");

          // Navigate to your home page
          // Navigator.push(...);
        }
      } catch (e) {
        print("Authentication error: $e");
      }
    }
    return Scaffold(
      appBar: AppBar(
        leading:Image(image:AssetImage("assets/images/acc1.png")),
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child:Container(
          width:350,height:400,padding:EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                blurRadius: 10,
                color: Colors.grey.withValues(alpha:0.3),
              ),
            ],
          ),
          child:Column(
            spacing:8,
            children:[
              Text("Credentials",style:TextStyle(fontSize:20)),
              TextField(
                decoration: InputDecoration(
                  labelText: "User id",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "passcode",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              TextButton(onPressed:authenticate,child:Text("sign in using passkey",style:TextStyle(color:Colors.blue,decoration: TextDecoration.underline,))),
              FloatingActionButton(onPressed:(){Navigator.push(context,MaterialPageRoute(builder: (context) => const Planning() ,))} ,child:Text("Login"))
            ]
          )
          
        )
      ),
      
    );
  }
}
