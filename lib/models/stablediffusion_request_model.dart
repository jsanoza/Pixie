class StableDiffusion {
  final String key;
  final String prompt;
  final String? negativePrompt;
  final String initImage;
  final String width;
  final String height;
  final String samples;
  final String numInferenceSteps;
  final double guidanceScale;
  final String safetyChecker;
  final double strength;
  final String? seed;
  final String? webhook;
  final String? trackId;

  StableDiffusion({
    required this.key,
    required this.prompt,
    this.negativePrompt,
    required this.initImage,
    required this.width,
    required this.height,
    required this.samples,
    required this.numInferenceSteps,
    required this.guidanceScale,
    required this.safetyChecker,
    required this.strength,
    this.seed,
    this.webhook,
    this.trackId,
  });

  factory StableDiffusion.fromJson(Map<String, dynamic> json) {
    return StableDiffusion(
      key: json['key'],
      prompt: json['prompt'],
      negativePrompt: json['negative_prompt'],
      initImage: json['init_image'],
      width: json['width'],
      height: json['height'],
      samples: json['samples'],
      numInferenceSteps: json['num_inference_steps'],
      guidanceScale: json['guidance_scale'],
      safetyChecker: json['safety_checker'],
      strength: json['strength'],
      seed: json['seed'],
      webhook: json['webhook'],
      trackId: json['track_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['prompt'] = this.prompt;
    data['negative_prompt'] = this.negativePrompt;
    data['init_image'] = this.initImage;
    data['width'] = this.width;
    data['height'] = this.height;
    data['samples'] = this.samples;
    data['num_inference_steps'] = this.numInferenceSteps;
    data['guidance_scale'] = this.guidanceScale;
    data['safety_checker'] = this.safetyChecker;
    data['strength'] = this.strength;
    data['seed'] = this.seed;
    data['webhook'] = this.webhook;
    data['track_id'] = this.trackId;
    return data;
  }
}
