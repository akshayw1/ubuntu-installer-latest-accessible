import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
    
    // Enable semantics for Orca
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Force semantics to be enabled
      WidgetsBinding.instance.ensureSemantics();
      
      // Announce page title when loaded
      final lang = KeyboardLocalizations.of(context);
      SemanticsService.announce(
        '${lang.keyboardTitle} ${lang.keyboardHeader}',
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
          ? Semantics(
              button: true,
              label: lang.keyboardDetectButton,
              hint: 'Press to detect keyboard layout',
              child: Focus(
                focusNode: _detectButtonFocusNode,
                child: OutlinedButton(
                  onPressed: () async {
                    // Announce the action
                    SemanticsService.announce(
                      'Detecting keyboard layout',
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
                          'Selected layout ${model.layoutName(model.selectedLayoutIndex)}',
                          TextDirection.ltr,
                        );
                      }
                    }
                  },
                  child: Text(lang.keyboardDetectButton),
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
          child: Semantics(
            container: true,
            label: 'Keyboard layout selection list',
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
                    'Selected ${model.layoutName(index)}',
                    TextDirection.ltr,
                  );
                },
                itemBuilder: (context, index) => Semantics(
                  label: '${model.layoutName(index)} ${index == model.selectedLayoutIndex ? "selected" : ""}',
                  selected: index == model.selectedLayoutIndex,
                  child: ListTile(
                    key: ValueKey(index),
                    title: Text(model.layoutName(index)),
                    selected: index == model.selectedLayoutIndex,
                    onTap: () => model.selectLayout(index),
                  ),
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
        
        const SizedBox(height: kWizardSpacing),
        
        // 2. Variant Selection - Orca Compatible
        Semantics(
          label: 'Keyboard variant',
          child: Row(
            children: [
              Text(lang.keyboardVariantLabel),
              const SizedBox(width: kWizardSpacing),
              Expanded(
                child: Focus(
                  focusNode: _variantDropdownFocusNode,
                  child: OrcaAccessibleDropdown(
                    value: model.selectedVariantIndex,
                    itemCount: model.variantCount,
                    itemBuilder: (index) => model.variantName(index),
                    onChanged: (index) {
                      model.selectVariant(index);
                      SemanticsService.announce(
                        'Selected variant ${model.variantName(index)}',
                        TextDirection.ltr,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: kWizardSpacing),
        const Divider(height: 1),
        const SizedBox(height: kWizardSpacing),
        
        // 3. Test Field with accessibility
        Semantics(
          textField: true,
          label: 'Keyboard test field ${lang.keyboardTestHint}',
          child: Focus(
            focusNode: _testFieldFocusNode,
            child: TextField(
              decoration: InputDecoration(
                hintText: lang.keyboardTestHint,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Orca-compatible dropdown using PopupMenuButton
class OrcaAccessibleDropdown extends StatefulWidget {
  final int value;
  final int itemCount;
  final String Function(int) itemBuilder;
  final Function(int) onChanged;

  const OrcaAccessibleDropdown({
    Key? key,
    required this.value,
    required this.itemCount,
    required this.itemBuilder,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<OrcaAccessibleDropdown> createState() => _OrcaAccessibleDropdownState();
}

class _OrcaAccessibleDropdownState extends State<OrcaAccessibleDropdown> {
  late int _currentIndex;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.value >= 0 ? widget.value : 0;
  }

  @override
  void didUpdateWidget(OrcaAccessibleDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _currentIndex = widget.value >= 0 ? widget.value : 0;
    }
  }

  void _handleKeyEvent(RawKeyEvent event) {
    if (event is RawKeyDownEvent && _isOpen) {
      if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % widget.itemCount;
        });
        // Announce current item
        SemanticsService.announce(
          widget.itemBuilder(_currentIndex),
          TextDirection.ltr,
        );
      } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        setState(() {
          _currentIndex = (_currentIndex - 1 + widget.itemCount) % widget.itemCount;
        });
        // Announce current item
        SemanticsService.announce(
          widget.itemBuilder(_currentIndex),
          TextDirection.ltr,
        );
      } else if (event.logicalKey == LogicalKeyboardKey.enter) {
        widget.onChanged(_currentIndex);
        Navigator.of(context).pop();
        setState(() {
          _isOpen = false;
        });
      } else if (event.logicalKey == LogicalKeyboardKey.escape) {
        Navigator.of(context).pop();
        setState(() {
          _isOpen = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentVariant = widget.value >= 0 && widget.value < widget.itemCount
        ? widget.itemBuilder(widget.value)
        : 'Default';

    return RawKeyboardListener(
      focusNode: FocusNode(),
      onKey: _handleKeyEvent,
      child: Semantics(
        button: true,
        label: 'Variant dropdown button. Current selection $currentVariant. Press space or enter to open',
        child: InkWell(
          onTap: () async {
            setState(() {
              _isOpen = true;
              _currentIndex = widget.value >= 0 ? widget.value : 0;
            });
            
            SemanticsService.announce(
              'Dropdown opened. Use arrow keys to navigate',
              TextDirection.ltr,
            );

            // Get the button's position to show menu below it
            final RenderBox button = context.findRenderObject() as RenderBox;
            final RenderBox overlay = Navigator.of(context).overlay!.context.findRenderObject() as RenderBox;
            final RelativeRect position = RelativeRect.fromRect(
              Rect.fromPoints(
                button.localToGlobal(Offset.zero, ancestor: overlay),
                button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay),
              ),
              Offset.zero & overlay.size,
            );

            final selected = await showMenu<int>(
              context: context,
              position: position,
              items: List.generate(
                widget.itemCount,
                (index) => PopupMenuItem<int>(
                  value: index,
                  child: Semantics(
                    label: '${widget.itemBuilder(index)} ${index == widget.value ? "currently selected" : ""}',
                    selected: index == widget.value,
                    child: Container(
                      color: index == _currentIndex ? Theme.of(context).focusColor.withOpacity(0.1) : null,
                      child: ListTile(
                        title: Text(widget.itemBuilder(index)),
                        selected: index == widget.value,
                      ),
                    ),
                  ),
                ),
              ),
            );

            setState(() {
              _isOpen = false;
            });

            if (selected != null) {
              widget.onChanged(selected);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).dividerColor),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    currentVariant,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Simplified accessible list widget
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
    return KeyboardListener(
      focusNode: FocusNode(),
      onKeyEvent: (KeyEvent event) {
        if (event is KeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
            final newIndex = (selectedIndex + 1) % itemCount;
            onSelectionChanged(newIndex);
          } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
            final newIndex = (selectedIndex - 1 + itemCount) % itemCount;
            onSelectionChanged(newIndex);
          } else if (event.logicalKey == LogicalKeyboardKey.tab && !HardwareKeyboard.instance.isShiftPressed) {
            nextFocusNode.requestFocus();
          }
        }
      },
      child: ListWidget.builder(
        selectedIndex: selectedIndex,
        itemCount: itemCount,
        tabFocusNode: nextFocusNode,
        itemBuilder: itemBuilder,
        onKeySearch: onSearch,
      ),
    );
  }
}

final _nextFocusNodeProvider = ProvisioningPage.createNextFocusNodeProvider();