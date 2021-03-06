import 'package:flutter/material.dart';
import 'package:parkr/widgets/loginform.dart';
import 'package:parkr/widgets/registerorgform.dart';



class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  static const String title = 'Parkr';

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: PreferredSize(preferredSize: const Size.fromHeight(100.0), child: AppBar(
              title: const Text(WelcomePage.title),
              bottom: const TabBar(tabs: [
                Tab(icon: Icon(Icons.account_box), text: "Login"),
                Tab(icon: Icon(Icons.house), text: "New Organization")
              ]))),
          body: const TabBarView(
            children: [
              LoginForm(),
              RegisterOrgForm(),
            ],
          ),
        ));
  } // build
}
