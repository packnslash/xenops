import '../../engine/unit/research.dart';
import '../../engine/unit/unitType.dart';
import 'builder.dart';

void phaseOne() {
  topic('Mining', 3)..tier(0)..result(UnitType.scout);
  topic('Taming', 3).tier(0);
  topic('Farming', 3).tier(0);
  topic('Sailing', 3).tier(0);
  finishTopic();
}

class ResearchTopics {
  static final List<ResearchTopic> topics = [];

  static void initialize() {
    phaseOne();
  }
}