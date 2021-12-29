// ignore_for_file: non_constant_identifier_names

class APIs
{
  //static var host_login="http://10.0.2.2:8000/";
  //static var host_student="http://10.0.2.2:8000/";
  static var host_login="http://automation.csebu.com/login/";
  static var host_student="http://automation.csebu.com/students/";
  static var host_course = "http://automation.csebu.com/course/";

  //login related apis
  static var api_login = host_login+"login/"; 
  static var up_login = host_login+"up_login/"; 

   //send mail
  static var send_mail = host_student+"send_mail/"; 

  //student related apis
  static var course_details = host_student+"get_possible_student_electives/"; 
  static var student_elective_preferences = host_student+"get_current_student_electives/"; 
  static var get_student_program_semester = host_student+"get_student_program_semester/"; 
  static var create_student_electives = host_student+"create_student_electives/";
  
  //course related apis
  static var get_course_name = host_student+"get_course_name/";

}