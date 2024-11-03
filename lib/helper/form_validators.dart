//! This class holds all form validators.

class FormValidator {
// -------------------------------
// Method for validating first name
// -------------------------------

  static String? firstNameValidator(String? value) {
    // If the text field is empty
    if (value!.isEmpty) {
      return "Please enter a first name";
    }
    // For first name validation
    else if (!RegExp(r"^[a-zA-Z0-9]").hasMatch(value)) {
      return "Enter a correct first name";
    }
    // First name must be no longer than 15 characters
    else if (RegExp(r"^.{15}").hasMatch(value)) {
      return "First name must be no longer than 15 characters";
    }
    // First name should not contain special characters
    else if (RegExp(r"^(?=.*[#?!@$%^&*-+()/':;])").hasMatch(value)) {
      return "First name should not contain special characters";
    }
    // Else return nothing
    else {
      return null;
    }
  }

// --------------------------------
// Method for validating second name
// --------------------------------

  static String? secondNameValidator(String? value) {
    // If the text field is empty
    if (value!.isEmpty) {
      return "Please enter a second name";
    }
    // For second name validation
    else if (!RegExp(r"^[a-zA-Z0-9]").hasMatch(value)) {
      return "Enter a correct second name";
    }
    // Second name must be no longer than 15 characters
    else if (RegExp(r"^.{15}").hasMatch(value)) {
      return "Second name must be no longer than 15 characters";
    }
    // Second name should not contain special characters
    else if (RegExp(r"^(?=.*[#?!@$%^&*-+()/':;])").hasMatch(value)) {
      return "Second name should not contain special characters";
    }
    // Else return nothing
    else {
      return null;
    }
  }

// ------------------------------
// Method for validating username
// ------------------------------

  static String? userNameValidator(String? value) {
    // If the text field is empty
    if (value!.isEmpty) {
      return "Please enter a username";
    }
    // For username validation
    else if (!RegExp(r"^[a-zA-Z0-9]").hasMatch(value)) {
      return "Enter a correct username";
    }
    // Username must be no longer than 15 characters
    else if (RegExp(r"^.{15}").hasMatch(value)) {
      return "Username must be no longer than 15 characters";
    }
    // Username should not contain special characters
    else if (RegExp(r"^(?=.*[#?!@$%^&*-+()/':;])").hasMatch(value)) {
      return "Username should not contain special characters";
    }
    // Else return nothing
    else {
      return null;
    }
  }

// ----------------------------
// Method for validating email
// ----------------------------

  static String? emailValidator(String? value) {
    // If the text field is empty
    if (value!.isEmpty) {
      return "Please enter an email";
    }
    // RegExp for email validation
    else if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+$")
        .hasMatch(value)) {
      return "Enter a correct email";
    }
    // Else return nothing
    else {
      return null;
    }
  }

// ------------------------------
// Method for validating password
// ------------------------------

  static String? passwordValidator(String? value) {
    // If the text field is empty
    if (value!.isEmpty) {
      return "Please enter a password";
    }

    // Minimum six in length
    else if (!RegExp(r"^.{6}").hasMatch(value)) {
      return "Minimum six in length";
    }
    // Else return nothing
    else {
      return null;
    }
  }

// ----------------------------------
// Method for validating phone number
// ----------------------------------

  static String? phoneNumberValidator(String? value) {
    // If the text field is empty
    if (value!.isEmpty) {
      return "Please enter a number";
    }
    // Validating phone number
    else if (!RegExp(r"^(?:(?:\+|0{0,2})91(\s*[\-]\s*)?|[0]?)?[789]\d{9}$")
        .hasMatch(value)) {
      return "Please enter a valid number";
    }

    // Else return nothing
    else {
      return null;
    }
  }

// ---------------------------
// Method for validating OTPs
// ---------------------------

  static String? otpValidator(String? value) {
    // If the text field is empty
    if (value!.isEmpty) {
      return "OTP required";
    }
    // If OTP is less than 6 digits
    else if (value.length < 6) {
      return "Make sure all OTP fields are filled in";
    }
    // Validating OTP
    else if (!RegExp(r"^[0-9]{1,6}$").hasMatch(value)) {
      return "Only digits are allowed";
    }

    // Else return nothing
    else {
      return null;
    }
  }
}
