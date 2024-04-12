import 'package:astroguide_flutter/pages/providers/profile_provider.dart';
import 'package:astroguide_flutter/utils/screen_size.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileImage extends StatelessWidget {
  final List<String> avatars;
  const ProfileImage({
    super.key,
    required this.avatars,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ScreenSize.width,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(
                top: ScreenSize.absoluteHeight * 0.03, bottom: 3),
            child: CircleAvatar(
              radius: ScreenSize.absoluteHeight * 0.08,
              backgroundImage: AssetImage(
                avatars[context.watch<ProfileProvider>().currentImageIndex],
              ),
            ),
          ),
          Positioned(
            top: ScreenSize.absoluteHeight * 0.012,
            right: ScreenSize.width * 0.31,
            child: IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    surfaceTintColor: Colors.white,
                    title: const Text(
                      'Selecciona tu avatar',
                      textAlign: TextAlign.center,
                    ),
                    content: SizedBox(
                      width: double.infinity,
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 10,
                        runSpacing: 10,
                        children: avatars.map(
                          (avatar) {
                            final index = avatars.indexOf(avatar);
                            return GestureDetector(
                              onTap: () {
                                context
                                    .read<ProfileProvider>()
                                    .updateImage(index);
                                Navigator.of(context).pop();
                              },
                              child: CircleAvatar(
                                radius: ScreenSize.absoluteHeight * 0.043,
                                backgroundImage: AssetImage(avatar),
                              ),
                            );
                          },
                        ).toList(),
                      ),
                    ),
                  ),
                );
              },
              icon: Icon(
                Icons.edit_square,
                color: Colors.black,
                size: ScreenSize.absoluteHeight * 0.032,
              ),
            ),
          )
        ],
      ),
    );
  }
}
