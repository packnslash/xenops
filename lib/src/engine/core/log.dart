class Log {
  static const _maxMessages = 20;
  final messages = <Message>[];

  void message(String message) {
    add(LogType.message, message);
  }

  void error(String message) {
    add(LogType.error, message);
  }

  void help(String message) {
    add(LogType.help, message);
  }

  void add(LogType type, String message) {
    if (messages.isNotEmpty) {
      var last = messages.last;
      if (last.text == message) {
        last.count++;
        return;
      }
    }

    messages.add(Message(type, message));
    if (messages.length > _maxMessages) messages.removeAt(0);
  }
}

enum LogType {
  message, error, help
}

class Message {
  final LogType type;
  final String text;

  int count = 1;

  Message(this.type, this.text);
}