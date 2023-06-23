import 'package:flutter/material.dart';
import 'package:multi_contact_picker/multi_contact_picker.dart';
import 'package:flutter/cupertino.dart';

//
// Make sure you add the Android and iOS permission tags as mentioned in package homepage
// Please run this in an actual physical device. Will not work on simulators
//
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Multi Contact Picker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      slivers: <Widget>[
        const CupertinoSliverNavigationBar(
          largeTitle: Text('Home'),
          brightness: Brightness.light,
          automaticallyImplyLeading: false,
        ),
        SliverSafeArea(
          minimum: const EdgeInsets.only(top: 4),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                const SizedBox(height: 30),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => MultiContactPicker()))
                          .then((value) {
                        if (value != null) {
                          // List of selected contacts will be returned to you
                          debugPrint(value.toString());
                        }
                      });
                    },
                    child: const Text("Material Page")),
                const SizedBox(height: 30),
                TextButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return MultiContactPicker();
                          }).then((value) {
                        if (value != null) {
                          debugPrint(value.toString());
                        }
                      });
                    },
                    child: const Text("Dialog Box")),
                const SizedBox(height: 30),
                TextButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return MultiContactPicker(
                              appBar: AppBar(
                                title: const Text("Contact Picker"),
                              ),
                              floatingActionButton: const CircleAvatar(
                                backgroundColor: Colors.blue,
                                child: Icon(Icons.check),
                              ),
                              loader: const CircularProgressIndicator(),
                              error: (permission) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Error trying to get contacts",
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      permission.toString(),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                );
                              },
                              emptyState: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "No contacts to display",
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                              contactBuilder: (context, contact, selected) {
                                return ListTile(
                                  title: Text(contact.displayName.toString()),
                                  trailing: Checkbox(
                                    activeColor: Colors.blue,
                                    checkColor: Colors.white,
                                    onChanged: (value) {},
                                    value: selected,
                                  ),
                                );
                              },
                            );
                          }).then((value) {
                        if (value != null) {
                          debugPrint(value.toString());
                        }
                      });
                    },
                    child: const Text("Advanced Customisations"))
              ],
            ),
          ),
        )
      ],
    ));
  }
}
