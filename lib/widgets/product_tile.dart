import 'package:api_test/app_theme.dart';
import 'package:api_test/model/imat/product.dart';
import 'package:api_test/model/imat/product_detail.dart';
import 'package:api_test/model/imat/shopping_item.dart';
import 'package:api_test/model/imat_data_handler.dart';
import 'package:api_test/widgets/buy_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductTile extends StatelessWidget {
  const ProductTile(this.product, {super.key});

  final Product product;

  @override
  Widget build(BuildContext context) {
    var iMat = Provider.of<ImatDataHandler>(context, listen: false);
    var isFavorite = iMat.isFavorite(product);
    ProductDetail? detail = iMat.getDetail(product);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.paddingSmall),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(child: iMat.getImage(product)),
            Text(
              product.name,
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Text(
              '${product.price} ${product.unit}',
              style: TextStyle(color: Colors.grey[700], fontSize: 12),
              textAlign: TextAlign.center,
            ),
            if (detail?.brand != null)
              Text(
                detail!.brand,
                style: TextStyle(color: Colors.grey[500], fontSize: 11),
                textAlign: TextAlign.center,
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    isFavorite ? Icons.star : Icons.star_border,
                    color: Colors.orange,
                    size: 20,
                  ),
                  onPressed: () => iMat.toggleFavorite(product),
                ),
                BuyButton(
                  onPressed: () => iMat.shoppingCartAdd(ShoppingItem(product)),
                  size: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _brand(Product product, context) {
    var iMat = Provider.of<ImatDataHandler>(context, listen: false);

    ProductDetail? detail = iMat.getDetail(product);

    if (detail != null) {
      return detail.brand;
    }
    return '';
  }

  Widget _favoriteButton(Product p, context) {
    var iMat = Provider.of<ImatDataHandler>(context, listen: false);
    var isFavorite = iMat.isFavorite(product);

    var icon =
        isFavorite
            ? Icon(Icons.star, color: Colors.orange)
            : Icon(Icons.star_border, color: Colors.orange);

    return IconButton(
      onPressed: () {
        iMat.toggleFavorite(product);
      },
      icon: icon,
    );
  }
}
