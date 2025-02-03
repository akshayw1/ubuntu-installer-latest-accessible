import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ubuntu_bootstrap/installer/installation_step.dart';
import 'package:ubuntu_bootstrap/pages/storage/bitlocker/bitlocker_page.dart';
import 'package:ubuntu_bootstrap/pages/storage/guided_reformat/guided_reformat_page.dart';
import 'package:ubuntu_bootstrap/pages/storage/guided_resize/guided_resize_page.dart';
import 'package:ubuntu_bootstrap/pages/storage/manual/manual_storage_page.dart';
import 'package:ubuntu_bootstrap/pages/storage/passphrase/passphrase_page.dart';
import 'package:ubuntu_bootstrap/pages/storage/recovery_key/recovery_key_page.dart';
import 'package:ubuntu_bootstrap/pages/storage/storage_model.dart';
import 'package:ubuntu_bootstrap/pages/storage/storage_page.dart';
import 'package:ubuntu_bootstrap/pages/storage/storage_routes.dart';
import 'package:ubuntu_provision/interfaces.dart';
import 'package:ubuntu_wizard/ubuntu_wizard.dart';

export 'bitlocker/bitlocker_page.dart';
export 'guided_reformat/guided_reformat_page.dart';
export 'guided_resize/guided_resize_page.dart';
export 'manual/manual_storage_page.dart';
export 'passphrase/passphrase_page.dart';
export 'recovery_key/recovery_key_page.dart';
export 'storage_page.dart';
export 'storage_routes.dart';

class StorageWizard extends ConsumerWidget with ProvisioningPage {
  const StorageWizard({super.key});

  @override
  Future<bool> load(BuildContext context, WidgetRef ref) {
    return StoragePage().load(context, ref);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final type = ref.watch(storageModelProvider.select((m) => m.type));

    final routes = {
      InstallationStep.storage.route: WizardRoute(
        builder: (_) => StoragePage(),
        userData: WizardRouteData(step: InstallationStep.secureBoot.pageIndex),
      ),
      if (type != StorageType.manual && type != StorageType.erase)
        StorageSteps.bitlocker.route: WizardRoute(
          builder: (_) => const BitLockerPage(),
          onLoad: (_) => const BitLockerPage().load(context, ref),
        ),
      if (type == StorageType.erase)
        StorageSteps.guidedReformat.route: WizardRoute(
          builder: (_) => const GuidedReformatPage(),
          userData: WizardRouteData(step: InstallationStep.storage.pageIndex),
          onLoad: (_) => GuidedReformatPage.load(ref),
          onReplace: (_) => StorageSteps.manual.route,
        ),
      if (type == StorageType.alongside)
        StorageSteps.guidedResize.route: WizardRoute(
          builder: (_) => const GuidedResizePage(),
          userData: WizardRouteData(step: InstallationStep.storage.pageIndex),
          onLoad: (_) => GuidedResizePage.load(ref),
          onReplace: (_) => StorageSteps.manual.route,
        ),
      if (type == StorageType.manual)
        StorageSteps.manual.route: WizardRoute(
          builder: (_) => const ManualStoragePage(),
          userData: WizardRouteData(step: InstallationStep.storage.pageIndex),
          onLoad: (_) => ManualStoragePage.load(ref),
        ),
      if (type != StorageType.manual)
        StorageSteps.passphrase.route: WizardRoute(
          builder: (_) => const PassphrasePage(),
          userData: WizardRouteData(step: InstallationStep.storage.pageIndex),
          onLoad: (_) => PassphrasePage.load(ref),
        ),
      if (type != StorageType.manual)
        StorageSteps.recoveryKey.route: WizardRoute(
          builder: (_) => const RecoveryKeyPage(),
          userData: WizardRouteData(step: InstallationStep.storage.pageIndex),
          onLoad: (_) => RecoveryKeyPage.load(ref),
        ),
    };

    return Wizard(
      key: ValueKey(type),
      userData: WizardData(
        totalSteps:
            InstallationStep.values.where((value) => value.discreteStep).length,
      ),
      routes: routes,
    );
  }
}
