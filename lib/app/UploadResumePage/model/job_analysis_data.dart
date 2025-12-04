class JobAnalysisResult {
  final String? targetRole;
  final List<String>? requiredSkillsIdentified;
  final double? resumeMatchScore; // Percentage from 0.0 to 100.0
  final String? tip;

  JobAnalysisResult({
    this.targetRole,
    this.requiredSkillsIdentified,
    this.resumeMatchScore,
    this.tip,
  });

  factory JobAnalysisResult.fromJson(Map<String, dynamic> json) {
    return JobAnalysisResult(
      targetRole: json['targetRole'] as String?,
      requiredSkillsIdentified:
          (json['requiredSkillsIdentified'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList(),
      resumeMatchScore: (json['resumeMatchScore'] as num?)?.toDouble(),
      tip: json['tip'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'targetRole': targetRole,
      'requiredSkillsIdentified': requiredSkillsIdentified,
      'resumeMatchScore': resumeMatchScore,
      'tip': tip,
    };
  }
}
