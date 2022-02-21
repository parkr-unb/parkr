import 'package:flutter/material.dart';
import 'package:parkr/views/registerofficerdialog.dart';

class ManageOfficersPage extends StatefulWidget {
  const ManageOfficersPage({Key? key}) : super(key: key);

  @override
  State<ManageOfficersPage> createState() => _ManageOfficersPageState();
}

class _ManageOfficersPageState extends State<ManageOfficersPage> {
  List<Widget> _fetchOfficers() {
    // Place holder widget
    return <Widget>[
      const Text("ballsack"),
      const Text("ballsack"),
      const Text("ballsack"),
      const Text("ballsack"),
      const Text("ballsack"),
      const Text("ballsack"),
      const Text("ballsack"),
      const Text("ballsack"),
      const Text("ballsack"),
      const Text("ballsack"),
      const Text("ballsack"),
      const Text("ballsack"),
      const Text("ballsack"),
      const Text("ballsack"),
      const Text("ballsack"),
      const Text("ballsack"),
      const Text("ballsack"),
      const Text("ballsack"),
      const Text("ballsack")
    ];
  }

  @override
  Widget build(BuildContext context) {
    final officers = _fetchOfficers();
    return Scaffold(
        appBar: AppBar(
          title: const Text("Parking Officers"),
        ),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              Expanded(
                  child: ListView.separated(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                padding: const EdgeInsets.all(8),
                itemCount: officers.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    height: 50,
                    color: Colors.amber,
                    child: Center(child: officers[index]),
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
              )),
              const Divider(thickness: 3),
              ElevatedButton(
                  child: const Text('New Officer'),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const RegisterOfficerDialog();
                        });
                  }),
            ])));
  } // build

}