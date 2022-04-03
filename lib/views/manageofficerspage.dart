import 'package:flutter/material.dart';
import 'package:parkr/gateway.dart';
import 'package:parkr/widgets/registerofficerdialog.dart';
import 'package:parkr/models/Officer.dart';
import 'package:parkr/user.dart';
import 'package:parkr/widgets/loadingdialog.dart';
import 'package:parkr/widgets/unavailableicon.dart';

class ManageOfficersPage extends StatefulWidget {
  const ManageOfficersPage({Key? key}) : super(key: key);

  @override
  State<ManageOfficersPage> createState() => _ManageOfficersPageState();
}

class _ManageOfficersPageState extends State<ManageOfficersPage> {
  Future<List<Officer>> _fetchOfficers() async {
    final currentUserId = (await CurrentUser().get()).userId;
    final currentUserOrg = CurrentUser().getOrg();
    return (await Gateway().listOfficers(currentUserOrg) ?? [])
        .where((officer) => officer != null && officer.id != currentUserId)
        .map((officer) => (officer as Officer))
        .toList();
  }

  Future<Object?> eraseOfficer(Officer o) async {
    return await Gateway().removeOfficer(o.id) != null ? "Success" : null;
  }

  Future<void> removeOfficer(BuildContext ctx, Officer o) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text('Remove Officer'),
              content: Text("Are you sure you want to remove ${o.name}?"),
              actions: [
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Remove'),
                  onPressed: () async {
                    await loadingDialog(
                        context,
                        eraseOfficer(o),
                        "Removing ${o.name}...",
                        "Success",
                        "Failed to remove ${o.name}");
                    Navigator.of(context).pop();
                    setState(() {});
                  },
                ),
              ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Parking Officers"),
        ),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              FutureBuilder<List<Officer>>(
                future: _fetchOfficers(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Officer>> snapshot) {
                  if (snapshot.hasError) {
                    print(snapshot.error);
                    return const UnavailableIcon(
                        message: "An Error Occurred Fetching Your Officers",
                        iconData: Icons.error);
                  }

                  if (!snapshot.hasData) {
                    return const UnavailableIcon(
                        message: "Retrieving officers...",
                        iconData: Icons.get_app);
                  }

                  final officers =
                      snapshot.hasData ? snapshot.data as List<Officer> : [];

                  if (officers.isEmpty) {
                    return Expanded(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                          Text("No Officers",
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold))
                        ]));
                  }

                  return Expanded(
                      child: ListView.separated(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    padding: const EdgeInsets.all(8),
                    itemCount: officers.length,
                    itemBuilder: (BuildContext context, int index) {
                      final officer = officers[index] as Officer;
                      return Container(
                          decoration: BoxDecoration(
                              color: ((officer.confirmed == null ||
                                      officer.confirmed!)
                                  ? const Color.fromRGBO(207, 62, 63, 1)
                                  : Colors.black54),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(15))),
                          height: 50,
                          //color: const Color.fromRGBO(207, 62, 63, 1),
                          child: Center(
                              child: Row(children: [
                            const Spacer(flex: 2),
                            RichText(
                                text: TextSpan(
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                    text: officer.name + ":  " + officer.role)),
                            const Spacer(flex: 1),
                            IconButton(
                                color: Colors.white,
                                icon: const Icon(Icons.delete),
                                onPressed: () async {
                                  await removeOfficer(context, officer);
                                }),
                          ])));
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(),
                  ));
                },
              ),
              const Divider(thickness: 3),
              Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: ElevatedButton(
                      child: const Text('New Officer'),
                      onPressed: () async {
                        await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const RegisterOfficerDialog();
                            });
                        setState(() {});
                      })),
            ])));
  } // build

}
