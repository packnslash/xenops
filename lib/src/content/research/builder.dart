import 'package:xenops/src/engine/unit/unitType.dart';

import '../../engine/unit/research.dart';
import 'topics.dart';

_ResearchTopicBuilder? _builder;

void finishTopic() {
  var builder = _builder;
  if (builder == null) return;

  var topic = builder.build();

  ResearchTopics.topics.add(topic);
  
  _builder = null;
}

_ResearchTopicBuilder topic(String name, int cost, [UnitType? result]) {
  finishTopic();
  
  var builder = _ResearchTopicBuilder(name, cost, result);
  _builder = builder;
  return builder;
}

class _ResearchTopicBuilder {
  final String _name;
  final int _cost;

  UnitType? _result;
  int? _tierLevel;
  bool? _oneOff;

  _ResearchTopicBuilder(this._name, this._cost, this._result);

  void tier(int level) {
    _tierLevel = level;
  }

  void result(UnitType res) {
    _result = res;
  }

  void oneOff(bool set) {
    _oneOff = set;
  }

  ResearchTopic build() {
    return ResearchTopic(_name, _cost, _result ?? UnitType.none, _tierLevel ?? 0, _oneOff ?? false);
  }
}