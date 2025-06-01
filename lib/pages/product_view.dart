import 'package:api_test/app_theme.dart';
import 'package:api_test/model/imat/product.dart';
import 'package:api_test/model/imat/shopping_item.dart';
import 'package:api_test/model/imat/util/functions.dart';
import 'package:api_test/model/imat_data_handler.dart';
import 'package:api_test/pages/account_view.dart';
import 'package:api_test/pages/history_view.dart';
import 'package:api_test/pages/main_view.dart';
import 'package:api_test/widgets/buy_button.dart';
import 'package:api_test/widgets/cart_view.dart';
import 'package:api_test/widgets/minus_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchWidget extends StatefulWidget{
  const SearchWidget({super.key});

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
                _leftPanel(iMat),
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
                      SizedBox(
                        //width: 580,
                        height: 593,
                        child: _centerStage(context, products),
                      ),
                      
                    ]
                  )
                ),
                SizedBox(
                  width: 300,
                  //color: Colors.blueGrey,
                  child: _shoppingCart(iMat),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _shoppingCart(ImatDataHandler iMat) {
    return Container(color: Color.fromARGB(100, 205, 195, 183),
      child:
        Column(
        children: [
          Text(style:AppTheme.textTheme.headlineMedium,'Kundvagn'),
          SizedBox(height: 400, child: CartView()),
          ElevatedButton(
            onPressed: () {
              iMat.placeOrder();
            },
            child: Text('Köp!'),
          ),
        ],
      ),
    );
  }

  Container _leftPanel(ImatDataHandler iMat) {
    return Container(
      width: 300,
      color: AppTheme.colorScheme.primary,
      child: Column(
        children: [
          SizedBox(height: AppTheme.paddingSmall),
          SizedBox(
            width: 132,
            child: ElevatedButton(
              onPressed: () {
                iMat.selectAllProducts();
              },
              child: Text('Visa allt'),
            ),
          ),
          SizedBox(height: AppTheme.paddingSmall),
          
          SizedBox(height: AppTheme.paddingSmall),
          SizedBox(
            width: 132,
            child: ElevatedButton(
              onPressed: () {
                var products = iMat.products;
                iMat.selectSelection([
                  products[4],
                  products[45],
                  products[68],
                  products[102],
                  products[110],
                ]);
              },
              child: Text('Urval'),
            ),
          ),
          SizedBox(height: AppTheme.paddingSmall),
          SizedBox(
            width: 132,
            child: ElevatedButton(
              onPressed: () {
                //print('Frukt');
                iMat.selectSelection(
                  iMat.findProductsByCategory([ProductCategory.CABBAGE, ProductCategory.HERB, ProductCategory.POD, ProductCategory.VEGETABLE_FRUIT])
                );
              },
              child: Text('Grönsaker'),
            ),
          ),
          SizedBox(height: AppTheme.paddingSmall),
          SizedBox(
            width: 132,
            child: ElevatedButton(
              onPressed: () {
                //print('Söktest');
                iMat.selectSelection(iMat.findProducts('mj'));
              },
              child: Text('Söktest'),
            ),
          ),
        ],
      ),
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
                    iMat.selectAllProducts();
                  },
                  child: Image.asset('assets/images/imat.png')
                ),
              ),
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
                child: Text('Tillbaka'),
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
                    child:Text("Lägg till")

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
