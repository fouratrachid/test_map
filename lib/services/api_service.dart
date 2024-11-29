// lib/api_service.dart

import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

import '../models/contact.dart';

class ApiService {
  final String baseUrl = 'http://192.168.1.190/servicephp/get_all.php'; // http://192.168.4.180/servicephp/get_all.php

  Future<List<Contact>> fetchContacts() async {
    final response = await http.get(Uri.parse(baseUrl));
    print("error ");
    print(response.body);
    print(response.statusCode);

    print(response.request);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(data);
      if (data['success'] == 1) {
        List<Contact> contacts = [];
        for (var item in data['positions']) {
          contacts.add(Contact.fromJson(item));
        }
        log(contacts.toString());
        return contacts;
      } else {
        throw Exception('Failed to load contacts');
      }
    } else {
      throw Exception('Failed to load contacts');
    }
  }
}
