import 'dart:typed_data'; // Required for Uint8List

class Prescription {
  int? prescriptionId;
  int? userId;
  String? notes;
  Uint8List? prescImage; // Using Uint8List for BLOB data
  bool? deleteFlag;
  DateTime? lastUpdated;

  Prescription({
    this.prescriptionId,
    this.userId,
    this.notes,
    this.prescImage,
    this.deleteFlag,
    this.lastUpdated,
  });

  Map<String, dynamic> toMap() {
    return {
      'prescription_id': prescriptionId,
      'user_id': userId,
      'notes': notes,
      'presc_image': prescImage, // Directly storing Uint8List to BLOB
      'delete_flag': deleteFlag ?? false ? 1 : 0, // Convert bool to int for SQLite
      'last_updated': lastUpdated?.toIso8601String(),
    };
  }

  static Prescription fromMap(Map<String, dynamic> map) {
    return Prescription(
      prescriptionId: map['prescription_id'],
      userId: map['user_id'],
      notes: map['notes'],
      prescImage: map['presc_image'], // Assuming the database package handles BLOB to Uint8List conversion
      deleteFlag: map['delete_flag'] == 1, // Convert int back to bool
      lastUpdated: DateTime.tryParse(map['last_updated']),
    );
  }
}
