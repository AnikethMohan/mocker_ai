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
