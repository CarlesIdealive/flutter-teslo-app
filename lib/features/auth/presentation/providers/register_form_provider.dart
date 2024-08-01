import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/features/shared/infrastructure/inputs/required_input.dart';

import '../../../shared/shared.dart';



// 3.- Como vamos a consumir el Provider en el exterior -> StateNotifierProvider
//Autodispose para eliminar la informacion de la pantalla delogin al no utilizar el LoginProvider
final registerFormProvider = StateNotifierProvider.autoDispose<RegisterFormNotifier, RegisterFormState>((ref) {
  //Creamos la instancia del Notifier
  return RegisterFormNotifier();
});



//  2.- Como implementar un Notifier
class RegisterFormNotifier extends StateNotifier<RegisterFormState> {
  RegisterFormNotifier() : super( RegisterFormState());

  onNameChange( String value ) {
    final newName = RequiredInput.dirty(value);
    state = state.copyWith(
      name: newName,
      isValid: Formz.validate([ newName, state.email, state.password, state.repeatPassword ])
    );
  }

  onEmailChange( String value ) {
    final newEmail = Email.dirty(value);
    state = state.copyWith(
      email: newEmail,
      isValid: Formz.validate([ newEmail, state.name, state.password, state.repeatPassword ])
    );
  }

  onPasswordChange( String value ) {
    final newPassword = Password.dirty(value);
    state = state.copyWith(
      password: newPassword,
      isValid: Formz.validate([ 
        newPassword,
        state.name,
        state.email,
        state.repeatPassword,
      ])
    );
  }

  onRepeatPasswordChange( String value ) {
    final newPassword = ConfirmedPassword.dirty(
      password: state.password.value ,
      value: value
    );
    state = state.copyWith(
      repeatPassword: newPassword,
      isValid: Formz.validate([
        newPassword,
        state.name, 
        state.email, 
        state.password 
      ]),
    );
  }



  onFormSubmit() {
    _touchedEveryField();

    if ( !state.isValid) return;

    print(state.toString());
  }


  _touchedEveryField() {
    final name = RequiredInput.dirty(state.name.value);
    final email = Email.dirty( state.email.value );
    final password = Password.dirty( state.password.value );
    final repeatpassword = ConfirmedPassword.dirty(password: state.password.value, value: state.repeatPassword.value );
    state = state.copyWith(
      isFormPosted: true,
      name: name,
      email: email,
      password: password,
      repeatPassword: repeatpassword,
      isValid: Formz.validate([ name, email, password, repeatpassword ])
    );
  }

}



//1 State del Provider
class RegisterFormState {

  final bool isPosting;   //Para controlar la transaccion asincrona
  final bool isFormPosted;
  final bool isValid;
  final RequiredInput name;
  final Email email;
  final Password password;
  final ConfirmedPassword repeatPassword;

  RegisterFormState({
    this.isPosting = false, 
    this.isFormPosted = false, 
    this.isValid = false, 
    this.name = const RequiredInput.pure(),
    this.email = const Email.pure(),
    this.password  = const Password.pure(),
    this.repeatPassword = const ConfirmedPassword.pure(), 
  });

  RegisterFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    RequiredInput? name,
    Email? email,
    Password? password,
    ConfirmedPassword? repeatPassword,
  }) => RegisterFormState(
    isPosting : isPosting ?? this.isPosting,
    isFormPosted : isFormPosted ?? this.isFormPosted,
    isValid : isValid ?? this.isValid,
    name : name ?? this.name,
    email : email ?? this.email,
    password : password ?? this.password,
    repeatPassword : repeatPassword ?? this.repeatPassword,
  );

}