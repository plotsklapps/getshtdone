import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

final StateProvider<IconData?> smileyIconProvider =
    StateProvider<IconData?>((StateProviderRef<IconData?> ref) {
  return smileyIcons[Smileys.faceangryregular];
});

final StateProvider<String> smileyProvider =
    StateProvider<String>((StateProviderRef<String> ref) {
  return Smileys.faceangryregular.toString();
});

class SmileyIconRow extends ConsumerWidget {
  const SmileyIconRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 50.0,
      child: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(
          dragDevices: <PointerDeviceKind>{
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
            PointerDeviceKind.trackpad,
            PointerDeviceKind.stylus,
          },
        ),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: Smileys.values.length,
          itemBuilder: (BuildContext context, int index) {
            final Smileys smiley = Smileys.values[index];
            final IconData? icon = smileyIcons[smiley];
            return GestureDetector(
              onTap: () {
                // Change the IconData
                ref.read(smileyIconProvider.notifier).state = icon;
                // Change the IconString (for Firestore)
                ref.read(smileyProvider.notifier).state = smiley.toString();
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: FaIcon(icon, size: 48.0),
              ),
            );
          },
        ),
      ),
    );
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

final Map<Smileys, IconData> smileyIcons = <Smileys, IconData>{
  Smileys.faceangryregular: FontAwesomeIcons.faceAngry,
  Smileys.facedizzyregular: FontAwesomeIcons.faceDizzy,
  Smileys.faceflushedregular: FontAwesomeIcons.faceFlushed,
  Smileys.facefrownopenregular: FontAwesomeIcons.faceFrownOpen,
  Smileys.facefrownregular: FontAwesomeIcons.faceFrown,
  Smileys.facegrimaceregular: FontAwesomeIcons.faceGrimace,
  Smileys.facegrinbeamregular: FontAwesomeIcons.faceGrinBeam,
  Smileys.facegrinbeamsweatregular: FontAwesomeIcons.faceGrinBeamSweat,
  Smileys.facegrinheartsregular: FontAwesomeIcons.faceGrinHearts,
  Smileys.facegrinregular: FontAwesomeIcons.faceGrin,
  Smileys.facegrinsquintregular: FontAwesomeIcons.faceGrinSquint,
  Smileys.facegrinsquinttearsregular: FontAwesomeIcons.faceGrinSquintTears,
  Smileys.facegrinstarsregular: FontAwesomeIcons.faceGrinStars,
  Smileys.facegrintearsregular: FontAwesomeIcons.faceGrinTears,
  Smileys.facegrintongueregular: FontAwesomeIcons.faceGrinTongue,
  Smileys.facegrintonguesquintregular: FontAwesomeIcons.faceGrinTongueSquint,
  Smileys.facegrintonguewinkregular: FontAwesomeIcons.faceGrinTongueWink,
  Smileys.facegrinwideregular: FontAwesomeIcons.faceGrinWide,
  Smileys.facegrinwinkregular: FontAwesomeIcons.faceGrinWink,
  Smileys.facekissbeamregular: FontAwesomeIcons.faceKissBeam,
  Smileys.facekissregular: FontAwesomeIcons.faceKiss,
  Smileys.facekisswinkheartregular: FontAwesomeIcons.faceKissWinkHeart,
  Smileys.facelaughbeamregular: FontAwesomeIcons.faceLaughBeam,
  Smileys.facelaughregular: FontAwesomeIcons.faceLaugh,
  Smileys.facelaughsquintregular: FontAwesomeIcons.faceLaughSquint,
  Smileys.facelaughwinkregular: FontAwesomeIcons.faceLaughWink,
  Smileys.facemehblankregular: FontAwesomeIcons.faceMehBlank,
  Smileys.facemehregular: FontAwesomeIcons.faceMeh,
  Smileys.facerollingeyesregular: FontAwesomeIcons.faceRollingEyes,
  Smileys.facesadcryregular: FontAwesomeIcons.faceSadCry,
  Smileys.facesadtearregular: FontAwesomeIcons.faceSadTear,
  Smileys.facesmilebeamregular: FontAwesomeIcons.faceSmileBeam,
  Smileys.facesmileregular: FontAwesomeIcons.faceSmile,
  Smileys.facesmilewinkregular: FontAwesomeIcons.faceSmileWink,
  Smileys.facesurpriseregular: FontAwesomeIcons.faceSurprise,
  Smileys.facetiredregular: FontAwesomeIcons.faceTired,
  Smileys.handpeaceregular: FontAwesomeIcons.handPeace,
  Smileys.heartregular: FontAwesomeIcons.heart,
};
