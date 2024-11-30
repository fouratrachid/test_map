import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_animate/flutter_animate.dart';
import 'package:test_map/screens/contatcs_list_screen.dart';
import 'dart:async';
import 'dart:convert';
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
  bool _isAddingContact = false;
  LatLng? _newContactPosition;

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
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
        infoWindow: InfoWindow(
          title: contact.pseudo,
          snippet: "ID: ${contact.idposition}\nNote: ${contact.numero}",
          onTap: () => _showContactDetails(contact),
        ),
      );
      _markers.add(marker);
    }
  }

  void _showContactDetails(Contact contact) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple[400]!, Colors.deepPurple[600]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              const BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  contact.pseudo,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                _buildDetailRow('ID Position', contact.idposition),
                _buildDetailRow('Longitude', contact.longitude),
                _buildDetailRow('Latitude', contact.latitude),
                _buildDetailRow('Note', contact.numero),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    // Optionally implement delete or edit functionality
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit Location'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: const TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _onMapTapped(LatLng position) {
    if (_isAddingContact) {
      setState(() {
        _newContactPosition = position;
      });
      _showAddContactSheet();
    }
  }

  void _showAddContactSheet() {
    final nameController = TextEditingController();
    final noteController = TextEditingController();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Colors.grey[100]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              const BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Add a Location',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple[800],
                  ),
                ),
                const SizedBox(height: 16),
                _buildCustomTextField(
                  controller: nameController,
                  label: 'Name',
                  icon: Icons.person,
                ),
                const SizedBox(height: 12),
                _buildCustomTextField(
                  controller: noteController,
                  label: 'Note',
                  icon: Icons.note_add,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    final name = nameController.text.trim();
                    final note = noteController.text.trim();

                    if (name.isNotEmpty && note.isNotEmpty) {
                      _addContactToBackend(name, note);
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Please fill in all fields'),
                          backgroundColor: Colors.red[400],
                        ),
                      );
                    }
                  },
                  child: const Text('Add Location'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCustomTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.deepPurple),
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
        ),
      ),
    );
  }

  Future<void> _addContactToBackend(String pseudo, String numero) async {
    if (_newContactPosition == null) return;

    final response = await http.get(
      Uri.parse(
          'http://192.168.1.190/servicephp/add_position.php?longitude=${_newContactPosition!.longitude}&latitude=${_newContactPosition!.latitude}&numero=$numero&pseudo=$pseudo'),
    );

    if (response.statusCode == 200) {
      final marker = Marker(
        markerId: MarkerId(DateTime.now().toIso8601String()),
        position: _newContactPosition!,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
        infoWindow: InfoWindow(
          title: pseudo,
          snippet: 'Note: $numero',
        ),
      );

      setState(() {
        _markers.add(marker);
        _isAddingContact = false;
        _newContactPosition = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Location added successfully!'),
          backgroundColor: Colors.green[600],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Failed to add location'),
          backgroundColor: Colors.red[600],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ContactListScreen()));
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        title: const Text(
          'Locations Map',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
        backgroundColor: Colors.deepPurple[600],
        centerTitle: true,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        actions: [
          IconButton(
            icon: _isAddingContact
                ? Icon(
                    Icons.cancel,
                    color: Colors.red[400],
                  )
                : const Icon(Icons.add_location, color: Colors.white),
            tooltip: _isAddingContact ? 'Cancel Add' : 'Add Location',
            onPressed: () {
              setState(() {
                _isAddingContact = !_isAddingContact;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      _isAddingContact
                          ? 'Tap on the map to add a location'
                          : 'Add location mode disabled',
                    ),
                    backgroundColor: _isAddingContact
                        ? Colors.deepPurple[600]
                        : Colors.grey[700],
                  ),
                );
              });
            },
          ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _markers.isNotEmpty
              ? _markers.first.position
              : const LatLng(0, 0),
          zoom: 10,
        ),
        markers: _markers,
        onTap: _onMapTapped,
        onMapCreated: (controller) => mapController = controller,
        mapType: MapType.normal,
        compassEnabled: true,
        mapToolbarEnabled: true,
      ),
    );
  }
}
