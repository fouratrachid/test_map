// lib/contact.dart

class Contact {
  final String idposition;
  final String pseudo;
  final String numero;
  final String longitude;
  final String latitude;

  Contact({
    required this.idposition,
    required this.pseudo,
    required this.numero,
    required this.longitude,
    required this.latitude,
  });

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      idposition: json['idposition'] ,
      pseudo: json['pseudo'],
      numero: json['numero'],
      longitude: json['longitude'] ,
      latitude: json['latitude'] ,
    );
  }
}
