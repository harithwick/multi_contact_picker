library multi_contact_picker;

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class MultiContactPicker extends StatefulWidget {
  final Color? leadingAvatarColor;
  final Widget Function(BuildContext, Contact)? contactBuilder;
  final Widget? floatingActionButton;
  final Widget? loader;
  final Widget Function(PermissionStatus)? error;
  const MultiContactPicker(
      {Key? key,
      this.error,
      this.leadingAvatarColor,
      this.loader,
      this.floatingActionButton,
      this.contactBuilder})
      : super(key: key);

  @override
  State<MultiContactPicker> createState() => _MultiContactPickerState();
}

class _MultiContactPickerState extends State<MultiContactPicker> {
  List<Contact> _contacts = [];
  List<Contact> selectedContacts = [];
  bool _isLoading = false;
  bool error = false;
  PermissionStatus? permissionStatusError = PermissionStatus.denied;

  @override
  void initState() {
    super.initState();
    getContactsPermission();
  }

  void getContactsPermission() async {
    await Permission.contacts.request().then((PermissionStatus value) async {
      try {
        debugPrint("Contact Permission Status $value");
        if (value != PermissionStatus.granted) {
          permissionStatusError = value;
          error = true;
        }
        setState(() {});
        if (value == PermissionStatus.granted) {
          setState(() {
            _isLoading = true;
          });
          var contacts = await ContactsService.getContacts();
          debugPrint("Contacts found: ${contacts.length}");
          _populateContacts(contacts);
        }
      } catch (error) {
        debugPrint("Error: $error");
      }
    });
  }

  void _populateContacts(Iterable<Contact> contacts) {
    try {
      _contacts = contacts.where((item) => item.displayName != null).toList();
      _contacts.sort((a, b) => a.displayName!.compareTo(b.displayName!));
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  String getInitials(String string) => string.isNotEmpty
      ? string.trim().split(' ').map((l) => l[0]).take(2).join()
      : '';

  ListTile _buildListTile(Contact contact) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: widget.leadingAvatarColor,
        child: Text(getInitials(contact.displayName ?? "")),
      ),
      title: Text(contact.displayName ?? ""),
      subtitle: contact.phones != null &&
              contact.phones!.isNotEmpty &&
              contact.phones![0].value != null
          ? Text(contact.phones![0].value.toString())
          : null,
      trailing: Checkbox(
          activeColor: Colors.green,
          value: selectedContacts.contains(contact),
          onChanged: (bool? value) {
            debugPrint(contact.displayName);
            if (value != null) {
              if (value) {
                selectedContacts.add(contact);
              } else {
                selectedContacts.remove(contact);
              }
              setState(() {});
            }
          }),
    );
  }

  Widget centeredLoader({required Widget child}) {
    if (error) {
      if (widget.error == null) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Error occurred when trying to retrieve contacts. Please grant contact permissions from phone settings",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(permissionStatusError.toString()),
            ],
          )),
        );
      }
      return widget.error!(permissionStatusError!);
    }
    if (_isLoading) {
      if (widget.loader == null) {
        return const Center(child: CircularProgressIndicator());
      }
      return widget.loader!;
    }
    return child;
  }

  Widget? buildFloatingActionButton() {
    if (selectedContacts.isNotEmpty) {
      return GestureDetector(
          behavior: HitTestBehavior.deferToChild,
          onTap: () {
            Navigator.pop(context, selectedContacts);
          },
          child: widget.floatingActionButton ??
              Container(
                margin: const EdgeInsets.all(8.0),
                padding: const EdgeInsets.all(16.0),
                decoration: const BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                ),
              ));
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Scaffold(
      appBar: AppBar(),
      body: centeredLoader(
        child: ListView.separated(
          shrinkWrap: true,
          padding: const EdgeInsets.only(bottom: 50),
          separatorBuilder: (context, index) {
            return Divider(
              color: Colors.grey.shade200,
              height: 0,
            );
          },
          itemCount: _contacts.length,
          itemBuilder: (BuildContext context, int index) {
            Contact contact = _contacts[index];
            return widget.contactBuilder != null
                ? widget.contactBuilder!(context, contact)
                : _buildListTile(contact);
          },
        ),
      ),
      floatingActionButton: buildFloatingActionButton(),
    ));
  }
}
