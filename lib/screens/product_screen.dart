import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import 'package:productos_app/providers/providers.dart';
import 'package:productos_app/services/services.dart';

import 'package:productos_app/ui/input_decorations.dart';
import 'package:productos_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productService = Provider.of<ProductsService>(context);

    return ChangeNotifierProvider(
        create: (_) => ProductFormProvider(productService.selectedProduct),
        child: _ProductsScreenBody(productService: productService));
  }
}

class _ProductsScreenBody extends StatelessWidget {
  const _ProductsScreenBody({
    Key? key,
    required this.productService,
  }) : super(key: key);

  final ProductsService productService;

  @override
  Widget build(BuildContext context) {
    final productForm = Provider.of<ProductFormProvider>(context);
    print('ProductScreen picture: ${productService.selectedProduct.picture}');
    return Scaffold(
      body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            children: [
              Stack(
                children: [
                  ProductImage(url: productService.selectedProduct.picture),
                  Positioned(
                      top: 60,
                      left: 20,
                      child: IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.arrow_back_ios_new,
                              size: 40, color: Colors.white))),
                  Positioned(
                      top: 60,
                      right: 20,
                      child: IconButton(
                          onPressed: () async {
                            final picker = ImagePicker();
                            final PickedFile? pickedFile =
                                await picker.getImage(
                                    source: ImageSource.camera,
                                    imageQuality: 100);

                            if (pickedFile == null) {
                              print('No seleccionó nada');
                              return;
                            }

                            print('Tenemos imagen ${pickedFile.path}');
                            productService
                                .updateSelectedPruductImage(pickedFile.path);
                          },
                          icon: const Icon(Icons.camera_alt_outlined,
                              size: 40, color: Colors.white)))
                ],
              ),
              const _ProductForm(),
              const SizedBox(height: 100)
            ],
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.save_alt_outlined),
          onPressed: () async {
            // TODO guardar producto
            if (!productForm.isValidForm()) return;

            await productService.saveOrCreateProduct(productForm.product);
          }),
    );
  }
}

class _ProductForm extends StatelessWidget {
  const _ProductForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productForm = Provider.of<ProductFormProvider>(context);
    final product = productForm.product;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          width: double.infinity,
          height: 264,
          decoration: _builBoxDecoration(),
          child: Form(
              key: productForm.formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(children: [
                const SizedBox(height: 10),
                TextFormField(
                    initialValue: product.name,
                    onChanged: (value) => product.name = value,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return "El nombre es obligatorio";
                    },
                    decoration: InputDecorations.authInputDecoration(
                        hintText: 'Nombre del producto', labelText: 'Nombre:')),
                const SizedBox(height: 30),
                TextFormField(
                    initialValue: '${product.price}',
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^(\d+)?\.?\d{0,2}'))
                    ],
                    onChanged: (value) => {
                          product.price = double.tryParse(value) == null
                              ? 0
                              : double.parse(value)
                        },
                    keyboardType: TextInputType.number,
                    decoration: InputDecorations.authInputDecoration(
                        hintText: '\$150', labelText: 'Precio:')),
                const SizedBox(height: 10),
                SwitchListTile(
                  value: product.available,
                  // onChanged: (value) => productForm.updateAvalilability(value),
                  onChanged: productForm.updateAvalilability,
                  activeColor: Colors.indigo,
                  title: const Text('Disponible'),
                ),
                const SizedBox(height: 20),
              ]))),
    );
  }

  BoxDecoration _builBoxDecoration() => BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(25),
              bottomLeft: Radius.circular(25)),
          boxShadow: [
            BoxShadow(
                color: Colors.white.withOpacity(0.05),
                offset: const Offset(0, 5),
                blurRadius: 5)
          ]);
}
