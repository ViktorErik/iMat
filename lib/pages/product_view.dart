import 'package:api_test/app_theme.dart';
import 'package:api_test/model/imat/product.dart';
import 'package:api_test/model/imat/product_detail.dart';
import 'package:api_test/model/imat/shopping_item.dart';
import 'package:api_test/model/imat/util/functions.dart';
import 'package:api_test/model/imat_data_handler.dart';
import 'package:api_test/pages/account_view.dart';
import 'package:api_test/pages/history_view.dart';
import 'package:api_test/pages/main_view.dart';
import 'package:api_test/widgets/buy_button.dart';
import 'package:api_test/widgets/cart_view.dart';
import 'package:api_test/widgets/minus_button.dart';
import 'package:api_test/widgets/product_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/category_widget.dart';
import '../widgets/checkout_wizard.dart';

class SearchWidget extends StatefulWidget{
  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context){
    var iMat = context.watch<ImatDataHandler>();
    return SizedBox(
      width: 500,
      child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(36),
      ),
      child: TextFormField(
        controller: _searchController,
        onFieldSubmitted: (value){
          iMat.selectSelection(iMat.findProducts(_searchController.text));
          
        },
        decoration: InputDecoration(
          hintText: 'Sök efter vara',
          suffixIcon: IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              //sök-funktion
              iMat.selectSelection(iMat.findProducts(_searchController.text));
            },
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(36),
          ),
          contentPadding: EdgeInsets.fromLTRB(18, 0, 0, 0)
        ),
      ),
    ),
    );
  }
  

  

}
class ProductView extends StatelessWidget {
  final Product product;
  const ProductView({super.key, required this.product});
  
  @override
  Widget build(BuildContext context) {
    var iMat = context.watch<ImatDataHandler>();
    var products = iMat.selectProducts;
    

    return Scaffold(
      
      body: Column(
        children: [
          
          // SizedBox(height: AppTheme.paddingLarge),
          _header(context, iMat),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // _leftPanel(iMat),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:[
                      /*
                      SizedBox(height: AppTheme.paddingTiny),
                      Align(alignment: Alignment.center,
                        child:
                        SizedBox( width: 500,  
                          child: 
                            SearchWidget()
                        ),
                      ),*/
                      SizedBox(height: AppTheme.paddingTiny),
                      Container(
                        //width: 580,
                        height: 593,
                        child: _centerStage(context, products),
                      ),
                      
                    ]
                  )
                ),
                Container(
                  width: 300,
                  //color: Colors.blueGrey,
                  child: _shoppingCart(iMat, context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _shoppingCart(ImatDataHandler iMat, BuildContext context) {
    return Container(
      color: const Color.fromARGB(100, 205, 195, 183),
      child: Column(
        children: [
          Text(
            'Kundvagn',
            style: AppTheme.textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Expanded( // Gör CartView flexibel så den tar all tillgänglig plats
            child: CartView(),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SizedBox(
              width: double.infinity, // Tar hela bredden
              height: 54, // Gör knappen större
              child: ElevatedButton(
                onPressed: () {
                  if (iMat.getShoppingCart().items.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Lägg till varor i kundvagnen för att betala!")),
                    );
                    return;
                  }

                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    builder: (_) => ChangeNotifierProvider.value(
                      value: iMat,
                      child: const CheckoutWizard(),
                    ),
                  );
                },
                child: Text('Köp!', style: AppTheme.textTheme.titleMedium,),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container _leftPanel(ImatDataHandler iMat) {
    return Container(
      width: 300,
      color: AppTheme.colorScheme.secondary,
      child: Scrollbar(thickness: 1,
        child: Padding(padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
          child:
          ListView(
            children: [
              SizedBox(height: AppTheme.paddingSmall),
              SizedBox(height: AppTheme.paddingSmall),
              CategoryWidget(category: "VISA ALLT",
                subCategories: [],onTextTap: iMat.selectAllProducts,),
              SizedBox(height: AppTheme.paddingSmall),
              CategoryWidget(category: "DRINKS",
                subCategories: [ProductCategory.COLD_DRINKS, ProductCategory.HOT_DRINKS,],),
              SizedBox(height: AppTheme.paddingSmall),
              CategoryWidget(category: "FRUIT",
                subCategories: [ProductCategory.FRUIT, ProductCategory.CITRUS_FRUIT, ProductCategory.EXOTIC_FRUIT, ProductCategory.BERRY, ProductCategory.MELONS],),
              SizedBox(height: AppTheme.paddingSmall),
              CategoryWidget(category: "VEGETABLES",
                subCategories: [ProductCategory.CABBAGE, ProductCategory.HERB, ProductCategory.POD, ProductCategory.VEGETABLE_FRUIT],),
              SizedBox(height: AppTheme.paddingSmall),
              CategoryWidget(category: "MEAT",
                subCategories: [ProductCategory.MEAT, ProductCategory.FISH],),


            ],
          ),
        ),),
    );
  }

  Container _header(BuildContext context, ImatDataHandler iMat) {
    return Container(
      height: 80,
      color: AppTheme.colorScheme.primary,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // ElevatedButton(onPressed: () {}, child: Text('iMat')),
          // Image(image: AssetImage("assets/images/iMat.png")),
          Row(
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => MainView()),
                      (route) => false,
                    );
                  },
                  child: Image.asset('assets/images/imat.png')                  
                ),
              ),
              SizedBox(width: 220),
              ElevatedButton(//favorit-knapp
              style: ElevatedButton.styleFrom(minimumSize: Size(200,54),
              backgroundColor: Colors.white),
                onPressed: () {
                  //print('Favoriter');
                  iMat.selectFavorites();
                },
                
                child: Row(
                  children: [
                    Icon(Icons.star, size: AppTheme.textTheme.headlineMedium!.fontSize,),
                    Text('Favoriter', style: AppTheme.textTheme.headlineMedium),
                  ]
                )
              ),
              SizedBox(width: AppTheme.paddingMedium),
              ElevatedButton(//history-knapp
              style: ElevatedButton.styleFrom(minimumSize: Size(200,54),
              backgroundColor: Colors.white),
                onPressed: () {
                  dbugPrint('Historik-knapp');
                  _showHistory(context);
                },
                child: Row(
                  children: [
                    Icon(Icons.hourglass_full, size: AppTheme.textTheme.headlineMedium!.fontSize,),
                    Text('Historik', style: AppTheme.textTheme.headlineMedium),
                  ]
                )
              ),
              SizedBox(width: AppTheme.paddingMedium),
              SearchWidget(),
            ],
          ),
  
          Row(
            children: [
              
              ElevatedButton(//användare-knapp
              style: ElevatedButton.styleFrom(minimumSize: Size(200,54),
              backgroundColor: Colors.white),
                onPressed: () {
                  _showAccount(context);
                },
                child: Row(
                  children: [
                    Icon(Icons.elderly_woman, size: AppTheme.textTheme.headlineMedium!.fontSize,),
                    Text('Användare', style: AppTheme.textTheme.headlineMedium),
                  ]
                )
              ),
              SizedBox(width: AppTheme.paddingSmall,)
            ],
          ),
        ],
      ),
    );
  }

  Widget _centerStage(BuildContext context, List<Product> products) {
    // ListView.builder has the advantage that tiles
    // are built as needed.
    var iMat = Provider.of<ImatDataHandler>(context, listen: false);
    var details = iMat.getDetailWithId(product.productId);
    return Row(
      
      children: [
        Expanded(
          flex: 6,
          
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Tillbaka', style: TextStyle(fontSize: AppTheme.textTheme.headlineMedium!.fontSize),),
              ),
              Center(
                //mainAxisAlignment: MainAxisAlignment.center,
                //crossAxisAlignment: CrossAxisAlignment.center,
                child:
                Padding(
                  padding: EdgeInsets.all(16), // Padding runt bilden
                  child: iMat.getImage(product),
                ),
              ),
              
              Center(
              child: ElevatedButton(                
                style: ElevatedButton.styleFrom(minimumSize:Size(0, 48), backgroundColor: iMat.isFavorite(product) ? const Color.fromARGB(255, 255, 177, 177) : Colors.white),
                onPressed: () => {
                  iMat.toggleFavorite(product),

                },
                
                child: Text(iMat.isFavorite(product)? "Ta bort som favorit" : "Lägg till som favorit", style: TextStyle(color: Colors.black, fontSize: AppTheme.textTheme.headlineMedium!.fontSize
                )),
              ),
              ),
            ],
          ),
        ),

        // Vertikalt streck
        Container(
          width: 1,
          color: Colors.grey[300],
          margin: EdgeInsets.symmetric(vertical: 16),
        ),

        Expanded(
          flex: 4,
          child: Padding(
            padding: EdgeInsets.all(16), // Padding runt texten
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name, style: AppTheme.textTheme.headlineLarge),
                SizedBox(height: 4),
                Text(details!.description, style: AppTheme.textTheme.bodyLarge),
                Text("${product.price}${product.unit}", style: AppTheme.textTheme.labelLarge),
                if(iMat.getShoppingCart().itemIsInCart(product))
                  Container(width: 110, decoration:  BoxDecoration(borderRadius: BorderRadius.circular(20), color: AppTheme.colorScheme.primary,),
                    
                    child:Row(
                    children:[
                      MinusButton(
                        onPressed: () => iMat.shoppingCartRemove1(ShoppingItem(product)),
                        size: 20,
                      ),
                      Container(width: 30, height: 30, alignment: Alignment.center ,decoration:BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.white), 
                        child:
                        Text("${iMat.getShoppingCart().getAmountInCart(product)}"),
                      ),
                      BuyButton(
                        onPressed: () => iMat.shoppingCartAdd(ShoppingItem(product)),
                        size: 20,
                      ),
                    ]
                  ),),
                if(!iMat.getShoppingCart().itemIsInCart(product))
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(minimumSize:Size(0, 48), backgroundColor: Colors.white),
                    onPressed: () => iMat.shoppingCartAdd(ShoppingItem(product)),
                    child:Text("Lägg till i varukorg", style: TextStyle(fontSize: AppTheme.textTheme.headlineMedium!.fontSize),)

                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showAccount(context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AccountView()),
    );
  }

  void _showHistory(context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HistoryView()),
    );
  }
}
