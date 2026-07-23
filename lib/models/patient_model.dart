class PatientModel {
  String? id;
  String name;
  String? rg;
  DateTime? birthDate;
  String? gender;
  String? maritalStatus;
  String? phone;
  String? address;
  String? education;
  String? profession;
  String? workTime;

  PatientModel({
    this.id,
    required this.name,
    this.rg,
    this.birthDate,
    this.gender,
    this.maritalStatus,
    this.phone,
    this.address,
    this.education,
    this.profession,
    this.workTime,
  });

  // Calculate age based on birthDate
  int? get age {
    if (birthDate == null) return null;
    final today = DateTime.now();
    int calculatedAge = today.year - birthDate!.year;
    if (today.month < birthDate!.month ||
        (today.month == birthDate!.month && today.day < birthDate!.day)) {
      calculatedAge--;
    }
    return calculatedAge;
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'rg': rg,
      'birthDate': birthDate?.toIso8601String(),
      'gender': gender,
      'maritalStatus': maritalStatus,
      'phone': phone,
      'address': address,
      'education': education,
      'profession': profession,
      'workTime': workTime,
    };
  }

  factory PatientModel.fromMap(Map<String, dynamic> map, String documentId) {
    return PatientModel(
      id: documentId,
      name: map['name'] ?? '',
      rg: map['rg'],
      birthDate: map['birthDate'] != null ? DateTime.tryParse(map['birthDate']) : null,
      gender: map['gender'],
      maritalStatus: map['maritalStatus'],
      phone: map['phone'],
      address: map['address'],
      education: map['education'],
      profession: map['profession'],
      workTime: map['workTime'],
    );
  }
}
