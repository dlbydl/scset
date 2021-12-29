import 'package:cse_flutter_application/all_libraries.dart';
import 'package:http/http.dart' as http;

class LoginPass extends StatefulWidget {
  LoginPass({Key? key}) : super(key: key);

  @override
  _LoginPassState createState() => _LoginPassState();
}

class _LoginPassState extends State<LoginPass> {
  final GlobalKey<FormState> _userformkey = GlobalKey<FormState>();
  late TextEditingController _newPasswordController = TextEditingController();
  late TextEditingController _cnfPasswordController = TextEditingController();

  final numericRegex = RegExp(r'[0-9]');
  final specialRegex = RegExp(r'[!@#$%^&*(),.?":{}|<>]');

  late SharedPreferences logindata;
  late String email;

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
                                    controller: _newPasswordController,
                                    obscureText: true,
                                    decoration: const InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.email_outlined,
                                        color: Colors.deepOrange,
                                      ),
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none,
                                      hintText: "New Password",
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Enter Password';
                                      } else if (value.length < 8) {
                                        return "Enter atleast 8 characters";
                                      } else if (!(numericRegex
                                              .hasMatch(value)) &&
                                          (!(specialRegex.hasMatch(value)))) {
                                        return "Enter valid password";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
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
                                    controller: _cnfPasswordController,
                                    obscureText: true,
                                    decoration: const InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.email_outlined,
                                        color: Colors.deepOrange,
                                      ),
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none,
                                      hintText: "Confirm New Password",
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Enter Password';
                                      }
                                      if (_newPasswordController.text !=
                                          _cnfPasswordController.text) {
                                        return "Password does not match";
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
                                  final_pass = _newPasswordController.text;
                                  resetpass(final_pass, email);
                                  _userformkey.currentState!.save();
                                  clearSharedPrefs();
                                  final snackBar = SnackBar(
                                      content: Text(
                                          'Password Successfully Updated. LOGIN AGAIN'));
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                  Navigator.pop(context);
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => LoginPage1()));
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

  void initial() async {
    logindata = await SharedPreferences.getInstance();
    setState(() {
      email = logindata.getString('email')!;
      //print("Perfect:  $email");
    });
  }

  Future<void> resetpass(String final_pass, String email) async 
  {
    final response = await http.get( Uri.parse(APIs.up_login+email+"/"+final_pass)); 
  }

  Future<void> clearSharedPrefs() async {
    await logindata.clear();
    //print("SP Check: $sp_check");
  }
}
