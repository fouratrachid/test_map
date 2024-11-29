import 'package:flutter/material.dart';
import '../models/contact.dart';
import '../services/api_service.dart';
import 'contacts_map_screen.dart';

class ContactListScreen extends StatefulWidget {
  const ContactListScreen({super.key});

  @override
  _ContactListScreenState createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  late Future<List<Contact>> futureContacts;

  @override
  void initState() {
    super.initState();
    futureContacts = ApiService().fetchContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contacts')),
      body: FutureBuilder<List<Contact>>(
        future: futureContacts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No contacts found'));
          }

          final contacts = snapshot.data!;

          return ListView.builder(
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              final contact = contacts[index];
              return ListTile(
                title: Text(contact.pseudo),
                subtitle: Text(contact.numero),
              );
            },
          );
        },
      ),
      floatingActionButton: FutureBuilder<List<Contact>>(
        future: futureContacts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.hasError) {
            return const SizedBox.shrink(); // No button if data isn't ready
          }

          final contacts = snapshot.data ?? [];
          return FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ContactsMapScreen(contacts: contacts),
                ),
              );
            },
            child: const Icon(Icons.map),
          );
        },
      ),
    );
  }
}
