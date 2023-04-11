class ChatCompletion {
  ChatCompletion({
    required this.id,
    required this.object,
    required this.created,
    required this.model,
    required this.usage,
    required this.choices,
  });
  late final String id;
  late final String object;
  late final int created;
  late final String model;
  late final Usage usage;
  late final List<Choices> choices;
  
  ChatCompletion.fromJson(Map<String, dynamic> json){
    id = json['id'];
    object = json['object'];
    created = json['created'];
    model = json['model'];
    usage = Usage.fromJson(json['usage']);
    choices = List.from(json['choices']).map((e)=>Choices.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['object'] = object;
    _data['created'] = created;
    _data['model'] = model;
    _data['usage'] = usage.toJson();
    _data['choices'] = choices.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Usage {
  Usage({
    required this.promptTokens,
    required this.completionTokens,
    required this.totalTokens,
  });
  late final int promptTokens;
  late final int completionTokens;
  late final int totalTokens;
  
  Usage.fromJson(Map<String, dynamic> json){
    promptTokens = json['prompt_tokens'];
    completionTokens = json['completion_tokens'];
    totalTokens = json['total_tokens'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['prompt_tokens'] = promptTokens;
    _data['completion_tokens'] = completionTokens;
    _data['total_tokens'] = totalTokens;
    return _data;
  }
}

class Choices {
  Choices({
    required this.message,
    required this.finishReason,
    required this.index,
  });
  late final Message message;
  late final String finishReason;
  late final int index;
  
  Choices.fromJson(Map<String, dynamic> json){
    message = Message.fromJson(json['message']);
    finishReason = json['finish_reason'];
    index = json['index'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['message'] = message.toJson();
    _data['finish_reason'] = finishReason;
    _data['index'] = index;
    return _data;
  }
}

class Message {
  Message({
    required this.role,
    required this.content,
  });
  late final String role;
  late final String content;
  
  Message.fromJson(Map<String, dynamic> json){
    role = json['role'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['role'] = role;
    _data['content'] = content;
    return _data;
  }
}