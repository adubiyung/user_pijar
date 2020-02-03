class FormValidator {
  String validateName(String value) {
    return value.trim().isEmpty ? "Nama tidak boleh kosong" : null;
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Email tidak sesuai';
    } else {
      return null;
    }
  }

  String validatePhone(String value) {
    return value.length < 10 ? 'Nomor tidak sesuai' : null;
  }
}