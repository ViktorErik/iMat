import 'package:api_test/app_theme.dart';
import 'package:api_test/model/imat/product.dart';
import 'package:api_test/model/imat/product_detail.dart';
import 'package:api_test/model/imat/util/functions.dart';
import 'package:api_test/model/imat_data_handler.dart';
import 'package:api_test/pages/account_view.dart';
import 'package:api_test/pages/history_view.dart';
import 'package:api_test/pages/product_view.dart';
import 'package:api_test/widgets/cart_view.dart';
import 'package:api_test/widgets/category_widget.dart';
import 'package:api_test/widgets/product_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
class MainView extends StatelessWidget {
  const MainView({super.key});
  
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
                      Container(
                        //width: 580,
                        height: 645,
                        child: _centerStage(context, products),
                      ),
                      
                    ]
                  )
                ),
                Container(
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
          Container(height: 400, child: CartView()),
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
              //Image.asset('assets/images/imat.png'),
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
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(AppTheme.paddingMedium, 0, AppTheme.paddingSmall,AppTheme.paddingSmall),
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: AppTheme.paddingMedium,
        mainAxisSpacing:  AppTheme.paddingMedium,
        childAspectRatio: 0.7,
      ),
      itemBuilder: (BuildContext context, int index) {
        return ProductTile(products[index]);
      },
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
