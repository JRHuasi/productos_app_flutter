import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
          margin: const EdgeInsets.only(top: 30, bottom: 50),
          width: double.infinity,
          height: 400,
          decoration: _cardBorders(),
          child: Stack(alignment: Alignment.bottomLeft, children: [
            _BackgroundImage(
              product.picture.toString(),
            ),
            _ProductDetails(product: product),
            Positioned(
                top: 0,
                right: 0,
                child: _PriceTag(
                  product: product,
                )),
            // TODO: mostrar de manera condicional
            Positioned(
                top: 0,
                left: 0,
                child: _NotAvailable(
                  available: product.available,
                )),
          ])),
    );
  }

  BoxDecoration _cardBorders() => BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          // ignore: prefer_const_literals_to_create_immutables
          boxShadow: [
            const BoxShadow(
                color: Colors.black38, offset: Offset(0, 7), blurRadius: 10)
          ]);
}

class _NotAvailable extends StatelessWidget {
  final bool available;

  const _NotAvailable({Key? key, required this.available}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        child: FittedBox(
          fit: BoxFit.contain,
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(available ? 'DISPONIBLE' : 'No Disponible',
                  style: const TextStyle(color: Colors.white, fontSize: 20))),
        ),
        width: 100,
        height: 70,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: available ? Colors.yellow[800] : Colors.red[800],
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(25),
                bottomRight: Radius.circular(25))));
  }
}

class _PriceTag extends StatelessWidget {
  final Product product;

  const _PriceTag({Key? key, required this.product}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        child: FittedBox(
          fit: BoxFit.contain,
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text('\$${product.price.toString()}',
                  style: const TextStyle(color: Colors.white, fontSize: 20))),
        ),
        width: 100,
        height: 70,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
            color: Colors.indigo,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(25),
                bottomLeft: Radius.circular(25))));
  }
}

class _ProductDetails extends StatelessWidget {
  final Product product;
  const _ProductDetails({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 50),
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          width: double.infinity,
          height: 70,
          decoration: _buldBoxDecoration(),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(product.id.toString(),
                    style: const TextStyle(fontSize: 15, color: Colors.white)),
              ])),
    );
  }

  BoxDecoration _buldBoxDecoration() => const BoxDecoration(
      color: Colors.indigo,
      borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25), topRight: Radius.circular(25)));
}

class _BackgroundImage extends StatelessWidget {
  final String? url;

  const _BackgroundImage(this.url);
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: SizedBox(
          width: double.infinity,
          height: 400,
          child: FadeInImage(
              placeholder: const AssetImage('assets/jar-loading.gif'),
              imageErrorBuilder:
                  (BuildContext context, Object object, starkTrace) {
                return const Image(
									image: AssetImage('assets/no-image.png'),
									fit: BoxFit.cover,
								);
              },
              image: NetworkImage(url!),
              fit: BoxFit.cover)),
    );
  }
}
