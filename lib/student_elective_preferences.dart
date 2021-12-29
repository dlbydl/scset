import 'package:cse_flutter_application/all_libraries.dart';
import 'package:http/http.dart' as http;

class StudentElectivePreferences extends StatefulWidget {
  StudentElectivePreferences({key}) : super(key: key);

  @override
  _StudentElectivePreferences createState() => _StudentElectivePreferences();
}

class _StudentElectivePreferences extends State {
  late SharedPreferences logindata;
  String email="";
  String role="";
  String sem="";
  bool loggedin=false;
  bool first=false;
  List CourseList = [];
  late var c1="";
  late var c2="";
  late var c3="";
  late var c4="";

  @override
  void initState() 
  {
  if (!mounted) return;
  super.initState();
  _getCoursInfo();
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
            actions: <Widget>[
              IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    _refresh();
                    Navigator.pop(context);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => StudentElectivePreferences()));
                  }),
              IconButton(
                icon: const Icon(Icons.save),
                onPressed: () {
                  (!choice.isEmpty)
                      ? (choice.length == 4)
                          ? showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text('Elective Choices Order'),
                                content: Text("1-> " +
                                    choice[0].toString() +
                                    "\n" +
                                    "2-> " +
                                    choice[1].toString() +
                                    "\n" +
                                    "3-> " +
                                    choice[2].toString() +
                                    "\n" +
                                    "4-> " +
                                    choice[3].toString() +
                                    ""),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'Cancel'),
                                    child: const Text('Cancel',style:TextStyle(color:Colors.deepOrange)),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context, 'Submit');
                                      insert();
                                      
                                      c1=choice[0].toString();
                                      var arr=c1.split(':');
                                      c1=arr[0];

                                      c2=choice[1].toString();
                                      var arr1=c2.split(':');
                                      c2=arr1[0];

                                      c3=choice[2].toString();
                                      var arr2=c3.split(':');
                                      c3=arr2[0];

                                      c4=choice[3].toString();
                                      var arr3=c4.split(':');
                                      c4=arr3[0];

                                      _refresh();
                                    Navigator.pop(context);
                                    //Navigator.of(context).push(MaterialPageRoute(builder: (context) =>HomePage()));
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => 
             GivenElectivePreferences(coursecode1: c1,coursecode2: c2,coursecode3: c3,coursecode4: c4)));
                                    },
                                    child: const Text('Submit',style:TextStyle(color:Colors.deepOrange)),
                                  ),
                                ],
                              ),
                            )
                          : showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text('Information'),
                                content: const Text('Please select 4 elective course choices !!'),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'OK'),
                                    child: const Text('OK',style:TextStyle(color:Colors.deepOrange)),
                                  ),
                                ],
                              ),
                            )
                      : showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text('Information'),
                            content: const Text('Please select 4 elective course choices !!'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'OK'),
                                child: const Text('OK',style:TextStyle(color:Colors.deepOrange)),
                              ),
                            ],
                          ),
                        );
                },
              ),
            ],
          ),
          drawer: MyDrawer(),
          body: Column(//Acoomodate two list views
              children: <Widget>[
            Expanded(
                //Expanded for  List View
                child: Container(
              //height:600,
              child: 
              ListView.builder(
                shrinkWrap: true,
                itemCount: courses.length,
                itemBuilder: (context, index) => MyExpandableWidget(courses[index]),
              ),
            )),
          ])),
    );
  }

  Future<void> clearSharedPrefs() async 
  {
      await logindata.clear();
      Navigator.pop(context);
      Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => LoginPage1()));
  }

  Future<void> _getCoursInfo() async {
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
      first = logindata.getBool('shared_pref')!;
      sem=logindata.getString('semester')!;
      //if(email.isEmpty && role.isEmpty) { clearSharedPrefs() ;     }
    });

    final response = await http.get(Uri.parse(APIs.course_details+email));
    final items = json.decode(response.body).cast<Map<String, dynamic>>();

    setState(() {
      CourseList = items;
      courses = [];
      //choice = [];
      //sc=[];
      //print("first"+sem);print(first);
      if(first==true)
      {
          logindata.setBool('shared_pref',false);
          choice = [];
          sc=[];
          Navigator.pop(context);
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => StudentElectivePreferences()));
      }
    });

    for (var rb in CourseList) {courses.add(Course(code: rb['course_id'],name: rb['course_name'],description: rb['course_short_description']));}
    //_displaymessage();
  }
  }
  Future<void> insert() async {
    String dataurl = APIs.create_student_electives;
    String course1 = '', course2 = '', course3 = '', course4 = '';
    var count = 1;
    for (var i in choice) {
      var arr = i.split(":");
      if (count == 1) {course1 = arr[0];count++;} 
      else if (count == 2) {course2 = arr[0];count++;}
      else if (count == 3) {course3 = arr[0];count++;} 
      else if (count == 4) {course4 = arr[0];count++;}
    }

    Map<String, dynamic> parameters = Map<String, dynamic>();
    parameters['bennett_email'] = email;
    parameters['semester']=sem;
    parameters['elective_1'] = course1;
    parameters['elective_2'] = course2;
    parameters['elective_3'] = course3;
    parameters['elective_4'] = course4;

    var encodedBody = json.encode(parameters);
    http.Response response = await http.post(Uri.parse('$dataurl'), headers: {"Content-Type": "application/json; charset=UTF-8"}, body: encodedBody);
    //print(encodedBody);
  }

}

//class MyExpandableWidget extends StatelessWidget {
class MyExpandableWidget extends StatefulWidget {
  late Course cor;
  MyExpandableWidget(c) {
    this.cor = c;
  }

  @override
  _MyExpandableWidget createState() => _MyExpandableWidget(this.cor);
}

class _MyExpandableWidget extends State {
  late Course _course;
  _MyExpandableWidget(cor) {
    this._course = cor;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        key: PageStorageKey<Course>(_course),
        leading: SwitchScreen(_course.code, _course.name),
        title:
            Text(_course.code, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(_course.name),
        children: <Widget>[
          ListTile(
            title: Text(_course.description, style: TextStyle(fontSize: 12)),
          )
        ],
      ),
      shadowColor: Colors.deepOrange,
    );
  }
}

class SwitchScreen extends StatefulWidget {
  String ccode = '', cname = '';

  SwitchScreen(c, n) {
    this.ccode = c;
    this.cname = n;
  }

  @override
  SwitchClass createState() => new SwitchClass(this.ccode, this.cname);
}

class SwitchClass extends State {
  bool isSwitched=false;
  var scode, sname;

  SwitchClass(ccode, cname) {
    scode = ccode;
    sname = cname;
    var ind=sc.indexWhere((st) => st.scode==scode);
    if (ind!=-1)
    {
      //print("Hello Taking Switch value from:"+ind.toString());
      //print(isSwitched);
      isSwitched=sc[ind].isSwitched;
      //print(isSwitched);
    }
    else
    {
        isSwitched=false;
        sc.add(this);
        //print("Hello Adding Switch:"+ind.toString());
    }
    
  }

  void reset() {
    this.isSwitched = false;
  }

  String returnIndex(c, n) {
    var s = scode + ':' + sname;
    var ind = choice.indexOf(s);
    ind++;
    return ind.toString();
  }

  void toggleSwitch(bool value) {
    if (isSwitched == false) {
      setState(() {
        var len = choice.length;
        if (len < 4) {
          
          var s = scode + ':' + sname;
          isSwitched = true;

          var index=sc.indexWhere((st) => st.scode==scode);
          if (index!=-1)
          {
            sc[index].isSwitched=true;
          }
          //print("At index:"+index.toString()+sc[index].scode+sc[index].sname);
          //print(sc[index].isSwitched);
          //print(s); print('True');

          choice.add(s);
          //print(choice);
        } 
        else {
          isSwitched = false;
        }
      });
    } else {
      setState(() {
        var s = scode + ':' + sname;
        var ind = choice.indexOf(s);
        var len = choice.length;
        if (ind != -1) {
          choice.removeAt(ind);
          isSwitched = false;

          var index=sc.indexWhere((st) => st.scode==scode);
          if (index!=-1)
          {
            sc[index].isSwitched=false;
          }
          //print("At index:"+index.toString()+sc[index].scode+sc[index].sname);
          //print(sc[index].isSwitched);

        }
        if (ind != (len - 1)) {
          _refresh();
          Navigator.pop(context);
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => StudentElectivePreferences()));
        }
        isSwitched = false;
        //print('False'); print(s);
        //print(choice);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Expanded(
          child: isSwitched
              ? Text(
                  returnIndex(scode, sname) + "' Pref",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )
              : Text('')),
      Expanded(
          child: Transform.scale(
              scale: 1,
              child: Switch(
                onChanged: toggleSwitch,
                value: isSwitched,
                activeColor: Colors.green,
                activeTrackColor: Colors.lightGreen,
                inactiveThumbColor: Colors.blueGrey,
                inactiveTrackColor: Colors.grey,
              ))),
    ]);
  }
}

class Course {
  String code;
  String name;
  String description;
  Course({this.code = "", this.name = "", this.description = ""});
}

//INPUT PART
late List<Course> courses = [];

//OUTPUT ["code1:coursename",""code1:coursename""]
List<String> choice = [];
List<SwitchClass> sc = [];

_switchReset() {
  for (var i = 0; i < sc.length; i++) {
    sc[i].reset();
  }
}

//_displaymessage() { SnackBar(content: Text("Please Select In Order !!")); }

_refresh() {
  courses.clear();
  choice.clear();
  sc.clear();
  _switchReset();
}
