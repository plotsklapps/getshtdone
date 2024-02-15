import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getsh_tdone/providers/photourl_provider.dart';
import 'package:getsh_tdone/theme/theme.dart';

final StateProvider<IconData> smileyProvider =
    StateProvider<IconData>((StateProviderRef<IconData> ref) {
  // Fetch the photoURL from Firebase Auth.
  final String smileyKey = ref.watch(photoURLProvider);
  // Return the corresponding IconData from the smileyIcons map, or the default
  // smiley icon if the smileyKey is not found.
  return smileyIcons[smileyKey] ?? FontAwesomeIcons.faceAngry;
});

class SmileyIconRow extends ConsumerWidget {
  const SmileyIconRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final IconData selectedSmiley = ref.watch(smileyProvider);
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
          itemCount: smileyIcons.length,
          itemBuilder: (BuildContext context, int index) {
            final String smileyKey = smileyIcons.keys.elementAt(index);
            final IconData? icon = smileyIcons[smileyKey];
            return GestureDetector(
              onTap: () {
                // Change the IconData
                ref.read(smileyProvider.notifier).state =
                    smileyIcons[smileyIcons.keys.elementAt(index)]!;
                // Change the photoURL
                ref.read(photoURLProvider.notifier).state =
                    smileyIcons.keys.elementAt(index);
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  decoration: BoxDecoration(
                    color: icon == selectedSmiley
                        ? sIsDark.value
                            ? cFlexSchemeDark().primary
                            : cFlexSchemeLight().primary
                        : null,
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  child: FaIcon(
                    icon,
                    size: 48.0,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

final Map<String, IconData> smileyIcons = <String, IconData>{
  'faceangryregular': FontAwesomeIcons.faceAngry,
  'facedizzyregular': FontAwesomeIcons.faceDizzy,
  'faceflushedregular': FontAwesomeIcons.faceFlushed,
  'facefrownopenregular': FontAwesomeIcons.faceFrownOpen,
  'facefrownregular': FontAwesomeIcons.faceFrown,
  'facegrimaceregular': FontAwesomeIcons.faceGrimace,
  'facegrinbeamregular': FontAwesomeIcons.faceGrinBeam,
  'facegrinbeamsweatregular': FontAwesomeIcons.faceGrinBeamSweat,
  'facegrinheartsregular': FontAwesomeIcons.faceGrinHearts,
  'facegrinregular': FontAwesomeIcons.faceGrin,
  'facegrinsquintregular': FontAwesomeIcons.faceGrinSquint,
  'facegrinsquinttearsregular': FontAwesomeIcons.faceGrinSquintTears,
  'facegrinstarsregular': FontAwesomeIcons.faceGrinStars,
  'facegrintearsregular': FontAwesomeIcons.faceGrinTears,
  'facegrintongueregular': FontAwesomeIcons.faceGrinTongue,
  'facegrintonguesquintregular': FontAwesomeIcons.faceGrinTongueSquint,
  'facegrintonguewinkregular': FontAwesomeIcons.faceGrinTongueWink,
  'facegrinwideregular': FontAwesomeIcons.faceGrinWide,
  'facegrinwinkregular': FontAwesomeIcons.faceGrinWink,
  'facekissbeamregular': FontAwesomeIcons.faceKissBeam,
  'facekissregular': FontAwesomeIcons.faceKiss,
  'facekisswinkheartregular': FontAwesomeIcons.faceKissWinkHeart,
  'facelaughbeamregular': FontAwesomeIcons.faceLaughBeam,
  'facelaughregular': FontAwesomeIcons.faceLaugh,
  'facelaughsquintregular': FontAwesomeIcons.faceLaughSquint,
  'facelaughwinkregular': FontAwesomeIcons.faceLaughWink,
  'facemehblankregular': FontAwesomeIcons.faceMehBlank,
  'facemehregular': FontAwesomeIcons.faceMeh,
  'facerollingeyesregular': FontAwesomeIcons.faceRollingEyes,
  'facesadcryregular': FontAwesomeIcons.faceSadCry,
  'facesadtearregular': FontAwesomeIcons.faceSadTear,
  'facesmilebeamregular': FontAwesomeIcons.faceSmileBeam,
  'facesmileregular': FontAwesomeIcons.faceSmile,
  'facesmilewinkregular': FontAwesomeIcons.faceSmileWink,
  'facesurpriseregular': FontAwesomeIcons.faceSurprise,
  'facetiredregular': FontAwesomeIcons.faceTired,
  'handpeaceregular': FontAwesomeIcons.handPeace,
  'heartregular': FontAwesomeIcons.heart,
};
