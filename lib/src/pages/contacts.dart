import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';

class MyContacts extends StatefulWidget {
  @override
  _MyContactsState createState() => _MyContactsState();
}

class _MyContactsState extends State<MyContacts> {
  bool _isLoadingContacts = true;
  List<Contact> contacts = [];
  List<Contact> filterdContacts = [];
  TextEditingController searchContactController = new TextEditingController();
  @override
  void initState() {
    super.initState();
    getContactsFromDevice();
    searchContactController.addListener(() {
      filterContacts();
    });
  }

  filterContacts() {
    List<Contact> filteredValues = [];
    filteredValues.addAll(contacts);
    if (searchContactController.text.isNotEmpty) {
      filteredValues.retainWhere((contact) {
        String searchContact = searchContactController.text.toLowerCase();
        String currentContact = contact.displayName.toLowerCase();
        return currentContact.contains(searchContact);
      });
      setState(() {
        filterdContacts = filteredValues;
      });
    }
  }

  getContactsFromDevice() async {
    List<Contact> _contacts =
        (await ContactsService.getContacts(withThumbnails: true)).toList();
    setState(() {
      contacts = _contacts;
      _isLoadingContacts = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool _isSearchingContacts = searchContactController.text.isNotEmpty;
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
        backgroundColor: Colors.blue[900],
      ),
      body: _isLoadingContacts
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: searchContactController,
                    decoration: InputDecoration(
                      hintText: 'Search',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue[900])),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _isSearchingContacts == true ? filterdContacts.length :contacts.length,
                        itemBuilder: (context, index) {
                          Contact contact = _isSearchingContacts == true ? filterdContacts[index] : contacts[index];
                          return Card(
                            elevation: 5,
                            child: ListTile(
                                leading: (contact.avatar != null &&
                                        contact.avatar.length > 0)
                                    ? CircleAvatar(
                                        backgroundImage:
                                            MemoryImage(contact.avatar),
                                      )
                                    : CircleAvatar(
                                        child: Text(contact.initials()),
                                      ),
                                title: Text(contact.displayName),
                                subtitle: (contact.phones.length > 0)
                                    ? Text(contact.phones.elementAt(0).value)
                                    : null),
                          );
                        }),
                  ),
                ],
              ),
            ),
    );
  }
}
