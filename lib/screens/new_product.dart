import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quran_tracing/models/created_product_model.dart';
import 'package:quran_tracing/widgets/image_upload.dart';

class NewProduct extends StatefulWidget {
  const NewProduct({Key? key, required this.onAddProduct}) : super(key: key);
  final void Function(CreatedProduct createdProduct) onAddProduct;

  @override
  _NewProductState createState() => _NewProductState();
}

class _NewProductState extends State<NewProduct> {
  bool? uploaded;
  String? nameController;
  int? priceController;
  String? imageController;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Types _selectedType = Types.special;

  void _submitNewProduct() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      if (nameController != null &&
          priceController != null &&
          imageController != null) {
        widget.onAddProduct(CreatedProduct(
            name: nameController,
            price: priceController,
            image: imageController,
            type: _selectedType.name,
            isActive: true,
            admin: "",
            id: "",
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            v: 0));
      }
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 42),
        child: Column(
          children: [
            Text("Maxsulotni qo'shish",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 32),
            ImageUpload(
              '',
              uploaded: (isUploaded, imageName) {
                setState(() {
                  uploaded = isUploaded;
                  imageController = imageName;
                });
              },
            ),
            const SizedBox(
              height: 12,
            ),
            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Nomi',
              ),
              style:
                  TextStyle(color: Theme.of(context).colorScheme.onBackground),
              validator: (value) {
                if (value == null ||
                    value.isEmpty ||
                    value.trim().length <= 1 ||
                    value.trim().length > 50) {
                  return "Iltimos, maxsulot nomini to'g'ri kiriting";
                }
                return null;
              },
              onSaved: (newValue) => nameController = newValue,
            ),
            const SizedBox(
              height: 12,
            ),
            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Narxi',
              ),
              style:
                  TextStyle(color: Theme.of(context).colorScheme.onBackground),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null ||
                    value.isEmpty ||
                    int.tryParse(value) == null) {
                  return "Iltimos, maxsulot nomini to'g'ri kiriting";
                }
                return null;
              },
              onSaved: (newValue) => priceController = int.tryParse(newValue!),
            ),
            const SizedBox(
              height: 12,
            ),
            Row(
              children: [
                DropdownButton(
                  value: _selectedType,
                  items: Types.values
                      .map(
                        (type) => DropdownMenuItem(
                          value: type,
                          child: Text(
                            type.name == 'special' ? "Maxsus" : "Oddiy",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }
                    setState(() {
                      _selectedType = value;
                    });
                  },
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Bekor qilish'),
                ),
                ElevatedButton(
                  onPressed: _submitNewProduct,
                  child: const Text('Saqlash'),
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}


// CupertinoButton(
//               onPressed: () async {
//                 if (formKey.currentState!.validate()) {
//                   formKey.currentState!.save();
//                   if (nameController != null &&
//                       priceController != null &&
//                       imageController != null &&
//                       selectedType != null) {
//                     await createNewProduct(imageController!, nameController!,
//                         priceController!, selectedType!);
//                   }
//                 }
//               },
//               child: const Text(
//                 'Save',
//                 style: TextStyle(fontSize: 24),
//               ),
//             )