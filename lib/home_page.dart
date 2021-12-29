import 'package:cse_flutter_application/all_libraries.dart';

class HomePage extends StatefulWidget {
  const HomePage({key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late SharedPreferences logindata;
  String email="";
  String role="";
  bool loggedin=false;

  @override
  void initState() 
  {
    if (!mounted) return;
    super.initState();
    initial();
  }

  @override
	void dispose() {		super.dispose(); }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text("Home Page"),
      ),
      drawer: MyDrawer(),
      body: Center(
        child: Text("SCSET",style: TextStyle(color:Colors.deepOrange,fontWeight: FontWeight.bold,fontSize:64))
      ),
    );
  }

  Future<void> initial() async {
    logindata = await SharedPreferences.getInstance();
    loggedin= logindata.getBool('loggedin') ?? false;
    if (loggedin == false)
    { 
      await logindata.clear();
      Navigator.pop(context);
      Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => LoginPage1()));
    }
    logindata.setBool('pref_given',false);
  }
}
