import 'package:flutter/material.dart';
import 'package:quran_tracing/models/users_model.dart';
import 'package:url_launcher/url_launcher.dart';

class UserItem extends StatelessWidget {
  const UserItem({Key? key, required this.color, required this.user})
      : super(key: key);

  final Color color;
  final User user;

  @override
  Widget build(BuildContext context) {
    Future<void> _launchInBrowser(String url) async {
      if (url.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('URL is empty'),
          ),
        );
        return;
      }

      if (!await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      )) {
        throw Exception('Could not launch $url');
      }
    }

    String url =
        user.username != null ? "https://telegram.me/${user.username}" : "";
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: color,
              child: Text(user.tgFirstName != null ? user.tgFirstName![0] : ''),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    user.tgFirstName ?? '',
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    user.username ?? '',
                    style: Theme.of(context).textTheme.caption!.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    user.id ?? '',
                    style: Theme.of(context).textTheme.caption!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.telegram),
              onPressed: () {
                _launchInBrowser(url);
              },
            ),
          ],
        ),
      ),
    );
  }
}
