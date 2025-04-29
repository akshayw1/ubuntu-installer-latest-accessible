import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ubuntu_provision/ubuntu_provision.dart';
import 'package:ubuntu_wizard/ubuntu_wizard.dart';
import 'package:yaru/yaru.dart';

class AccessibilityPage extends ConsumerWidget with ProvisioningPage {
  AccessibilityPage({super.key});

  @override
  Future<bool> load(BuildContext context, WidgetRef ref) {
    final model = ref.read(accessibilityModelProvider);
    return model.init().then((isSupported) => isSupported);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flavor = ref.watch(flavorProvider);
    final lang = UbuntuProvisionLocalizations.of(context);

    return HorizontalPage(
      windowTitle: lang.accessibilityPageTitle,
      title: lang.accessibilityPageHeader(flavor.displayName),
      bottomBar: const WizardBar(
        leading: BackWizardButton(),
        trailing: [NextWizardButton()],
      ),
      children: [
        // Add screen reader-focused element at the top
        Semantics(
          label: 'Accessibility in ${flavor.displayName}',
          header: true,
          focusable: true,
          excludeSemantics: true,  // Don't read the child text separately
          
        ),
        Text(lang.accessibilityPageBody(flavor.displayName)),
        const SizedBox(height: kWizardSpacing),
        // Replace YaruExpansionPanel with individual Material ExpansionTile widgets
        _buildAccessibilitySection(
          context,
          YaruIcons.eye,
          lang.accessibilitySeeingLabel,
          [
            _AccessibilityListTile(
              id: AccessibilityOption.highContrast,
              title: lang.accessibilityHighContrastLabel,
            ),
            _AccessibilityListTile(
              id: AccessibilityOption.largeText,
              title: lang.accessibilityLargeTextLabel,
            ),
            _AccessibilityListTile(
              id: AccessibilityOption.reduceAnimation,
              title: lang.accessibilityReduceAnimationLabel,
            ),
            _AccessibilityListTile(
              id: AccessibilityOption.screenReader,
              title: lang.accessibilityScreenReaderLabel,
            ),
          ],
        ),
          const SizedBox(height: 8),
        _buildAccessibilitySection(
          context,
          YaruIcons.headphones,
          lang.accessibilityHearingLabel,
          [
            _AccessibilityListTile(
              id: AccessibilityOption.visualAlerts,
              title: lang.accessibilityVisualAlertsLabel,
            ),
          ],
        ),
        const SizedBox(height: 8),
        _buildAccessibilitySection(
          context,
          YaruIcons.keyboard,
          lang.accessibilityTypingLabel,
          [
            _AccessibilityListTile(
              id: AccessibilityOption.stickyKeys,
              title: lang.accessibilityStickKeysLabel,
            ),
            _AccessibilityListTile(
              id: AccessibilityOption.slowKeys,
              title: lang.accessibilitySlowKeysLabel,
            ),
          ],
        ),
        const SizedBox(height: 8),
        _buildAccessibilitySection(
          context,
          YaruIcons.mouse,
          lang.accessibilityPointingLabel,
          [
            _AccessibilityListTile(
              id: AccessibilityOption.mouseKeys,
              title: lang.accessibilityMouseKeysLabel,
            ),
          ],
        ),
        const SizedBox(height: 8),
        _buildAccessibilitySection(
          context,
          YaruIcons.magnifying_glass,
          lang.accessibilityZoomLabel,
          [
            _AccessibilityListTile(
              id: AccessibilityOption.desktopZoom,
              title: lang.accessibilityDesktopZoomLabel,
            ),
          ],
        ),
      ],
    );
  }

  // New helper method to create accessible ExpansionTile sections
  Widget _buildAccessibilitySection(
    BuildContext context,
    IconData icon,
    String title,
    List<Widget> children,
  ) {
    // Use Material's ListTile with custom ExpansionTile-like behavior for better accessibility
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        leading: Icon(icon),
        title: Text(title),
        expandedAlignment: Alignment.centerLeft,
        shape: const Border(), // Remove default Material border
        childrenPadding: const EdgeInsets.only(left: 16),
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        backgroundColor: Colors.transparent,
        collapsedBackgroundColor: Colors.transparent,
        // Make the ExpansionTile header itself accessible with clear semantics
        textColor: Theme.of(context).colorScheme.primary,
        iconColor: Theme.of(context).colorScheme.primary,
        // Clear semantics for title and icon to avoid duplicate announcements
        children: children,
      ),
    );
  }
}

class _AccessibilityListTile extends ConsumerWidget {
  const _AccessibilityListTile({
    required this.id,
    required this.title,
  });

  final AccessibilityOption id;
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.watch(accessibilityModelProvider);
    final isEnabled = model.activeOptions.contains(id);

    return Column(
      children: [
        if (model.activeOptions.toList().indexOf(id) != 0) // Skip divider for first item
          const Divider(height: 1, indent: 16),
        // Use MergeSemantics to ensure YaruSwitchListTile and its custom semantics are combined
        MergeSemantics(
          child: Semantics(
            toggled: isEnabled,
            label: '$title, ${isEnabled ? 'enabled' : 'disabled'}',
            hint: 'Double tap to ${isEnabled ? 'disable' : 'enable'}',
            child: YaruSwitchListTile(
              title: Padding(
                padding: kWizardIndentation
                    .add(const EdgeInsets.symmetric(vertical: 8.0)),
                child: Text(title),
              ),
              value: isEnabled,
              onChanged: (_) => model.toggleOption(id),
            ),
          ),
        ),
      ],
    );
  }
}