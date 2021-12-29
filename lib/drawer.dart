import 'package:cse_flutter_application/all_libraries.dart';
import 'package:http/http.dart' as http;

class MyDrawer extends StatefulWidget {
  const MyDrawer({key}) : super(key: key);

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  late SharedPreferences logindata;
  String email="";
  String role="";
  bool loggedin=false;
  late var program="";
  late var sem="";
  late var c1="";
  late var c2="";
  late var c3="";
  late var c4="";
 // bool pref_given=true;


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
    return Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: Colors.deepOrange),
            accountName: (role=="STUDENT")? Text("STUDENT"):(role=="STAFF")?Text("STAFF"):Text("PHD STUDENT"),
            accountEmail: Text(email),
            /*currentAccountPicture: CircleAvatar(
              child: Text('SCSET'),
              backgroundColor: Colors.deepOrange,
            ), */
            currentAccountPicture: CircleAvatar(
              child: Text('SCSET',style: TextStyle(color: Colors.deepOrange),
              ),
              backgroundColor: Colors.white,
            ),
          ),

          //STUDENT MENU
          if(role=="STUDENT") 
          Column(children:[
            ListTile(
             leading: Icon(Icons.home, color: Colors.deepOrange,),
             title: Text('Home Page', style: TextStyle(color: Colors.deepOrange),),
             onTap: () {Navigator.pop(context);Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage(), )); },
             selected: true,
           ),
           
           //if((program=="B.Tech" && sem=="5"))
           if((program=="B.Tech" && sem=="5") || (program=="BCA" && sem=="3"))
           if(logindata.getBool('pref_given')==false)
           ListTile(
             leading: Icon(Icons.room_preferences),
             title: Text('Elective Preferences',),
             onTap: () {Navigator.pop(context);Navigator.of(context).push(MaterialPageRoute(builder: (context) => StudentElectivePreferences(), )); },
             //selected: true,
           ),
           //if((program=="B.Tech" && sem=="5"))
           if((program=="B.Tech" && sem=="5") || (program=="BCA" && sem=="3"))
           if(logindata.getBool('pref_given')==true)
           ListTile(
             leading: Icon(Icons.room_preferences),
             title: Text('Elective Preferences',),
             onTap: () {
               //Timer(Duration(seconds: 2), ()
               //{
                 Navigator.pop(context);
                 Navigator.of(context).push(MaterialPageRoute(builder: (context) => 
             GivenElectivePreferences(coursecode1: c1,coursecode2: c2,coursecode3: c3,coursecode4: c4), 
               )); 
               //});
             },
             //selected: true,
           ),
          //  ListTile(
          //    leading: Icon(Icons.book),
          //    title: Text('Room Booking',),
          //    onTap: () {Navigator.pop(context);Navigator.of(context).push(MaterialPageRoute(builder: (context) => 
          //    GivenElectivePreferences(
          //       coursecode1: "BTECH007",
          //       coursecode2: "BTECH001",
          //       coursecode3: "BTECH003",
          //       coursecode4: "BTECH004",
          //    ),)); },
          //    //selected: true,
          //  ),
          //ListTile(
          //  leading: Icon(Icons.feedback),
          // title: Text('CLO Feedback',),
          //   onTap: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => Clocourse(),)); },
          //   selected: true,
          // ),
          // ListTile(
          //   leading: Icon(Icons.feedback),
          //   title: Text('Mentor Feedback',),
          //   onTap: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage(),)); },
          //   //selected: true,
          // ),
          ])
          



          //STAFF  MENU
          else if(role=="STAFF") 
          Column(children:[
            ListTile(
             leading: Icon(Icons.home),
             title: Text('Home Page',),
             onTap: () {Navigator.pop(context);Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage(), )); },
             selected: true,
           ),
           ListTile(
             leading: Icon(Icons.book),
             title: Text('Room Booking',),
             onTap: () {Navigator.pop(context);Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage(), )); },
             //selected: true,
           ),
           ListTile(
             leading: Icon(Icons.recommend),
             title: Text('Recommend Book',),
             onTap: () {Navigator.pop(context);Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage(),)); },
             //selected: true,
           ),
          ])




          //PHD  MENU
          else if(role=="PHD") 
          Column(children:[
            ListTile(
             leading: Icon(Icons.home),
             title: Text('Home Page',),
             onTap: () {Navigator.pop(context);Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage(), )); },
             selected: true,
           ),
           ListTile(
             leading: Icon(Icons.book),
             title: Text('Leave Apply',),
             onTap: () {Navigator.pop(context);Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage(), )); },
             //selected: true,
           ),
          ]),




          //LOGOUT SEPARATE FEATURE
          Divider(),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ListTile(
                leading: Icon(Icons.logout, color:Colors.deepOrange),
                title: Text('Logout', style: TextStyle(color: Colors.deepOrange),),
                onTap: () {
                  clearSharedPrefs();
                },
                selected: true,
              ),
            ),
          ),
        ],
      ),
    );
    
  }


    Future<void> clearSharedPrefs() async{
      await logindata.clear();
      Navigator.pop(context);
      _deleteCacheDir();
      loggedin=false;
      //Navigator.pushReplacement(context,new MaterialPageRoute(builder: (context) => LoginPage1()));
      //Navigator.of(context).pushNamedAndRemoveUntil('/', (Route route) => false,);
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => LoginPage1()), (Route<dynamic> route) => false);
    }


  Future<void> initial() async {
    logindata = await SharedPreferences.getInstance();
    loggedin= logindata.getBool('loggedin') ?? false;
    if (loggedin == false)
    { 
      await logindata.clear();
      Navigator.pop(context);
      Navigator.pushReplacement(context,new MaterialPageRoute(builder: (context) => LoginPage1()));
    }
    setState(() 
    {
      if (loggedin == false)
      { 
        Navigator.pushReplacement(context,new MaterialPageRoute(builder: (context) => LoginPage1()));
      }
      else
      {
        role = logindata.getString('role')!;
        email = logindata.getString('email')!;
    }
    });

    if(role=="STUDENT")
    {
      final response = await http.get(Uri.parse(APIs.get_student_program_semester+email));
      final response1 = await http.get(Uri.parse(APIs.student_elective_preferences+email));
      //print(response);
      Map<String, dynamic> map = json.decode(response.body);
      setState(() 
      {
      program=map['program'];
      sem=map['current_semester'].toString();
      logindata.setString('semester', sem);
      });

    if(response1.statusCode == 200)
    {
        Map<String, dynamic> map = json.decode(response1.body);
        setState(() 
        {
        c1=map['elective_1'];
        c2=map['elective_2'];
        c3=map['elective_3'];
        c4=map['elective_4'];
        logindata.setBool('pref_given',true);
        });
    }
    else{ logindata.setBool('pref_given',false); }
    }
    }
}

Future<void> _deleteCacheDir() async {
    Directory tempDir = await getTemporaryDirectory();
    
      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
      }
    }
    
    // Future<void> _deleteAppDir() async {
    //  Directory appDocDir = await getApplicationDocumentsDirectory();

    //   if (appDocDir.existsSync()) {
    //     appDocDir.deleteSync(recursive: true);
    //   }
    // }