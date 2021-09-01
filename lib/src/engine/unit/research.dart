import 'package:xenops/src/content/research/topics.dart';
import 'package:xenops/src/engine/unit/unitType.dart';

class Research {
  final Map<ResearchTopic, int> _researchedTopics;
  final Map<ResearchTopic, bool> _unlockedTopics;
  final List<ResearchTopic> _completedTopics;

  Research() : this.from({}, {}, []);

  Research.from(this._unlockedTopics, this._researchedTopics, this._completedTopics);

  void unlockTier(int tier) {
    ResearchTopics.topics.forEach((element) { 
      if (element.tierLevel == tier) unlockTopic(element); 
    });
  }

  void unlockTopic(ResearchTopic topic) {
    _unlockedTopics.putIfAbsent(topic, () => true);
    _unlockedTopics[topic] = true;
  }

  void researchTopic(ResearchTopic topic) {
    _researchedTopics.putIfAbsent(topic, () => 0);  // start researching if needed
    _researchedTopics[topic] = _researchedTopics[topic]! + 1; // advance research

    if (_researchedTopics[topic]! >= topic.cost) {  // research is finished
      _completedTopics.add(topic);
      _researchedTopics.remove(topic);
    }
  }

  Iterable<ResearchTopic> get unlockedTopics => _unlockedTopics.keys.where((element) => _unlockedTopics[element]!);

  Iterable<ResearchTopic> get incompleteTopics => _unlockedTopics.keys.where((element) => !_completedTopics.contains(element));

  int? progress(ResearchTopic topic) => _researchedTopics[topic];

  bool completed(ResearchTopic topic) => _completedTopics.contains(topic);

  bool unlocked(ResearchTopic topic) => _unlockedTopics[topic]!;

  Research clone() => Research.from(Map.of(_unlockedTopics), Map.of(_researchedTopics), List.of(_completedTopics));
}

class ResearchTopic {
  final String name;
  final int cost;
  final UnitType result;
  final int tierLevel;

  ResearchTopic(this.name, this.cost, this.result, this.tierLevel);
}