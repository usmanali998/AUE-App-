class Validators {
  static String emptyValidator(String text) {
    if (text.isEmpty) {
      return "Please Fill in the field";
    }
    return null;
  }

  static String emailValidator(String email) {
    if (email.isEmpty) {
      return "Please Fill in the email";
    }

    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(p);

    if (!regExp.hasMatch(email)) {
      return "Please Enter Valid Email Address";
    }
    return null;
  }

  static String passwordValidator(String password) {
    if (password.isEmpty) {
      return "Please fill in the password";
    }

    if (password.length < 6) {
      return "Password length must be atleast 6 chrachters.";
    }
    return null;
  }
}
