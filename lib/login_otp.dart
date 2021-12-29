import 'package:cse_flutter_application/all_libraries.dart';
import 'package:http/http.dart' as http;

class EmailOtp extends StatefulWidget {
  EmailOtp({key}) : super(key: key);

  @override
  _EmailOtpState createState() => _EmailOtpState();
}

class _EmailOtpState extends State<EmailOtp> {
  GlobalKey<FormState> _otpformkey = GlobalKey<FormState>();
  late TextEditingController _otpController = TextEditingController();

  late SharedPreferences logindata;
  late String finalEmail;
  var final_Otp;

  var rand = new Random();
  @override
  void initState() 
  {
  if (!mounted) return;    
  super.initState();
  getEmailforotp();
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
          key: _otpformkey,
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
                          Icons.alternate_email,
                          color: Colors.deepOrange,
                        ),
                        backgroundColor: Colors.white,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Secure OTP",
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
                                    controller: _otpController,
                                    decoration: const InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.email_outlined,
                                        color: Colors.deepOrange,
                                      ),

                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none,
                                      hintText: "Enter 4 Digit OTP",
                                      // alignLabelWithHint: true,
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Enter OTP';
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
                                if (_otpformkey.currentState!.validate()) {
                                  String otp = _otpController.text;

                                  final form = _otpformkey.currentState!;
                                  if (final_Otp == otp) {
                                    _otpformkey.currentState!.save();
                                    final snackBar = SnackBar(
                                        content:
                                            Text('Kindly Update Password.'));
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                    Navigator.pop(context);
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => LoginPass()));
                                  } else {
                                    final snackBar = SnackBar(
                                        content: Text('OTP not matched.'));
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  }

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

  Future<void> getEmailforotp() async {
    logindata = await SharedPreferences.getInstance();
    setState(() {
      finalEmail = logindata.getString('email')!;
      //print("Perfect:  $finalEmail");
      sendemailwithotp();
    });
  }

  Future<void> sendemailwithotp() async {
    var num = rand.nextDouble() * 10000;
    while (num < 1000) {
      num *= 10;
    }
    final_Otp = num.toInt().toString();
    //print(finalEmail);
    final response = await http.get(Uri.parse(APIs.send_mail+finalEmail+"/"+final_Otp));
  }
}
