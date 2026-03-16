class SddMetric {
  final String id;
  final String name;
  final String module;
  final double coverage;

  SddMetric({
    required this.id,
    required this.name,
    required this.module,
    required this.coverage,
  });

  factory SddMetric.fromJson(Map<String, dynamic> json) {
    return SddMetric(
      id: json['id'].toString(),
      name: json['name']?.toString() ?? 'Unknown Name',
      module: json['module']?.toString() ?? 'Unknown Module',
      coverage: double.tryParse(json['coverage'].toString()) ?? 0.0,
    );
  }
}