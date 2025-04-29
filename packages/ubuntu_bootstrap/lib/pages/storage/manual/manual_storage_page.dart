import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:ubuntu_bootstrap/l10n.dart';
import 'package:ubuntu_bootstrap/pages/storage/manual/manual_storage_model.dart';
import 'package:ubuntu_bootstrap/pages/storage/manual/manual_storage_widgets.dart';
import 'package:ubuntu_bootstrap/pages/storage/manual/storage_selector.dart';
import 'package:ubuntu_wizard/ubuntu_wizard.dart';
import 'package:yaru/yaru.dart';

class ManualStoragePage extends ConsumerStatefulWidget {
  const ManualStoragePage({super.key});

  static Future<bool> load(WidgetRef ref) {
    return ref
        .read(manualStorageModelProvider.notifier)
        .init()
        .then((_) => true);
  }

  @override
  ConsumerState<ManualStoragePage> createState() => _ManualStoragePageState();
}

class _ManualStoragePageState extends ConsumerState<ManualStoragePage> {
  final _scrollController = AutoScrollController();
  late void Function() _scrollListener;
  late final ManualStorageModel _model;

  @override
  void initState() {
    super.initState();
    _scrollListener = _scrollToSelection;
    _model = ref.read(manualStorageModelProvider);
    _model.selectionChangedNotifier.addListener(_scrollListener);
    
    // Announce the page when it loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final lang = UbuntuBootstrapLocalizations.of(context);
      SemanticsService.announce(
        'Now on ${lang.allocateDiskSpace} page',
        TextDirection.ltr,
      );
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _model.selectionChangedNotifier.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollToSelection() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final model = ref.read(manualStorageModelProvider);
      if (model.selectedDiskIndex != -1) {
        _scrollController.scrollToIndex(
          Object.hashAll([model.selectedDiskIndex, model.selectedObjectIndex]),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final model = ref.watch(manualStorageModelProvider);
    final lang = UbuntuBootstrapLocalizations.of(context);

    return WizardPage(
      title: YaruWindowTitleBar(
        title: Semantics(
          label: lang.allocateDiskSpace,
          header: true,
          child: Text(lang.allocateDiskSpace),
        ),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(
            label: 'Storage partition overview',
            child: const PartitionBar(),
          ),
          const SizedBox(height: kWizardSpacing / 4),
          Semantics(
            label: 'Partition legend',
            child: const PartitionLegend(),
          ),
          const SizedBox(height: kWizardSpacing),
          Expanded(
            child: Semantics(
              label: 'Partition table',
              child: PartitionTable(controller: _scrollController),
            ),
          ),
          const SizedBox(height: kWizardSpacing / 2),
          Semantics(
            label: 'Partition buttons',
            child: const PartitionButtonRow(),
          ),
          const SizedBox(height: kWizardSpacing / 2),
          FractionallySizedBox(
            widthFactor: 0.5,
            alignment: Alignment.topLeft,
            child: Semantics(
              label: 'Boot loader device selection',
              child: StorageSelector(
                title: lang.bootLoaderDevice,
                storages: model.disks,
                selected: model.bootDiskIndex,
                enabled: (disk) => disk.canBeBootDevice,
                onSelected: (storage) => model.selectBootDisk(storage!),
              ),
            ),
          ),
        ],
      ),
      bottomBar: WizardBar(
        leading: Semantics(
          button: true,
          label: 'Back',
          child: const BackWizardButton(),
        ),
        trailing: [
          Semantics(
            button: true,
            label: 'Next',
            enabled: model.isValid,
            child: NextWizardButton(
              enabled: model.isValid,
              onNext: model.setStorage,
              onReturn: model.resetStorage,
            ),
          ),
        ],
      ),
    );
  }
}