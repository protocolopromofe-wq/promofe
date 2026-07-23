class EvaluationModel {
  String? id;
  String patientId;
  DateTime date;
  
  // Dados Brutos da Seção 2 (Anamnese)
  Map<String, dynamic> section2Data;

  // Dados Brutos e Escores da Seção 3 (0-24)
  Map<String, dynamic> section3Data;
  int section3Score;
  
  // Dados Brutos e Escores da Seção 4 (0-71)
  Map<String, dynamic> section4Data;
  int section4Score;
  
  // Fotos da Seção 5
  List<String> photoUrls;

  // Dados Brutos e Escores da Seção 6 (0-4)
  Map<String, dynamic> section6Data;
  int section6Score;

  // Dados Brutos da Seção 7 (Expectativas)
  Map<String, dynamic> section7Data;

  EvaluationModel({
    this.id,
    required this.patientId,
    required this.date,
    Map<String, dynamic>? section2Data,
    Map<String, dynamic>? section3Data,
    this.section3Score = 0,
    Map<String, dynamic>? section4Data,
    this.section4Score = 0,
    this.photoUrls = const [],
    Map<String, dynamic>? section6Data,
    this.section6Score = 0,
    Map<String, dynamic>? section7Data,
  }) : section2Data = section2Data ?? {},
       section3Data = section3Data ?? {},
       section4Data = section4Data ?? {},
       section6Data = section6Data ?? {},
       section7Data = section7Data ?? {};

  Map<String, dynamic> toMap() {
    return {
      'patientId': patientId,
      'date': date.toIso8601String(),
      'section2Data': section2Data,
      'section3Data': section3Data,
      'section3Score': section3Score,
      'section4Data': section4Data,
      'section4Score': section4Score,
      'photoUrls': photoUrls,
      'section6Data': section6Data,
      'section6Score': section6Score,
      'section7Data': section7Data,
    };
  }

  factory EvaluationModel.fromMap(Map<String, dynamic> map, String documentId) {
    return EvaluationModel(
      id: documentId,
      patientId: map['patientId'] ?? '',
      date: DateTime.parse(map['date']),
      section2Data: Map<String, dynamic>.from(map['section2Data'] ?? {}),
      section3Data: Map<String, dynamic>.from(map['section3Data'] ?? {}),
      section3Score: map['section3Score']?.toInt() ?? 0,
      section4Data: Map<String, dynamic>.from(map['section4Data'] ?? {}),
      section4Score: map['section4Score']?.toInt() ?? 0,
      photoUrls: List<String>.from(map['photoUrls'] ?? []),
      section6Data: Map<String, dynamic>.from(map['section6Data'] ?? {}),
      section6Score: map['section6Score']?.toInt() ?? 0,
      section7Data: Map<String, dynamic>.from(map['section7Data'] ?? {}),
    );
  }

  void calculateSection6Score() {
    int total = 0;
    if (section6Data['appearance_score'] != null) total += section6Data['appearance_score'] as int;
    if (section6Data['confidence_impact_score'] != null) total += section6Data['confidence_impact_score'] as int;
    if (section6Data['age_perception_score'] != null) total += section6Data['age_perception_score'] as int;
    section6Score = total;
  }
}
