class InterviewResponse {
  final String? response;
  final bool? isInterviewFinished;

  InterviewResponse({
    this.response,
    this.isInterviewFinished,
  });

  factory InterviewResponse.fromJson(Map<String, dynamic> json) {
    return InterviewResponse(
      response: json['response'] as String?,
      isInterviewFinished: json['isInterviewFinished'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'response': response,
      'isInterviewFinished': isInterviewFinished,
    };
  }
}
