import 'package:flutter/material.dart';
import 'package:parkr/gateway.dart';
import 'package:parkr/widgets/registerofficerdialog.dart';
import 'package:parkr/models/Officer.dart';

class ManageOfficersPage extends StatefulWidget {
  const ManageOfficersPage({Key? key}) : super(key: key);

  @override
  State<ManageOfficersPage> createState() => _ManageOfficersPageState();
}

class _ManageOfficersPageState extends State<ManageOfficersPage> {
  Future<List<Widget>> _fetchOfficers() async {
    // Place holder widget
    final dbOfficers = await Gateway().listOfficers();
    if (dbOfficers == null) {
      return [];
    }
    return dbOfficers
        .where((officer) => officer != null)
        .map((officer) => (officer as Officer)) // from Officer?
        .map((officer) => Text(officer.id + " : " + officer.role))
        .toList();
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
              FutureBuilder<List<Widget>>(
                future: _fetchOfficers(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Widget>> snapshot) {
                  final officers =
                      snapshot.hasData ? snapshot.data as List<Widget> : [];
                  return Expanded(
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
                  ));
                },
              ),
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
