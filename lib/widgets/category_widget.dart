import 'package:api_test/app_theme.dart';
import 'package:api_test/model/imat/product.dart';
import 'package:api_test/model/imat_data_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class CategoryWidget extends StatelessWidget {
  final String category;
  final List<ProductCategory> subCategories;
  final VoidCallback? onTextTap;
  final VoidCallback? onIconTap;

  const CategoryWidget({
    super.key,
    required this.category,
    required this.subCategories,
    this.onTextTap = _defaultTextTap,
    this.onIconTap = _defaultIconTap,
  });

  static void _defaultTextTap() {}
  static void _defaultIconTap() {}

  @override
  Widget build(BuildContext context) {
    final iMat = context.watch<ImatDataHandler>();

    return Row(
      children: [
        // Klickbar text
        Material(
          color: Colors.transparent,
          child:
          Expanded(
            
          child: InkWell(
            onTap: () => iMat.selectSelection(
              iMat.findProductsByCategory(subCategories),
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 0, 8),
              child: Text(
                category,
                style: AppTheme.textTheme.labelMedium,
              ),
            ),
          ),
        ),),

        // Visa ikon endast om det finns flera subkategorier
        if (subCategories.length > 1)
          InkWell(
            onTap: () => null,
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Icon(Icons.arrow_right, size: 30),
            ),
          ),
      ],
    );
  }
}