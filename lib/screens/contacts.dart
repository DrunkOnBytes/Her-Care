import 'package:flutter/material.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Contacts extends StatefulWidget {
  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  List<String> contactsNums = [];
  List<String> contactsNames = [];

  SharedPreferences prefs;

  _initializeContacts() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      contactsNums = prefs.getStringList('nums') ?? [];
      contactsNames = prefs.getStringList('names') ?? [];
    });
  }

  @override
  void initState() {
    _initializeContacts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text("Emergency Contacts"),
      ),
      body: contactsNames.length > 0
          ? ListView.builder(
              itemCount: contactsNames.length,
              itemBuilder: (BuildContext ctx, int i) {
                return Card(
                  margin: EdgeInsets.all(5),
                  child: ListTile(
                    leading: Icon(
                      Icons.account_circle,
                      size: 35,
                    ),
                    title: Text(contactsNames[i]),
                    subtitle: Text(contactsNums[i]),
                    trailing: GestureDetector(
                      child: Icon(Icons.delete),
                      onTap: () async {
                        setState(() {
                          contactsNames.removeAt(i);
                          contactsNums.removeAt(i);
                        });
                        await prefs.setStringList('nums', contactsNums);
                        await prefs.setStringList('names', contactsNames);
                      },
                    ),
                  ),
                );
              },
            )
          : Center(
              child: Text('No contacts added yet'),
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          final PhoneContact contact =
              await FlutterContactPicker.pickPhoneContact();
          setState(() {
            contactsNames.add(contact.fullName);
            contactsNums.add(contact.phoneNumber.number);
          });
          await prefs.setStringList('nums', contactsNums);
          await prefs.setStringList('names', contactsNames);
        },
      ),
    );
  }
}
