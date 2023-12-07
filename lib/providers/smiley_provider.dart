import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

final StateNotifierProvider<SmileyNotifier, String> smileyProvider =
    StateNotifierProvider<SmileyNotifier, String>(
        (StateNotifierProviderRef<SmileyNotifier, String> ref) {
  return SmileyNotifier();
});

class SmileyNotifier extends StateNotifier<String> {
  SmileyNotifier() : super('facegrinregular');

  Future<void> changeSmiley(String smiley) async {
    state = smiley;
  }
}

enum Smileys {
  faceangryregular,
  facedizzyregular,
  faceflushedregular,
  facefrownopenregular,
  facefrownregular,
  facegrimaceregular,
  facegrinbeamregular,
  facegrinbeamsweatregular,
  facegrinheartsregular,
  facegrinregular,
  facegrinsquintregular,
  facegrinsquinttearsregular,
  facegrinstarsregular,
  facegrintearsregular,
  facegrintongueregular,
  facegrintonguesquintregular,
  facegrintonguewinkregular,
  facegrinwideregular,
  facegrinwinkregular,
  facekissbeamregular,
  facekissregular,
  facekisswinkheartregular,
  facelaughbeamregular,
  facelaughregular,
  facelaughsquintregular,
  facelaughwinkregular,
  facemehblankregular,
  facemehregular,
  facerollingeyesregular,
  facesadcryregular,
  facesadtearregular,
  facesmilebeamregular,
  facesmileregular,
  facesmilewinkregular,
  facesurpriseregular,
  facetiredregular,
  handpeaceregular,
  heartregular,
}

final Map<Smileys, FaIcon> smileyIcons = <Smileys, FaIcon>{
  Smileys.faceangryregular: const FaIcon(FontAwesomeIcons.faceAngry),
  Smileys.facedizzyregular: const FaIcon(FontAwesomeIcons.faceDizzy),
  Smileys.faceflushedregular: const FaIcon(FontAwesomeIcons.faceFlushed),
  Smileys.facefrownopenregular: const FaIcon(FontAwesomeIcons.faceFrownOpen),
  Smileys.facefrownregular: const FaIcon(FontAwesomeIcons.faceFrown),
  Smileys.facegrimaceregular: const FaIcon(FontAwesomeIcons.faceGrimace),
  Smileys.facegrinbeamregular: const FaIcon(FontAwesomeIcons.faceGrinBeam),
  Smileys.facegrinbeamsweatregular:
      const FaIcon(FontAwesomeIcons.faceGrinBeamSweat),
  Smileys.facegrinheartsregular: const FaIcon(FontAwesomeIcons.faceGrinHearts),
  Smileys.facegrinregular: const FaIcon(FontAwesomeIcons.faceGrin),
  Smileys.facegrinsquintregular: const FaIcon(FontAwesomeIcons.faceGrinSquint),
  Smileys.facegrinsquinttearsregular:
      const FaIcon(FontAwesomeIcons.faceGrinSquintTears),
  Smileys.facegrinstarsregular: const FaIcon(FontAwesomeIcons.faceGrinStars),
  Smileys.facegrintearsregular: const FaIcon(FontAwesomeIcons.faceGrinTears),
  Smileys.facegrintongueregular: const FaIcon(FontAwesomeIcons.faceGrinTongue),
  Smileys.facegrintonguesquintregular:
      const FaIcon(FontAwesomeIcons.faceGrinTongueSquint),
  Smileys.facegrintonguewinkregular: const FaIcon(
    FontAwesomeIcons.faceGrinTongueWink,
  ),
  Smileys.facegrinwideregular: const FaIcon(FontAwesomeIcons.faceGrinWide),
  Smileys.facegrinwinkregular: const FaIcon(FontAwesomeIcons.faceGrinWink),
  Smileys.facekissbeamregular: const FaIcon(FontAwesomeIcons.faceKissBeam),
  Smileys.facekissregular: const FaIcon(FontAwesomeIcons.faceKiss),
  Smileys.facekisswinkheartregular:
      const FaIcon(FontAwesomeIcons.faceKissWinkHeart),
  Smileys.facelaughbeamregular: const FaIcon(FontAwesomeIcons.faceLaughBeam),
  Smileys.facelaughregular: const FaIcon(FontAwesomeIcons.faceLaugh),
  Smileys.facelaughsquintregular:
      const FaIcon(FontAwesomeIcons.faceLaughSquint),
  Smileys.facelaughwinkregular: const FaIcon(FontAwesomeIcons.faceLaughWink),
  Smileys.facemehblankregular: const FaIcon(FontAwesomeIcons.faceMehBlank),
  Smileys.facemehregular: const FaIcon(FontAwesomeIcons.faceMeh),
  Smileys.facerollingeyesregular:
      const FaIcon(FontAwesomeIcons.faceRollingEyes),
  Smileys.facesadcryregular: const FaIcon(FontAwesomeIcons.faceSadCry),
  Smileys.facesadtearregular: const FaIcon(FontAwesomeIcons.faceSadTear),
  Smileys.facesmilebeamregular: const FaIcon(FontAwesomeIcons.faceSmileBeam),
  Smileys.facesmileregular: const FaIcon(FontAwesomeIcons.faceSmile),
  Smileys.facesmilewinkregular: const FaIcon(FontAwesomeIcons.faceSmileWink),
  Smileys.facesurpriseregular: const FaIcon(FontAwesomeIcons.faceSurprise),
  Smileys.facetiredregular: const FaIcon(FontAwesomeIcons.faceTired),
  Smileys.handpeaceregular: const FaIcon(FontAwesomeIcons.handPeace),
  Smileys.heartregular: const FaIcon(FontAwesomeIcons.heart),
};
