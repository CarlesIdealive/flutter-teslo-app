
import 'package:formz/formz.dart';

enum RequiredInputError { empty }

class RequiredInput extends FormzInput<String, RequiredInputError> {

  const RequiredInput.pure() : super.pure('');
  const RequiredInput.dirty( String value ) : super.dirty(value);

  String? get errorMessage {
    if ( isValid || isPure ) return null;

    if ( displayError == RequiredInputError.empty ) return 'El campo es requerido';
    
    return null;
  }


  @override
  validator(String value) {
    if ( value.isEmpty || value.trim().isEmpty ) return RequiredInputError.empty;

    return null;
  }


}