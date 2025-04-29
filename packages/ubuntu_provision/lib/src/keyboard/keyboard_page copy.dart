import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ubuntu_provision/ubuntu_provision.dart';
import 'package:ubuntu_widgets/ubuntu_widgets.dart';
import 'package:ubuntu_wizard/ubuntu_wizard.dart';

class KeyboardPage extends ConsumerStatefulWidget with ProvisioningPage {
  const KeyboardPage({super.key});

  @override
  ConsumerState<KeyboardPage> createState() => _KeyboardPageState();

  @override
  Future<bool> load(BuildContext context, WidgetRef ref) {
    final model = ref.read(keyboardModelProvider);
    return model
        .init()
        .then((_) => model.updateInputSource())
        .then((_) => true);
  }
}

class _KeyboardPageState extends ConsumerState<KeyboardPage> {
  // Focus nodes for each navigable section
  final FocusNode _layoutListFocusNode = FocusNode();
  final FocusNode _variantDropdownFocusNode = FocusNode();
  final FocusNode _testFieldFocusNode = FocusNode();
  final FocusNode _detectButtonFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Announce page title when loaded
      final lang = KeyboardLocalizations.of(context);
      SemanticsService.announce(
        '${lang.keyboardTitle} - ${lang.keyboardHeader}',
        TextDirection.ltr,
      );
      
      // Set initial focus on layout list
      _layoutListFocusNode.requestFocus();
    });
  }
  
  @override
  void dispose() {
    _layoutListFocusNode.dispose();
    _variantDropdownFocusNode.dispose();
    _testFieldFocusNode.dispose();
    _detectButtonFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model = ref.watch(keyboardModelProvider);
    final lang = KeyboardLocalizations.of(context);
    final nextFocusNode = ref.watch(_nextFocusNodeProvider);
    
    return HorizontalPage(
      windowTitle: lang.keyboardTitle,
      title: lang.keyboardHeader,
      
      // Detect Button with accessibility improvements
      trailingTitleWidget: model.canDetectLayout
          ? MergeSemantics(
              child: Focus(
                focusNode: _detectButtonFocusNode,
                child: Semantics(
                  button: true,
                  hint: 'Press to detect keyboard layout',
                  child: OutlinedButton(
                    onPressed: () async {
                      // Announce the action
                      SemanticsService.announce(
                        'Detecting keyboard layout...',
                        TextDirection.ltr,
                      );
                      
                      final result = await showDetectKeyboardDialog(context);
                      if (result != null) {
                        await model.trySelectLayoutVariant(
                          result.layout,
                          result.variant,
                        );
                        
                        // Announce the selection
                        if (model.selectedLayoutIndex >= 0) {
                          SemanticsService.announce(
                            'Selected layout: ${model.layoutName(model.selectedLayoutIndex)}',
                            TextDirection.ltr,
                          );
                        }
                      }
                    },
                    child: Text(lang.keyboardDetectButton),
                  ),
                ),
              ),
            )
          : null,
      
      managedScrolling: false,
      contentFlex: 8,
      onNext: model.save,
      isNextEnabled: model.isValid,
      nextFocusNode: nextFocusNode,
      
      children: <Widget>[
        // 1. Layout List with enhanced accessibility
        Expanded(
          child: MergeSemantics(
            child: Semantics(
              container: true,
              label: 'Keyboard layout selection list',
              hint: 'Use arrow keys to navigate and enter to select',
              child: Focus(
                focusNode: _layoutListFocusNode,
                child: AccessibleListWidget(
                  selectedIndex: model.selectedLayoutIndex,
                  itemCount: model.layoutCount,
                  nextFocusNode: _variantDropdownFocusNode,
                  onSelectionChanged: (index) {
                    model.selectLayout(index);
                    // Announce selection change
                    SemanticsService.announce(
                      'Selected layout: ${model.layoutName(index)}',
                      TextDirection.ltr,
                    );
                  },
                  itemBuilder: (context, index) => ListTile(
                    key: ValueKey(index),
                    title: Text(model.layoutName(index)),
                    selected: index == model.selectedLayoutIndex,
                    onTap: () => model.selectLayout(index),
                  ),
                  onSearch: (value) {
                    final index = model.searchLayout(value);
                    if (index != -1) {
                      model.selectLayout(index);
                    }
                  },
                ),
              ),
            ),
          ),
        ),
        
        const SizedBox(height: kWizardSpacing),
        
        // 2. Variant Selection with accessibility
        MergeSemantics(
          child: Semantics(
            container: true,
            label: 'Keyboard variant selection',
            child: Focus(
              focusNode: _variantDropdownFocusNode,
              onFocusChange: (hasFocus) {
                if (hasFocus) {
                  // Announce when focus moves to dropdown
                  final variant = model.selectedVariantIndex >= 0 && 
                                 model.selectedVariantIndex < model.variantCount
                      ? model.variantName(model.selectedVariantIndex) 
                      : "Default";
                  
                  SemanticsService.announce(
                    'Variant dropdown. Current selection: $variant',
                    TextDirection.ltr,
                  );
                }
              },
              child: Row(
                children: [
                  Text(lang.keyboardVariantLabel),
                  const SizedBox(width: kWizardSpacing),
                  Expanded(
                    child: Semantics(
                      button: true,
                      child: MenuButtonBuilder<int>(
                        selected: model.selectedVariantIndex,
                        values: List.generate(model.variantCount, (index) => index),
                        itemBuilder: (context, index, child) {
                          return index < 0 || index >= model.variantCount
                              ? const SizedBox.shrink()
                              : Semantics(
                                  label: model.variantName(index),
                                  selected: index == model.selectedVariantIndex,
                                  excludeSemantics: true,
                                  child: Text(model.variantName(index)),
                                );
                        },
                        onSelected: (index) {
                          model.selectVariant(index);
                          // Announce selection
                          SemanticsService.announce(
                            'Selected variant: ${model.variantName(index)}',
                            TextDirection.ltr,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        
        const SizedBox(height: kWizardSpacing),
        const Divider(height: 1),
        const SizedBox(height: kWizardSpacing),
        
        // 3. Test Field with accessibility
        MergeSemantics(
          child: Semantics(
            textField: true,
            label: 'Keyboard test field',
            hint: lang.keyboardTestHint,
            child: Focus(
              focusNode: _testFieldFocusNode,
              onFocusChange: (hasFocus) {
                if (hasFocus) {
                  // Announce when focus moves to test field
                  SemanticsService.announce(
                    'Keyboard test field. ${lang.keyboardTestHint}',
                    TextDirection.ltr,
                  );
                }
              },
              child: TextField(
                decoration: InputDecoration(
                  hintText: lang.keyboardTestHint,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Custom accessible list widget for keyboard navigation
class AccessibleListWidget extends StatelessWidget {
  final int selectedIndex;
  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;
  final Function(int) onSelectionChanged;
  final FocusNode nextFocusNode;
  final Function(String)? onSearch;

  const AccessibleListWidget({
    Key? key,
    required this.selectedIndex,
    required this.itemCount,
    required this.itemBuilder,
    required this.onSelectionChanged,
    required this.nextFocusNode,
    this.onSearch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      onKey: (RawKeyEvent event) {
        if (event is RawKeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
            final newIndex = (selectedIndex + 1) % itemCount;
            onSelectionChanged(newIndex);
          } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
            final newIndex = (selectedIndex - 1 + itemCount) % itemCount;
            onSelectionChanged(newIndex);
          } else if (event.logicalKey == LogicalKeyboardKey.home) {
            onSelectionChanged(0);
          } else if (event.logicalKey == LogicalKeyboardKey.end) {
            onSelectionChanged(itemCount - 1);
          } else if (event.logicalKey == LogicalKeyboardKey.pageUp) {
            final newIndex = (selectedIndex - 10).clamp(0, itemCount - 1);
            onSelectionChanged(newIndex);
          } else if (event.logicalKey == LogicalKeyboardKey.pageDown) {
            final newIndex = (selectedIndex + 10).clamp(0, itemCount - 1);
            onSelectionChanged(newIndex);
          } else if (event.logicalKey == LogicalKeyboardKey.tab) {
            if (HardwareKeyboard.instance.isShiftPressed) {
              // Handle Shift+Tab (would need additional logic)
            } else {
              // Move to the next widget
              nextFocusNode.requestFocus();
            }
          } 
          
          // Handle search
          final character = event.character;
          if (character != null && character.isNotEmpty && onSearch != null) {
            onSearch!(character);
          }
        }
      },
      child: ListWidget.builder(
        selectedIndex: selectedIndex,
        itemCount: itemCount,
        tabFocusNode: nextFocusNode,
        itemBuilder: (context, index) {
          return Semantics(
            selected: index == selectedIndex,
            child: itemBuilder(context, index),
          );
        },
        onKeySearch: onSearch,
      ),
    );
  }
}

final _nextFocusNodeProvider = ProvisioningPage.createNextFocusNodeProvider();