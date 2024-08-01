import 'package:formz/formz.dart';

enum ConfirmedPasswordValidationError {
  empty, length, format,
  mismatch,
}

class ConfirmedPassword extends FormzInput<String, ConfirmedPasswordValidationError> {
  final String password;
  static final RegExp passwordRegExp = RegExp(
    r'(?:(?=.*\d)|(?=.*\W+))(?![.\n])(?=.*[A-Z])(?=.*[a-z]).*$',
  );


  const ConfirmedPassword.pure({this.password = ''}) : super.pure('');

  const ConfirmedPassword.dirty({required this.password, String value = ''}) : super.dirty(value);


 @override
  ConfirmedPasswordValidationError? validator(String value) {
    if ( value.isEmpty || value.trim().isEmpty )  return ConfirmedPasswordValidationError.empty;
    if ( value.length < 6 ) return ConfirmedPasswordValidationError.length;
    if ( !passwordRegExp.hasMatch(value) ) return ConfirmedPasswordValidationError.format;
    return password == value
        ? null
        : ConfirmedPasswordValidationError.mismatch;
  }


 String? get errorMessage {
    if ( isValid || isPure ) return null;

    if ( displayError == ConfirmedPasswordValidationError.empty ) return 'El campo es requerido';
    if ( displayError == ConfirmedPasswordValidationError.length ) return 'Mínimo 6 caracteres';
    if ( displayError == ConfirmedPasswordValidationError.format ) return 'Debe de tener Mayúscula, letras y un número';
    if ( displayError == ConfirmedPasswordValidationError.mismatch ) return 'Deben conincidir';

    return null;
  }



}
