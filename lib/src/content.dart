import 'package:piecemeal/piecemeal.dart';

import 'engine/core/game.dart';
import 'engine/stage/stage.dart';
import 'engine/unit/research.dart';
import 'content/research/topics.dart';
import 'content/stage/map.dart';

Content createContent() {
  ResearchTopics.initialize();

  return GameContent();
}

class GameContent implements Content {
  @override
  void buildStage(Research research, Stage stage, Function(Vec) placeCity) {
    return World(stage).buildStage(placeCity);
  }

  @override
  Iterable<ResearchTopic> get researchTopics => ResearchTopics.topics;

}