import 'package:coastrial/models/chatcompletion_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('ChatCompletion toJson() and fromJson() should work', () {
    final chatCompletion = ChatCompletion(
      id: 'chatcmpl-6p9XYPYSTTRi0xEviKjjilqrWU2Ve',
      object: 'chat.completion',
      created: 1677649420,
      model: 'gpt-3.5-turbo',
      usage: Usage(
        promptTokens: 56,
        completionTokens: 31,
        totalTokens: 87,
      ),
      choices: [
        Choices(
          message: Message(
            role: 'assistant',
            content: 'The 2020 World Series was played in Arlington, Texas at the Globe Life Field, which was the new home stadium for the Texas Rangers.',
          ),
          finishReason: 'stop',
          index: 0,
        ),
      ],
    );

    final json = chatCompletion.toJson();
    final decoded = ChatCompletion.fromJson(json);

    expect(decoded.id, chatCompletion.id);
    expect(decoded.object, chatCompletion.object);
    expect(decoded.created, chatCompletion.created);
    expect(decoded.model, chatCompletion.model);
    expect(decoded.usage.promptTokens, chatCompletion.usage.promptTokens);
    expect(decoded.usage.completionTokens, chatCompletion.usage.completionTokens);
    expect(decoded.usage.totalTokens, chatCompletion.usage.totalTokens);
    expect(decoded.choices.length, chatCompletion.choices.length);
    expect(decoded.choices[0].message.role, chatCompletion.choices[0].message.role);
    expect(decoded.choices[0].message.content, chatCompletion.choices[0].message.content);
    expect(decoded.choices[0].finishReason, chatCompletion.choices[0].finishReason);
    expect(decoded.choices[0].index, chatCompletion.choices[0].index);
  });
}
