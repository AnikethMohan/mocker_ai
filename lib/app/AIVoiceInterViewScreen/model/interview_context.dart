class InterviewMemory {
  List<String> askedQuestions = [];
  List<String> userResponses = [];
  Set<String> coveredTopics = {};
  String lastTopic = "";
  bool shouldWrapUp = false;

  Map<String, dynamic> toJson() => {
    "askedQuestions": askedQuestions,
    "userResponses": userResponses,
    "coveredTopics": coveredTopics.toList(),
    "lastTopic": lastTopic,
    "shouldWrapUp": shouldWrapUp,
  };
}

class InterviewAnalysis {
  final double? overAllPerformance;
  final double? clarity;
  final double? depth;
  final double? structure;
  final List<String>? keyStrengths;
  final List<String>? areasToImprove;
  final int? numberOfQuestionsAnswered;
  final double? averageResponseLength;
  final double? completionRate;

  InterviewAnalysis({
    this.overAllPerformance,
    this.clarity,
    this.depth,
    this.structure,
    this.keyStrengths,
    this.areasToImprove,
    this.numberOfQuestionsAnswered,
    this.averageResponseLength,
    this.completionRate,
  });

  factory InterviewAnalysis.fromJson(Map<String, dynamic> json) {
    return InterviewAnalysis(
      overAllPerformance: (json['overAllPerformance'] as num).toDouble(),
      clarity: (json['clarity'] as num).toDouble(),
      depth: (json['depth'] as num).toDouble(),
      structure: (json['structure'] as num).toDouble(),
      keyStrengths: List<String>.from(json['keyStrengths'] ?? []),
      areasToImprove: List<String>.from(json['areasToImprove'] ?? []),
      numberOfQuestionsAnswered: json['numberOfQuestionsAnswered'] ?? 0,
      averageResponseLength: (json['averageResponseLength'] as num).toDouble(),
      completionRate: (json['completionRate'] as num).toDouble(),
    );
  }
}
