import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ubuntu_bootstrap/l10n.dart';
import 'package:ubuntu_bootstrap/pages/autoinstall/autoinstall_model.dart';
import 'package:ubuntu_provision/ubuntu_provision.dart';
import 'package:ubuntu_utils/ubuntu_utils.dart';
import 'package:ubuntu_widgets/ubuntu_widgets.dart';
import 'package:ubuntu_wizard/ubuntu_wizard.dart';
import 'package:yaml/yaml.dart';
import 'package:yaru/yaru.dart';

class AutoinstallPage extends ConsumerStatefulWidget with ProvisioningPage {
  const AutoinstallPage({super.key});

  @override
  ConsumerState<AutoinstallPage> createState() => _AutoinstallPageState();

  @override
  Future<bool> load(BuildContext context, WidgetRef ref) async => true;
}

class _AutoinstallPageState extends ConsumerState<AutoinstallPage> {
  // Focus nodes for navigation
  final FocusNode _interactiveFocusNode = FocusNode();
  final FocusNode _automatedFocusNode = FocusNode();
  final FocusNode _urlFieldFocusNode = FocusNode();
  final FocusNode _validateButtonFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    
    // Enable semantics and announce page on load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Ensure semantics are enabled for Orca
      WidgetsBinding.instance.ensureSemantics();
      
      // Announce welcome message
      final lang = UbuntuBootstrapLocalizations.of(context);
      final flavor = ref.read(flavorProvider);
      
      SemanticsService.announce(
        'Welcome to installation method page. ${lang.autoinstallHeader(flavor.displayName)}. Choose your way of installation.',
        TextDirection.ltr,
      );
      
      // Set initial focus on first option
      Future.delayed(const Duration(milliseconds: 500), () {
        _interactiveFocusNode.requestFocus();
      });
    });
  }

  @override
  void dispose() {
    _interactiveFocusNode.dispose();
    _automatedFocusNode.dispose();
    _urlFieldFocusNode.dispose();
    _validateButtonFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = UbuntuBootstrapLocalizations.of(context);
    final model = ref.watch(autoinstallModelProvider);
    final flavor = ref.watch(flavorProvider);

    return Semantics(
      label: 'Installation method selection page',
      child: HorizontalPage(
        windowTitle: lang.autoinstallTitle,
        title: lang.autoinstallHeader(flavor.displayName),
        bottomBar: WizardBar(
          leading: Semantics(
            button: true,
            label: 'Back button',
            child: const BackWizardButton(),
          ),
          trailing: [
            model.autoinstall
                ? Focus(
                    focusNode: _validateButtonFocusNode,
                    child: Semantics(
                      button: true,
                      label: 'Validate button ${model.state.isLoading ? "validating" : ""}',
                      enabled: !model.state.hasError && model.url.isNotEmpty,
                      child: _ValidateButton(model: model),
                    ),
                  )
                : Semantics(
                    button: true,
                    label: 'Next button',
                    child: WizardButton(
                      label: UbuntuLocalizations.of(context).nextLabel,
                      onActivated: () {
                        SemanticsService.announce(
                          'Proceeding to next page',
                          TextDirection.ltr,
                        );
                        Wizard.of(context).next();
                      },
                    ),
                  ),
          ],
        ),
        children: [
          // Interactive Option
          Focus(
            focusNode: _interactiveFocusNode,
            onFocusChange: (hasFocus) {
              if (hasFocus) {
                SemanticsService.announce(
                  'Interactive installation option ${!model.autoinstall ? "selected" : "not selected"}. ${lang.autoinstallInteractiveDescription}',
                  TextDirection.ltr,
                );
              }
            },
            child: Semantics(
              button: true,
              checked: !model.autoinstall,
              label: '${lang.autoinstallInteractiveOption}. ${lang.autoinstallInteractiveDescription}',
              hint: 'Radio button',
              child: AccessibleOptionButton(
                title: Text(lang.autoinstallInteractiveOption),
                subtitle: Text(lang.autoinstallInteractiveDescription),
                value: false,
                groupValue: model.autoinstall,
                onChanged: (value) {
                  ref.read(autoinstallModelProvider).autoinstall = value ?? false;
                  SemanticsService.announce(
                    'Interactive installation selected',
                    TextDirection.ltr,
                  );
                },
              ),
            ),
          ),
          
          const SizedBox(height: kWizardSpacing / 2),
          
          // Automated Option
          Focus(
            focusNode: _automatedFocusNode,
            onFocusChange: (hasFocus) {
              if (hasFocus) {
                SemanticsService.announce(
                  'Automated installation option ${model.autoinstall ? "selected" : "not selected"}. ${lang.autoinstallAutomatedDescription}',
                  TextDirection.ltr,
                );
              }
            },
            child: Semantics(
              button: true,
              checked: model.autoinstall,
              label: '${lang.autoinstallAutomatedOption}. ${lang.autoinstallAutomatedDescription}',
              hint: 'Radio button',
              child: AccessibleOptionButton(
                title: Text(lang.autoinstallAutomatedOption),
                subtitle: Text(lang.autoinstallAutomatedDescription),
                value: true,
                groupValue: model.autoinstall,
                onChanged: (value) {
                  ref.read(autoinstallModelProvider).autoinstall = value ?? false;
                  SemanticsService.announce(
                    'Automated installation selected. Please provide autoinstall configuration URL',
                    TextDirection.ltr,
                  );
                  // Move focus to URL field when automated is selected
                  if (value == true) {
                    Future.delayed(const Duration(milliseconds: 300), () {
                      _urlFieldFocusNode.requestFocus();
                    });
                  }
                },
              ),
            ),
          ),
          
          const SizedBox(height: kWizardSpacing),
          
          // Automated Configuration Section
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              opacity: model.autoinstall ? 1 : 0,
              child: SizedBox(
                height: model.autoinstall ? 160 : 0,
                child: Semantics(
                  container: true,
                  label: 'Autoinstall configuration section',
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Semantics(
                        label: lang.autoinstallInstructions,
                        child: Text(lang.autoinstallInstructions),
                      ),
                      const SizedBox(height: kWizardSpacing),
                      Focus(
                        focusNode: _urlFieldFocusNode,
                        onFocusChange: (hasFocus) {
                          if (hasFocus) {
                            SemanticsService.announce(
                              'Autoinstall configuration URL field. Enter the URL or file path',
                              TextDirection.ltr,
                            );
                          }
                        },
                        child: Semantics(
                          textField: true,
                          label: 'Autoinstall configuration URL',
                          hint: 'Enter URL or file path',
                          child: TextFormField(
                            initialValue: model.url,
                            onChanged: (value) {
                              model.url = value;
                              // Announce validation errors
                              if (model.state.hasError) {
                                final error = model.state.maybeWhen(
                                  error: (error, _) {
                                    return switch (error) {
                                      YamlException _ => 'Invalid YAML',
                                      final SocketException e =>
                                        'Network error: ${e.message}',
                                      final ArgumentError e => 
                                        'Invalid URL: ${e.message}',
                                      final FormatException e =>
                                        'Invalid Format: ${e.message}',
                                      final FileSystemException e =>
                                        'File system error: ${e.message}',
                                      _ => 'Unknown Error',
                                    };
                                  },
                                  orElse: () => null,
                                );
                                if (error != null) {
                                  SemanticsService.announce(
                                    'Validation error: $error',
                                    TextDirection.ltr,
                                  );
                                }
                              }
                            },
                            maxLines: null,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (_) => model.state.maybeWhen(
                              error: (error, _) {
                                return switch (error) {
                                  YamlException _ => 'Invalid YAML',
                                  final SocketException e =>
                                    'Network error: ${e.message}',
                                  final ArgumentError e => 
                                    'Invalid URL: ${e.message}',
                                  final FormatException e =>
                                    'Invalid Format: ${e.message}',
                                  final FileSystemException e =>
                                    'File system error: ${e.message}',
                                  _ => 'Unknown Error',
                                };
                              },
                              orElse: () => null,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Accessible Option Button wrapper
class AccessibleOptionButton extends StatelessWidget {
  final Widget title;
  final Widget subtitle;
  final bool value;
  final bool groupValue;
  final ValueChanged<bool?>? onChanged;

  const AccessibleOptionButton({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.groupValue,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OptionButton(
      title: title,
      subtitle: subtitle,
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
    );
  }
}

class _ValidateButton extends StatelessWidget {
  const _ValidateButton({required this.model});

  final AutoinstallModel model;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lang = UbuntuBootstrapLocalizations.of(context);

    return ElevatedButton(
      style: theme.elevatedButtonTheme.style?.copyWith(
        minimumSize: MaterialStateProperty.all(kPushButtonSize),
      ),
      onPressed: !model.state.hasError && model.url.isNotEmpty 
          ? () {
              SemanticsService.announce(
                'Validating autoinstall configuration',
                TextDirection.ltr,
              );
              model.apply();
            }
          : null,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (model.state.isLoading) ...[
            SizedBox.square(
              dimension: 16.0,
              child: YaruCircularProgressIndicator(
                color: Theme.of(context).colorScheme.onPrimary,
                strokeWidth: 2,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Text(lang.validate),
        ],
      ),
    );
  }
}