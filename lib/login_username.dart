import 'package:cse_flutter_application/all_libraries.dart';
import 'package:http/http.dart' as http;

class LoginPage1 extends StatefulWidget {
  const LoginPage1({key}) : super(key: key);

  @override
  _LoginPage1State createState() => _LoginPage1State();
}

class _LoginPage1State extends State<LoginPage1> {
  var finalrole="";
  var finalpass="";
  List loginList = [];
  List<String> username = [];
  List role = [];
  List pass = [];
  final GlobalKey<FormState> _userformkey = GlobalKey<FormState>();
  late TextEditingController editingController_user = TextEditingController();

  late SharedPreferences logindata;
  bool loggedin=false;

  @override
  void initState() 
  {
  if (!mounted) return;
  super.initState();
  _getuserinfo();
  }

  @override
	void dispose() {		super.dispose(); }

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
                                    controller: editingController_user,
                                    decoration: const InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.email_outlined,
                                        color: Colors.deepOrange,
                                      ),

                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none,
                                      hintText: "User Name",
                                      // alignLabelWithHint: true,
                                      suffix: Text('@bennett.edu.in'),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Enter User Name ';
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
                                  String finalusername =
                                      editingController_user.text;
                                  finalusername =
                                      finalusername + "@bennett.edu.in";
                                  var checkuser = checkUser(finalusername);

                                  var arr = checkuser.split("-");

                                  var ustatus = arr[0];
                                  var uname = arr[1];
                                  var urole = arr[2];
                                  var upass = arr[3];
                                 // print("Status: $ustatus \n Name: $uname \n Role: $urole \n Password: $upass");
                                  //Checking User Name Exist or not through Status(0/1)

                                  //if user exist 1
                                  if (int.parse(ustatus) == 1) {
                                    // print("User Found");
                                    createSharedPrefer(uname, urole, upass);
                                    //user found but NULL password
                                    if ((int.parse(ustatus) == 1 &&
                                        upass == 'NULL')) {
                                      //print("User Found But Pass==> NULL");
                                      _userformkey.currentState!.save();

                                      //user with NULL password msg+rediect to OTP PAGE
                                      final snackBar = SnackBar(
                                          content:
                                              Text('OTP sent on your E-mail! Have Patience ! Check Spam/Junk folder as well !!'));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                      Navigator.pop(context);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EmailOtp()));
                                    } else {
                                      //print("User Found with Password: $upass");
                                      _userformkey.currentState!.save();
                                      Navigator.pop(context);
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LoginPage()));
                                    }
                                  } else if (int.parse(ustatus) == 0) {
                                    //if user not exist 0
                                    final snackBar = SnackBar(
                                        content: Text('User Not Found.'));

// Find the ScaffoldMessenger in the widget tree
// and use it to show a SnackBar.
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                    //print("User Not Found");
                                  }
                                  _userformkey.currentState!.reset();

                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) => LoginPage2()));
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

  Future _getuserinfo() async {
    logindata = await SharedPreferences.getInstance();
    loggedin = logindata.getBool('loggedin') ?? false;
    if (loggedin == true)
    { 
      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => HomePage()));
    }
    else{
    final response = await http.get(Uri.parse(APIs.api_login));
    final items = json.decode(response.body).cast<Map<String, dynamic>>();
    if(mounted) {setState(() { loginList = items; });}    // print(items);

    for (var rb in loginList) {
      username.add(rb['user_name']);
      role.add(rb['role']);
      pass.add(rb['password']);
    }
    }
  }

  checkUser(String finalusername) {
    var status = 0;
    finalrole = '';
    finalpass = '';
    for (var i = 0; i < username.length; i++) {
      if (username[i] == finalusername) {
        finalrole = role[i];
        finalpass = pass[i];
        status = 1;
        //print( "Email_id: $finalusername \n Role: $finalrole \n Password: $finalpass");
      }
    }
    return "$status-$finalusername-$finalrole-$finalpass";
  }

  Future<void> createSharedPrefer(uname, urole, upass) async {
    logindata = await SharedPreferences.getInstance();
    logindata.setString('email', uname);
    logindata.setString("role", urole);
    logindata.setString("pass", upass);
    logindata.setBool("loggedin", false);
    logindata.setBool("shared_pref", true);
    var s = logindata.getString('email').toString();
    //print("SP: $s");
  }
}
