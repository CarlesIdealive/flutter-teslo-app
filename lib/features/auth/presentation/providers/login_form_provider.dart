/*
  1.- Crear el State del Provider ()
  2.- Como implementar un Notifier
  3.- Como vamos a consumir el Provider en el exterior -> StateNotifierProvider
*/


import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/features/shared/shared.dart';

//1 State del Provider
class LoginFormState {

  final bool isPosting;     //Transaccion asincrona
  final bool isFormPosted;  //Toco el boton del posteado
  final bool isValid;
  final Email email;
  final Password password;

  LoginFormState({
    this.isPosting = false, 
    this.isFormPosted = false, 
    this.isValid = false, 
    this.email = const Email.pure(), 
    this.password = const Password.pure()
  });

  LoginFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    Email? email,
    Password? password,
  }) => LoginFormState(
    isPosting: isPosting ?? this.isPosting,
    isFormPosted: isFormPosted ?? this.isFormPosted,
    isValid: isValid ?? this.isValid,
    email: email ?? this.email,
    password: password ?? this.password,
  );

  @override
  String toString() {
    return '''
      LoginFormState:
        isPosting : $isPosting
        isFormPosted : $isFormPosted
        isValid : $isValid
        email : $email
        password : $password
    ''';
  }

}


//  2.- Como implementar un Notifier
class LoginFormNotifier extends StateNotifier<LoginFormState> {
  LoginFormNotifier(): super( LoginFormState() );
  

  onEmailChange( String value ) {
    final newEmail = Email.dirty(value);
    state = state.copyWith(
      email: newEmail,
      isValid: Formz.validate([ newEmail, state.password ])
    );
  }

  onPasswordChange( String value ) {
    final newPassword = Password.dirty(value);
    state = state.copyWith(
      password: newPassword,
      isValid: Formz.validate([ newPassword, state.email ])
    );
  }

  onFormSubmit() {
    _touchedEveryField();
    if ( !state.isValid) return;

    print(state.toString());
  }


  _touchedEveryField() {
    final email = Email.dirty( state.email.value );
    final password = Password.dirty( state.password.value );
    state = state.copyWith(
      isFormPosted: true,
      email: email,
      password: password,
      isValid: Formz.validate([ email, password ])
    );
  }


}


// 3.- Como vamos a consumir el Provider en el exterior -> StateNotifierProvider
//Autodispose para eliminar la informacion de la pantalla delogin al no utilizar el LoginProvider
final loginFormProvider = StateNotifierProvider.autoDispose<LoginFormNotifier, LoginFormState>((ref) {
  //Creamos la instancia del Notifier
  return LoginFormNotifier();
});



