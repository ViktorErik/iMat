import 'package:api_test/app_theme.dart';
import 'package:api_test/model/imat/product.dart';
import 'package:api_test/model/imat_data_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class CategoryWidget extends StatefulWidget {
  final String category;
  final List<ProductCategory> subCategories;
  final VoidCallback? onTextTap;
  final VoidCallback? onIconTap;
  final int depth;

  const CategoryWidget({
    super.key,
    required this.category,
    required this.subCategories,
    this.onTextTap,
    this.onIconTap,
    this.depth = 0,
  });

  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget>
    with TickerProviderStateMixin {
  bool _showSubcategories = false;

  @override
  Widget build(BuildContext context) {
    final iMat = context.watch<ImatDataHandler>();

    final bool hasSubcategories = widget.subCategories.isNotEmpty;
    final double rowHeight = (50.0 - (widget.depth * 10)).clamp(30.0, 50.0);
    final double fontSize = (20.0 - (widget.depth * 4)).clamp(12.0, 20.0);
    final double leftPadding = 16 + (widget.depth * 16);

    final BorderRadius borderRadius = BorderRadius.circular(rowHeight);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Material(
          color: Colors.white,
          borderRadius: borderRadius,
          clipBehavior: Clip.antiAlias,
          child: SizedBox(
            height: rowHeight,
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.only(
                      topLeft: borderRadius.topLeft,
                      bottomLeft: borderRadius.bottomLeft,
                    ),
                    onTap: widget.onTextTap ??
                        () => iMat.selectSelection(
                              iMat.findProductsByCategory(widget.subCategories),
                            ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: leftPadding),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          iMat.translateCategory(widget.category),
                          style: AppTheme.textTheme.labelMedium?.copyWith(
                            fontSize: fontSize,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                if (hasSubcategories)
                  Container(
                    width: 1,
                    height: rowHeight - 15,
                    color: Colors.grey[300],
                  ),

                if (widget.subCategories.length > 1)
                  InkWell(
                    borderRadius: BorderRadius.only(
                      topRight: borderRadius.topRight,
                      bottomRight: borderRadius.bottomRight,
                    ),
                    onTap: () {
                      setState(() {
                        _showSubcategories = !_showSubcategories;
                      });
                      widget.onIconTap?.call();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(0),
                      child: Icon(
                        _showSubcategories
                            ? Icons.arrow_drop_down
                            : Icons.arrow_right,
                        size: (rowHeight),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),

        // Subcategories with vertical unfolding effect
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 150),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          transitionBuilder: (Widget child, Animation<double> animation) {
            final offsetAnimation = Tween<Offset>(
              begin: const Offset(0, -0.1), // slide down from just above
              end: Offset.zero,
            ).animate(animation);

            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: offsetAnimation,
                child: child,
              ),
            );
          },
          child: _showSubcategories
              ? Padding(
                  key: ValueKey(true), // Important for AnimatedSwitcher diffing
                  padding: const EdgeInsets.only(left: 24),
                  child: Column(
                    children: widget.subCategories.map(
                      (subCat) => Padding(padding: EdgeInsets.only(top:2), child: CategoryWidget(
                        key: ValueKey(subCat.name), // unique key for each sub
                        category: subCat.name,
                        subCategories: [],
                        onTextTap: () => iMat.selectSelection(
                          iMat.findProductsByCategory([subCat]),
                        ),
                        depth: widget.depth + 1,
                      ),),
                    ).toList(),
                  ),
                )
              : const SizedBox.shrink(key: ValueKey(false)),
        ),
      ],
    );
  }
}
