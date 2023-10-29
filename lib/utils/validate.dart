enum ValidateType { normal, email, number, phone, tag }

class UtilValidator {
  static const String errorEmpty = "value_not_empty";
  static const String errorRange = "value_not_valid_range";
  static const String errorEmail = "value_not_valid_email";
  static const String errorNumber = "value_not_number";
  static const String errorPhone = "value_not_phone";
  static const String errorPassword = "value_not_valid_password";
  static const String errorId = "value_not_valid_id";
  static const String valueNotMatch = "value_not_match";
  static const String valueNotIsTag = "value_not_is_tag";

  static String? validate(
    String data, {
    ValidateType? type = ValidateType.normal,
    int? min,
    int? max,
    bool allowEmpty = false,
    String? match,
  }) {
    ///Empty
    if (!allowEmpty && data.isEmpty) {
      return errorEmpty;
    }

    ///Match
    if (match != null && match != data) {
      return valueNotMatch;
    }

    if (data.isEmpty) return null;

    switch (type) {

      ///Email pattern
      case ValidateType.email:
        final emailRegex = RegExp(
          r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$",
        );
        if (!emailRegex.hasMatch(data)) {
          return errorEmail;
        }
        break;

      ///Phone pattern
      case ValidateType.number:
        final phoneRegex = RegExp(r'^[0-9]*$');
        if (!phoneRegex.hasMatch(data)) {
          return errorNumber;
        }
        break;

      ///Phone pattern
      case ValidateType.phone:
        const pattern = r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$';
        final phoneRegex = RegExp(pattern);
        if (!phoneRegex.hasMatch(data)) {
          return errorPhone;
        }
        break;

      ///Tag pattern
      case ValidateType.tag:
        final tagRegex = RegExp(r'^([^0-9|\,\s]*)$');
        if (!tagRegex.hasMatch(data)) {
          return valueNotIsTag;
        }
        break;
      default:
    }
    return null;
  }

  ///Singleton factory
  static final UtilValidator _instance = UtilValidator._internal();

  factory UtilValidator() {
    return _instance;
  }

  UtilValidator._internal();
}
