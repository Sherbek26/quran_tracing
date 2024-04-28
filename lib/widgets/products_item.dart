import 'package:flutter/material.dart';
import 'package:quran_tracing/models/products_model.dart';
import 'package:transparent_image/transparent_image.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({
    Key? key,
    required this.product,
    required this.onDelete,
  }) : super(key: key);

  final Product product;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: () {
        _showPopupMenu(context, product.id!);
      },
      child: ListTile(
        leading: FadeInImage(
          placeholder: MemoryImage(kTransparentImage),
          image: const AssetImage(
              "assets/images/login_image.png"), // Assuming 'image' property holds the URL of the product image
          width: 70,
          height: 70,
          fit: BoxFit.cover,
        ),
        title: Text(
          product.name!,
          style: Theme.of(context).textTheme.subtitle1!.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onBackground),
          softWrap: true,
        ),
        subtitle: Text(
          '${product.price} so`m',
          style: Theme.of(context)
              .textTheme
              .bodyText2!
              .copyWith(color: Theme.of(context).colorScheme.onBackground),
        ),
        trailing: OutlinedButton(
          onPressed: () {},
          child: Text(
            product.type == 'special' ? "Maxsus" : "Oddiy",
            style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
          ),
        ),
      ),
    );
  }

  void _showPopupMenu(BuildContext context, String productId) {
    final RenderBox itemBox = context.findRenderObject() as RenderBox;
    final Offset itemOffset = itemBox.localToGlobal(Offset.zero);

    // Adjust the y-coordinate by adding some offset
    final offsetY = itemOffset.dy + itemBox.size.height;
    showMenu<int>(
      context: context,
      position: RelativeRect.fromLTRB(itemOffset.dx, offsetY, 0, 0),
      items: [
        _buildPopupMenuItem(context, "O'chirish", Icons.delete, 1),
      ],
    ).then(
      (value) async {
        if (value == 1) {
          final bool? confirm = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                  'Confirm Delete',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                ),
                content: Text(
                  'Are you sure you want to delete this product?',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false); // Dismiss the dialog
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: onDelete,
                    child: const Text('Delete'),
                  ),
                ],
              );
            },
          );
          return confirm ?? false; // Return false if user cancels
        } else {}
      },
    );
  }
}

PopupMenuItem<int> _buildPopupMenuItem(
    BuildContext context, String title, IconData iconData, int value) {
  return PopupMenuItem<int>(
    value: value, // Assign a unique value for each item
    child: Column(
      children: [
        Row(
          children: [
            Icon(
              iconData,
              color: Theme.of(context).colorScheme.secondary,
            ),
            const SizedBox(width: 8), // Add some space between icon and text
            Text(
              title,
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
          ],
        ),
      ],
    ),
  );
}
