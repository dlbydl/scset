import 'package:cse_flutter_application/all_libraries.dart';
import 'package:http/http.dart' as http;

class GivenElectivePreferences extends StatefulWidget {
  String coursecode1,coursecode2,coursecode3,coursecode4;
  GivenElectivePreferences({
    Key? key,
    required this.coursecode1,
    required this.coursecode2,
    required this.coursecode3,
    required this.coursecode4,
    }) : super(key: key);

  @override
  _GivenElectivePreferences createState() => _GivenElectivePreferences();
}

class _GivenElectivePreferences extends State<GivenElectivePreferences> {
  late SharedPreferences logindata;
  String email="";
  String role="";
  bool loggedin=false;
  String coursename1="";
  String coursename2="";
  String coursename3="";
  String coursename4="";

  @override
  void initState() 
  {
  if (!mounted) return;
  super.initState();
  _getSession();
  }

  @override
	void dispose() {		super.dispose(); }

  @override
  Widget build(BuildContext context) {
    const title = 'Elective Preferences';
    return MaterialApp(
      title: title,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            title: const Text(title),
            backgroundColor: Colors.deepOrange,
          ),
          drawer: MyDrawer(),
          body: ListView(
          padding: const EdgeInsets.all(8),
          children: <Widget>[
        Card(child:ListTile( title: Text(widget.coursecode1),subtitle: Text(coursename1), leading: CircleAvatar(backgroundColor:Colors.green.shade600 ,child: const Text("1",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold))), trailing: const Icon(Icons.star_border_purple500))),
        Card(child:ListTile( title: Text(widget.coursecode2),subtitle: Text(coursename2), leading: CircleAvatar(backgroundColor:Colors.green.shade500, child: Text("2",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold))), trailing: Icon(Icons.star_border_purple500))),
        Card(child:ListTile( title: Text(widget.coursecode3),subtitle: Text(coursename3), leading:  CircleAvatar(backgroundColor:Colors.green.shade400, child: Text("3",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold))), trailing: Icon(Icons.star_border_purple500))),
        Card(child:ListTile( title: Text(widget.coursecode4),subtitle: Text(coursename4), leading:  CircleAvatar(backgroundColor:Colors.green.shade300, child: Text("4",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold))), trailing: Icon(Icons.star_border_purple500)))
      ],
    )
      ),
  );
}

    Future<void> clearSharedPrefs() async 
    {
      await logindata.clear();
      Navigator.pop(context);
      Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => LoginPage1()));
    }

  Future<void> _getSession() async {

    logindata = await SharedPreferences.getInstance();
    loggedin= logindata.getBool('loggedin') ?? false;
    if (loggedin == false)
    { 
      clearSharedPrefs(); 
    }
    else{
    setState(() {
      email = logindata.getString('email')!;
      role = logindata.getString('role')!;
      loggedin=logindata.getBool('loggedin')!;
    });
    
    final response1 = await http.get(Uri.parse(APIs.get_course_name+widget.coursecode1));
    final response2 = await http.get(Uri.parse(APIs.get_course_name+widget.coursecode2));
    final response3 = await http.get(Uri.parse(APIs.get_course_name+widget.coursecode3));
    final response4 = await http.get(Uri.parse(APIs.get_course_name+widget.coursecode4));

    if(widget.coursecode1 != "")
    {
    Map<String, dynamic> map1 = json.decode(response1.body);
    setState(() {coursename1=map1['course_name'];});
    }

    if(widget.coursecode2 != "")
    {
    Map<String, dynamic> map2 = json.decode(response2.body);
    setState(() {coursename2=map2['course_name'];});
    }

    if(widget.coursecode3 != "")
    {
    Map<String, dynamic> map3 = json.decode(response3.body);
    setState(() {coursename3=map3['course_name'];});
    }

    if(widget.coursecode4 != "")
    {
    Map<String, dynamic> map4 = json.decode(response4.body);
    setState(() {coursename4=map4['course_name'];});
    }
    
  }
  }
}