import 'package:api_test/app_theme.dart';
import 'package:api_test/model/imat/order.dart';
import 'package:api_test/model/imat/shopping_item.dart';
import 'package:api_test/model/imat/util/functions.dart';
import 'package:api_test/model/imat_data_handler.dart';
import 'package:api_test/pages/account_view.dart';
import 'package:api_test/pages/main_view.dart';
import 'package:api_test/widgets/card_details.dart';
import 'package:api_test/widgets/customer_details.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// Stateful eftersom man behöver komma ihåg vilken order som är vald
// När den valda ordern ändras så ritas gränssnittet om pga
// anropet till setState
class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  Order? _selectedOrder;

  @override
  Widget build(BuildContext context) {
    // Provider.of eftersom denna vy inte behöver veta något om
    // ändringar i iMats data. Den visar bara det som finns nu
    // final TextEditingController searchController;
    final searchController = TextEditingController();
    var iMat = Provider.of<ImatDataHandler>(context, listen: false);

    // Hämta datan som ska visas
    var orders = iMat.orders;

    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _header(context),
          Expanded(
            child: Row(
              children: [
                SizedBox(
                  width: 300,
                  //height: 600,
                  // Creates the list to the left.
                  // When a user taps on an item the function _selectOrder is called
                  // The Material widget is need to make hovering pliancy effects visible
                  child: Material(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    child: _ordersList(context, orders, _selectOrder),
                  ),
                ),
                // Creates the view to the right showing the
                // currently selected order.
                Expanded(child: _orderDetails(_selectedOrder)),


                Padding(
              padding: EdgeInsets.all(AppTheme.paddingSmall),
              child: Align(
              alignment: Alignment.topRight,
              child: ElevatedButton( //Tillbaka knapp
              style: ElevatedButton.styleFrom(fixedSize: Size(135,50),
              backgroundColor: const Color.fromARGB(255, 235, 232, 232)),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => MainView()),
                      (route) => false,
                    );
                },
                
                child: Row(
                  children: [
                    Text("Tillbaka", style: AppTheme.textTheme.headlineMedium, textAlign: TextAlign.center,),
                  ]
                )
                ))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _header(BuildContext context) {
    var iMat = context.watch<ImatDataHandler>();
    final searchController = TextEditingController();
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
              //Image.asset('assets/images/imat.png'),
              ElevatedButton(//favorit-knapp
              style: ElevatedButton.styleFrom(minimumSize: Size(200,54),
              backgroundColor: Colors.white),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => MainView()),
                      (route) => false,
                    );
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
              SearchWidget(controller: searchController,),
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

  Widget _customerDetails() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            color: Color.fromARGB(255, 154, 172, 134),
            child: CustomerDetails(),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Container(
            color: Color.fromARGB(255, 154, 172, 134),
            child: CardDetails(),
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

  Widget _ordersList(BuildContext context, List<Order> orders, Function onTap) {
    Iterable<Order> reversedOrders = orders.reversed;
    return ListView(
      children: [for (final order in reversedOrders) _orderInfo(order, onTap)],
    );
  }

  Widget _orderInfo(Order order, Function onTap) {
    return ListTile(
      onTap: () => onTap(order),
      title: Text(style: AppTheme.textTheme.labelMedium, 'Order ${order.orderNumber}, Antal varor:${order.items.length}, ${_formatDateTime(order.date)}'),
    );
  }

  Widget _orderItem(ShoppingItem item) {
    var iMat = Provider.of<ImatDataHandler>(context, listen: false);
    return ListTile(tileColor: Colors.white,
      title: 
          Text(style: AppTheme.textTheme.labelLarge,item.product.name), 
      leading: Text(style: AppTheme.textTheme.labelLarge, "${item.amount}st"),
      trailing: iMat.getImage(item.product),
    );
  }

  _selectOrder(Order order) {
    setState(() {
      //dbugPrint('select order ${order.orderNumber}');
      _selectedOrder = order;
    });
  }

  // This uses the package intl
  String _formatDateTime(DateTime dt) {
    final formatter = DateFormat('yyyy-MM-dd, HH:mm');
    return formatter.format(dt);
  }

  // THe view to the right.
  // When the history is shown the first time
  // order will be null.
  // In the null case the function returns SizedBox.shrink()
  // which is a what to use to create an empty widget.
  Widget _orderDetails(Order? order) {
    if (order != null) {
      return Column(
        children: [
          Text(
            'Order ${order.orderNumber}',
            style: Theme.of(context).textTheme.headlineMedium,
          ),      
          SizedBox(height: AppTheme.paddingSmall),
          SizedBox(height: 400, child:
            ListView(children:[for (final item in order.items) _orderItem(item)]),
          ),
          SizedBox(height: AppTheme.paddingSmall),
          Text(
            'Totalt: ${order.getTotal().toStringAsFixed(2)}kr',
            style: AppTheme.textTheme.headlineSmall,
          ),
        ],
      );
    }
    return SizedBox.shrink();
  }
}
