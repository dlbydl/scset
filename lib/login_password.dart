import 'package:cse_flutter_application/all_libraries.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _userformkey = GlobalKey<FormState>();
  late TextEditingController _passwordController = TextEditingController();

  late SharedPreferences logindata;

  late String final_pass;
  @override
  void initState() 
  {
    if (!mounted) return;
    super.initState();
    initial();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, colors: [
          Colors.orange.shade900,
          Colors.orange.shade800,
          Colors.orange.shade400
        ])),
        child: Form(
          key: _userformkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: 80,
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const <Widget>[
                      Text(
                        "SCSET@BU",
                        style: TextStyle(color: Colors.white, fontSize: 40),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CircleAvatar(
                        child: Icon(
                          Icons.verified_user,
                          color: Colors.deepOrange,
                        ),
                        backgroundColor: Colors.white,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Login",
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(60),
                          topRight: Radius.circular(60))),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: Column(
                        children: <Widget>[
                          const SizedBox(
                            height: 60,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Color.fromRGBO(225, 95, 27, .3),
                                      blurRadius: 20,
                                      offset: Offset(0, 10))
                                ]),
                            child: Column(
                              children: <Widget>[
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey.shade200))),
                                  child: TextFormField(
                                    controller: _passwordController,
                                    obscureText: true,
                                    decoration: const InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.lock,
                                        color: Colors.deepOrange,
                                      ),
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none,
                                      hintText: "Enter Password",
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Enter Password';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          SizedBox(
                            width: 200,
                            height: 50,
                            child: ElevatedButton(
                              child: Text("Submit"),
                              style: ElevatedButton.styleFrom(
                                onPrimary: Colors.white,
                                primary: Colors.orange.shade900,
                                elevation: 20,
                                minimumSize: Size(150, 50),
                                shadowColor: Colors.grey,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(32)),
                              ),
                              onPressed: () async {
                                if (_userformkey.currentState!.validate()) {
                                  String pwd = _passwordController.text;

                                  final form = _userformkey.currentState!;
                                  if (final_pass == pwd) {
                                    _userformkey.currentState!.save();
                                    logindata.setBool("loggedin", true);
                                    Navigator.pop(context);
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => HomePage()));
                                  }else{
                                    final snackBar = SnackBar(
                                      content: Text('Wrong Password!!'));
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                  
                                  }
                                  //print("successful");

                                  return;
                                } else {
                                  //print("UnSuccessfull");
                                }
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          TextButton(
                            child: const Text('Forget Password',style:TextStyle(color:Colors.deepOrange)),
                            onPressed: () {
                              //user with NULL password msg+rediect to OTP PAGE
                              final snackBar = SnackBar(content: Text('OTP sent on your E-mail! Have Patience ! Check Spam/Junk folder as well !!'));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                              Navigator.pop(context);
                              Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => EmailOtp()));
                            },
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> initial() async {
    logindata = await SharedPreferences.getInstance();
    setState(() {
      final_pass = logindata.getString('pass')!;
      //print("Perfect:  $final_pass");
    });
  }
}
