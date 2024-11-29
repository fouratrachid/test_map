import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/contact.dart';

class ContactsMapScreen extends StatefulWidget {
  final List<Contact> contacts;

  const ContactsMapScreen({super.key, required this.contacts});

  @override
  State<ContactsMapScreen> createState() => _ContactsMapScreenState();
}

class _ContactsMapScreenState extends State<ContactsMapScreen> {
  late GoogleMapController mapController;

  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _loadMarkers();
  }

  void _loadMarkers() {
    for (var contact in widget.contacts) {
      final marker = Marker(
        markerId: MarkerId(contact.idposition),
        position: LatLng(
          double.parse(contact.latitude),
          double.parse(contact.longitude),
        ),
        infoWindow: InfoWindow(
          title: contact.pseudo, // Display the contact's name
          snippet: 'Phone: ${contact.numero}', // Optional: Add the phone number
        ),
      );
      _markers.add(marker);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contacts Map')),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _markers.isNotEmpty
              ? _markers.first.position
              : const LatLng(0, 0), // Default position
          zoom: 10,
        ),
        markers: _markers,
        onMapCreated: (controller) => mapController = controller,
      ),
    );
  }
}
