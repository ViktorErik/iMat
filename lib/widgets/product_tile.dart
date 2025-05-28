import 'package:api_test/app_theme.dart';
import 'package:api_test/model/imat/product.dart';
import 'package:api_test/model/imat/product_detail.dart';
import 'package:api_test/model/imat/shopping_cart.dart';
import 'package:api_test/model/imat/shopping_item.dart';
import 'package:api_test/model/imat_data_handler.dart';
import 'package:api_test/pages/product_view.dart';
import 'package:api_test/widgets/buy_button.dart';
import 'package:api_test/widgets/clickable_text.dart';
import 'package:api_test/widgets/minus_button.dart';
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
            Stack(alignment: Alignment.topRight,
              children:[
              Expanded(child: 
                    iMat.getImage(product)),
              IconButton(
              icon: Icon(
                isFavorite ? Icons.star : Icons.star_border,
                color: Colors.orange,
                size: 30,
                ),
                onPressed: () => iMat.toggleFavorite(product),
              ),
            ]),
            ClickableText(
              text:product.name,
              onTap:() => _showProduct(context, product),
              
            ),
            Text(
              '${product.price} ${product.unit}',
              style: TextStyle(color: Colors.grey[700], fontSize: 18),
              textAlign: TextAlign.center,
            ),
            if (detail?.brand != null)
              Text(
                detail!.brand,
                style: TextStyle(color: Colors.grey[500], fontSize: 12),
                textAlign: TextAlign.center,
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              
              children: [
                if(iMat.getShoppingCart().itemIsInCart(product))
                  Row(
                    children:[
                      MinusButton(
                        onPressed: () => iMat.shoppingCartRemove1(ShoppingItem(product)),
                        size: 20,
                      ),
                      Text("${iMat.getShoppingCart().getAmountInCart(product)}"),
                      BuyButton(
                        onPressed: () => iMat.shoppingCartAdd(ShoppingItem(product)),
                        size: 20,
                      ),
                    ]
                  ),
                if(!iMat.getShoppingCart().itemIsInCart(product))
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(minimumSize:Size(0, 48), backgroundColor: Colors.white),
                    onPressed: () => iMat.shoppingCartAdd(ShoppingItem(product)),
                    child:Text("Lägg till")

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

  void _showProduct(context, Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProductView(product: product)),
    );
  }
}
