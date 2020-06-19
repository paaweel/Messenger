import 'package:flutter/material.dart';
import 'config/Palette.dart';
import 'pages/RegisterPage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kopper/repositiories/AuthenticationRepository.dart';
import 'package:kopper/repositiories/StorageRepository.dart';
import 'package:kopper/repositiories/UserDataRepository.dart';
import 'package:kopper/blocs/authentication/AuthenticationBloc.dart';
import 'package:kopper/pages/ConversationPageSlide.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //create instances of the repositories to supply them to the app
  final AuthenticationRepository authRepository = AuthenticationRepository();
  final UserDataRepository userDataRepository = UserDataRepository();
  final StorageRepository storageRepository = StorageRepository();
  runApp(
    BlocProvider(
      create: (context) => AuthenticationBloc(
          authenticationRepository: authRepository,
          userDataRepository: userDataRepository,
          storageRepository: storageRepository)
        ..add(AppLaunched()),
      child: Kopper(),
    ),
  );
}

class Kopper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Kopper",
      theme: ThemeData(
        primaryColor: Palette.primaryColor,
//        primarySwatch: Palette.primaryColor,
      ),
      // home: RegisterPage()
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is UnAuthenticated) {
            return RegisterPage();
          } else if (state is ProfileUpdated) {
            return ConversationPageSlide();
          } else {
            return RegisterPage();
          }
        },
      ),
    );
  }
}
