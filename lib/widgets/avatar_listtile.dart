import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getsh_tdone/theme/theme.dart';

class AvatarListTile extends StatelessWidget {
  const AvatarListTile({
    required this.assetPath,
    super.key,
    this.ref,
  });

  final String assetPath;
  final WidgetRef? ref;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: flexSchemeLight.primary,
          width: 2.0,
        ),
      ),
      child: CircleAvatar(
        backgroundImage: AssetImage(assetPath),
      ),
    );
  }
}
