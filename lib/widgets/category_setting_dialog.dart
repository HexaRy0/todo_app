import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';
import 'package:todo_app/model/category.dart';
import 'package:todo_app/providers/category_provider.dart';
import 'package:uuid/uuid.dart';

class CategorySettingDialog extends ConsumerStatefulWidget {
  const CategorySettingDialog({super.key, this.isEdit = false, this.category, this.setState});

  final CategoryData? category;
  final bool isEdit;
  final void Function(void Function())? setState;

  @override
  ConsumerState<CategorySettingDialog> createState() => _CategorySettingDialogState();
}

class _CategorySettingDialogState extends ConsumerState<CategorySettingDialog> {
  final GlobalKey<FormBuilderState> _addCategoryFormKey = GlobalKey<FormBuilderState>();
  Icon? _selectedIcon;
  final List<MaterialColor> _colorList = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
    Colors.pink,
    Colors.teal,
    Colors.cyan,
    Colors.brown,
    Colors.grey,
    Colors.deepOrange,
    Colors.indigo,
    Colors.lime,
    Colors.amber,
  ];

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setDialogState) {
        return AlertDialog(
          title: Text(widget.isEdit ? "Update Category" : 'Add Category'),
          content: SizedBox(
            width: 320,
            child: FormBuilder(
              key: _addCategoryFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Category Name"),
                  const SizedBox(height: 8),
                  FormBuilderTextField(
                    name: 'name',
                    initialValue: widget.category?.name,
                    decoration: const InputDecoration(
                      hintText: 'Category Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text("Category Icon"),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        IconData? icon = await FlutterIconPicker.showIconPicker(
                          context,
                          iconPackModes: [IconPack.material],
                        );

                        setDialogState(() {
                          setState(() {
                            _selectedIcon = Icon(icon);
                          });
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(0, 48),
                      ),
                      icon: widget.isEdit
                          ? widget.category?.icon != null
                              ? Icon(widget.category?.icon)
                              : const Icon(Icons.category)
                          : _selectedIcon ?? const Icon(Icons.category),
                      label: const Text("Pick Icon"),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text("Category Color (Optional)"),
                  const SizedBox(height: 8),
                  FormBuilderColorPickerField(
                    name: 'color',
                    decoration: const InputDecoration(
                      hintText: 'Choose Category Color (Optional)',
                      border: OutlineInputBorder(),
                    ),
                    initialValue: widget.isEdit && widget.category?.color != null
                        ? ColorScheme.fromSeed(seedColor: widget.category!.color).primary
                        : Theme.of(context).colorScheme.primary,
                    colorPickerType: ColorPickerType.blockPicker,
                    availableColors: _colorList,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (_addCategoryFormKey.currentState!.saveAndValidate()) {
                  if (widget.isEdit) {
                    final tempCategory = CategoryData(
                      id: widget.category!.id,
                      name: _addCategoryFormKey.currentState?.value['name'],
                      icon: _selectedIcon?.icon ?? widget.category!.icon,
                      color: _addCategoryFormKey.currentState?.value['color'] as Color,
                    );

                    ref.read(categoriesProvider.notifier).updateCategory(tempCategory);
                  } else {
                    final tempCategory = CategoryData(
                      id: const Uuid().v4(),
                      name: _addCategoryFormKey.currentState?.value['name'],
                      icon: _selectedIcon?.icon ?? Icons.category,
                      color: _addCategoryFormKey.currentState?.value['color'] as Color,
                    );

                    ref.read(categoriesProvider.notifier).addCategory(tempCategory);
                  }

                  setState(() {
                    _selectedIcon = null;
                  });

                  widget.setState?.call(() {});

                  Navigator.of(context).pop();
                }
              },
              child: Text(widget.isEdit ? "Update" : 'Add'),
            ),
          ],
        );
      },
    );
  }
}
