import 'package:xenops/src/content/research/topics.dart';
import 'package:xenops/src/engine/unit/unitType.dart';

class Research {
  final Map<ResearchTopic, int> _researchedTopics;
  final List<ResearchTopic> _unlockedTopics;
  final List<ResearchTopic> _completedTopics;

  Research() : this.from([], {}, []);

  Research.from(this._unlockedTopics, this._researchedTopics, this._completedTopics);

  void unlockTier(int tier) {
    ResearchTopics.topics.forEach((element) { 
      if (element.tierLevel == tier) unlockTopic(element); 
    });
  }

  void unlockTopic(ResearchTopic topic) {
    if (!_unlockedTopics.contains(topic)) {
      _unlockedTopics.add(topic);
    }
  }

  bool researchTopic(ResearchTopic topic) {
    _researchedTopics.putIfAbsent(topic, () => 0);  // start researching if needed
    _researchedTopics[topic] = _researchedTopics[topic]! + 1; // advance research

    if (_researchedTopics[topic]! >= topic.cost) {  // research is finished
      if (!topic.oneOff) {
        _completedTopics.add(topic);
      }
      _researchedTopics.remove(topic);
      
      return true;
    }

    return false;
  }

  void resetTopic(ResearchTopic topic) {
    _researchedTopics.remove(topic);
  }

  Iterable<ResearchTopic> get unlockedTopics => _unlockedTopics;

  Iterable<ResearchTopic> get incompleteTopics => _unlockedTopics.where((element) => !_completedTopics.contains(element));

  int? progress(ResearchTopic topic) => _researchedTopics[topic];

  bool completed(ResearchTopic topic) => _completedTopics.contains(topic);

  bool unlocked(ResearchTopic topic) => _unlockedTopics.contains(topic);

  Research clone() => Research.from(List.of(_unlockedTopics), Map.of(_researchedTopics), List.of(_completedTopics));
}

class ResearchTopic {
  final String name;
  final int cost;
  final UnitType result;
  final int tierLevel;
  final bool oneOff;

  ResearchTopic(this.name, this.cost, this.result, this.tierLevel, this.oneOff);
}