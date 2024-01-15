// String domain = 'http://192.168.31.40:8080/';

// School
String domain = 'https://3a6f-2405-4803-c64d-2400-7101-63a9-fc96-5ff0.ngrok-free.app/';
// Home
//  String domain = 'http://192.168.1.11:8080/';
const String domain2 = "https://3a6f-2405-4803-c64d-2400-7101-63a9-fc96-5ff0.ngrok-free.app";

// -- auth
String loginDoctorAPI = domain + 'api/v1/doctor/check/';
String loginPatientAPI = domain + 'api/v1/patient/check/';

String registerPatientAPI = domain + 'api/v1/patient/create';
String registerDoctorAPI = domain + 'api/v1/doctor/createjson';

String GetDepartmentAPI = domain + 'api/v1/department/list';

// String sendTokenAPI = domain + 'auth/send-token';
// String resetPassAPI = domain + 'auth/forget-password/change-password';
// -- Doctor
String listDoctor = domain + 'api/v1/doctor/list/';
String createDoctor = domain + 'api/v1/doctor/create';
String getDoctorById = domain + 'api/v1/doctor/';
String updateDoctor = domain + 'api/v1/doctor/update/';
String deleteDoctor = domain + 'api/v1/delete';

// -- Patient
String listPatent = domain + 'api/v1/patient/list';
String createPatient = domain + 'api/v1/patient/create';
String getPatientById = domain + 'api/v1/patient/';
String updatePatient = domain + 'api/v1/patient/update';
String deletePatient = domain + 'api/v1/delete-patient/';

class Constants {
  static const String clientId =
      'AY8lTgaa8RjsHdb7GPorMqN7CVU648lR-9kABGNTltWd8sWwhd7wubAaf0V5E9QbQ0UYvjsG47WWQe6l';
  static const String secretKey =
      'ELIv-VhYhKjBGRiyMPmnaGGqxBFw6FXup2RU83nHVKnF0ZvPPzKHRwfIA4ZN4Z7tXCClSfzcWX6wE_i0';
  static const String returnURL = 'https://samplesite.com/return';
  static const String cancelURL = 'https://samplesite.com/cancel';
}
