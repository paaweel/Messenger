import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kopper/blocs/contacts/ContactsBloc.dart';
import 'package:kopper/pages/ContactListPage.dart';
import 'config/Palette.dart';
import 'pages/RegisterPage.dart';
import 'package:kopper/repositories/AuthenticationRepository.dart';
import 'package:kopper/repositories/StorageRepository.dart';
import 'package:kopper/repositories/UserDataRepository.dart';
import 'package:kopper/repositories/ChatRepository.dart';
import 'package:kopper/blocs/authentication/AuthenticationBloc.dart';
import 'package:kopper/blocs/chat/ChatBloc.dart';
import 'package:kopper/utils/SharedObjects.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //create instances of the repositories to supply them to the app
  final AuthenticationRepository authRepository = AuthenticationRepository();
  final UserDataRepository userDataRepository = UserDataRepository();
  final StorageRepository storageRepository = StorageRepository();
  final ChatRepository chatRepository = ChatRepository();
  SharedObjects.prefs = await SharedPreferences.getInstance();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) => AuthenticationBloc(
            authenticationRepository: authRepository,
            userDataRepository: userDataRepository,
            storageRepository: storageRepository)
          ..add(AppLaunched()),
      ),
      BlocProvider<ContactsBloc>(
        create: (context) => ContactsBloc(
          userDataRepository: userDataRepository,
          chatRepository: chatRepository,
        ),
      ),
      BlocProvider<ChatBloc>(
        create: (context) => ChatBloc(
            userDataRepository: userDataRepository,
            storageRepository: storageRepository,
            chatRepository: chatRepository),
      )
    ],
    child: Kopper(),
  ));
}

class Kopper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Kopper",
      theme: ThemeData(
        primaryColor: Palette.primaryColor,
//        primarySwatch: Palette.primaryColor,
        fontFamily: 'Manrope',
      ),
      // home: RegisterPage()
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is UnAuthenticated) {
            return RegisterPage();
          } else if (state is ProfileUpdated) {
            BlocProvider.of<ChatBloc>(context).add(FetchChatListEvent());
            return ContactListPage();
          } else {
            return RegisterPage();
          }
        },
      ),
    );
  }
}
