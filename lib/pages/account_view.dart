import 'package:api_test/app_theme.dart';
import 'package:api_test/model/imat/util/functions.dart';
import 'package:api_test/model/imat_data_handler.dart';
import 'package:api_test/pages/history_view.dart';
import 'package:api_test/pages/main_view.dart';
import 'package:api_test/widgets/card_details.dart';
import 'package:api_test/widgets/customer_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountView extends StatelessWidget {
  const AccountView({super.key});
  
  @override
  Widget build(BuildContext context) {
  return Scaffold(
    body: Column(
      children: [
        _header(context), // No padding here
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 200),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(AppTheme.paddingMedium),
                    child: Column(
                      children: [
                            Align(alignment: Alignment.centerLeft,
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
              )),
                        Text(style: AppTheme.textTheme.headlineLarge, "Profil"),
                        Text(
                          style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 77, 76, 76)),
                          "Hantera dina uppgifter",
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppTheme.paddingMedium),
                  _customerDetails(),
                ],
              ),
            ),
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
    return 
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
      children: [
            Text(style:AppTheme.textTheme.headlineMedium, "Leverans och kontaktuppgifter"),
            SizedBox(height: AppTheme.paddingMediumSmall),
            CustomerDetails(),
            SizedBox(height: AppTheme.paddingMediumSmall),
            Text(style:AppTheme.textTheme.headlineMedium, "Betalningsinformation"),
            SizedBox(height: AppTheme.paddingMediumSmall),
            CardDetails(),      
            SizedBox(height: 40)
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
      MaterialPageRoute(builder: (context) => HistoryView())
    );
  }


  


}
