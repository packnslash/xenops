import '../../engine/unit/research.dart';
import '../../engine/unit/unitType.dart';
import 'builder.dart';

void phaseOne() {
  topic('Scout', 2)..tier(0)..result(UnitType.scout)..oneOff(true);

  finishTopic();
}

class ResearchTopics {
  static final List<ResearchTopic> topics = [];

  static void initialize() {
    phaseOne();
  }
}