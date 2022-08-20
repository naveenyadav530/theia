import '../config/environment.dart';

class ApiUrls {
  static String get_all_flags = Environment.baseAPI + "/language/list";
  static String create_user = Environment.baseAPI + "/account/create";

  static String validate_user =
      Environment.baseAPI + "/account/validate_user?pangea_user_id=";
  static String user_details =
      Environment.baseAPI + "/account/get_user_access_token?pangea_user_id=";

  static String class_list = Environment.baseAPI + "/class/list";

  static String user_ages =
      Environment.baseAPI + "/account/get_update_dob?pangea_user_id=";
  static String update_user_ages =
      Environment.baseAPI + "/account/get_update_dob";
  static String create_class = Environment.baseAPI + "/class/create";
  static String addClassPermissions =
      Environment.baseAPI + "/class/permissions/add";

  static String getClassDetails = Environment.baseAPI + "/class/detail/";
}