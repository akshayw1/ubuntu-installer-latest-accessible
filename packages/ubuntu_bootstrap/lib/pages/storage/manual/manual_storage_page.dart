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
  
  // Focus nodes for accessibility
  final FocusNode _tableFocusNode = FocusNode();
  final FocusNode _buttonsFocusNode = FocusNode();
  final FocusNode _bootLoaderFocusNode = FocusNode();
  
  // Live region key for announcements
  final GlobalKey _liveRegionKey = GlobalKey();
  String _liveRegionText = '';

  @override
  void initState() {
    super.initState();
    _scrollListener = _scrollToSelection;
    _model = ref.read(manualStorageModelProvider);
    _model.selectionChangedNotifier.addListener(_scrollListener);
    
    // Enable semantics and announce page on load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      
      // Ensure semantics are enabled for Orca
      WidgetsBinding.instance.ensureSemantics();
      
      final lang = UbuntuBootstrapLocalizations.of(context);
      final model = ref.read(manualStorageModelProvider);
      
      // Force focus to trigger Orca
      FocusScope.of(context).requestFocus(FocusNode());
      
      // Main announcement with delay to ensure Orca is ready
      Future.delayed(const Duration(milliseconds: 100), () {
        if (!mounted) return;
        
        // Create a temporary focusable widget to ensure announcement
        final tempFocus = FocusNode();
        FocusScope.of(context).requestFocus(tempFocus);
        
        // Update live region
        setState(() {
          _liveRegionText = 'Manual Partitioning. ${lang.allocateDiskSpace}. You can create or resize partitions yourself, or choose multiple partitions for Ubuntu.';
        });
        
        SemanticsService.announce(
          _liveRegionText,
          TextDirection.ltr,
          assertiveness: Assertiveness.assertive,
        );
        
        tempFocus.dispose();
      });
      
      // Announce disk information
      Future.delayed(const Duration(milliseconds: 800), () {
        if (!mounted) return;
        
        final diskCount = model.disks.length;
        final totalSpace = _formatBytes(model.disks.fold<int>(
          0, (sum, disk) => sum + (disk.size ?? 0)));
        
        SemanticsService.announce(
          'Found $diskCount ${diskCount == 1 ? "disk" : "disks"} with total space of $totalSpace',
          TextDirection.ltr,
        );
      });
      
      // Announce partition count
      Future.delayed(const Duration(milliseconds: 1400), () {
        if (!mounted) return;
        
        final partitionCount = model.objects.length;
        SemanticsService.announce(
          '$partitionCount ${partitionCount == 1 ? "partition" : "partitions"} currently configured',
          TextDirection.ltr,
        );
      });
      
      // Set initial focus
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) {
          _tableFocusNode.requestFocus();
        }
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _model.selectionChangedNotifier.removeListener(_scrollListener);
    _tableFocusNode.dispose();
    _buttonsFocusNode.dispose();
    _bootLoaderFocusNode.dispose();
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
        
        // Announce selection
        final selectedObject = model.selectedObject;
        if (selectedObject != null) {
          final type = selectedObject.partition != null ? 'partition' : 'free space';
          final size = _formatBytes(selectedObject.size ?? 0);
          SemanticsService.announce(
            'Selected $type with size $size',
            TextDirection.ltr,
          );
        }
      }
    });
  }

  String _formatBytes(int bytes) {
    const units = ['B', 'KB', 'MB', 'GB', 'TB'];
    int unitIndex = 0;
    double size = bytes.toDouble();
    
    while (size >= 1024 && unitIndex < units.length - 1) {
      size /= 1024;
      unitIndex++;
    }
    
    return '${size.toStringAsFixed(1)} ${units[unitIndex]}';
  }

  @override
  Widget build(BuildContext context) {
    final model = ref.watch(manualStorageModelProvider);
    final lang = UbuntuBootstrapLocalizations.of(context);

    return Semantics(
      label: 'Manual partitioning page',
      container: true,
      child: WizardPage(
        title: YaruWindowTitleBar(
          title: Semantics(
            label: 'Manual Partitioning. ${lang.allocateDiskSpace}',
            header: true,
            focusable: true,
            child: Text(lang.allocateDiskSpace),
          ),
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Live region for announcements
            Semantics(
              key: _liveRegionKey,
              liveRegion: true,
              focusable: false,
              container: true,
              child: SizedBox(
                height: 0,
                child: Text(
                  _liveRegionText,
                  style: const TextStyle(fontSize: 0),
                ),
              ),
            ),
            Semantics(
              label: 'Storage partition overview. Visual representation of disk partitions',
              child: const PartitionBar(),
            ),
            const SizedBox(height: kWizardSpacing / 4),
            Semantics(
              label: 'Partition legend showing color codes for different partition types',
              child: const PartitionLegend(),
            ),
            const SizedBox(height: kWizardSpacing),
            Expanded(
              child: Focus(
                focusNode: _tableFocusNode,
                onFocusChange: (hasFocus) {
                  if (hasFocus && mounted) {
                    SemanticsService.announce(
                      'Partition table. Use arrow keys to navigate, space to select',
                      TextDirection.ltr,
                    );
                  }
                },
                child: Semantics(
                  label: 'Partition table with ${model.objects.length} items',
                  hint: 'Navigate with arrow keys, select with space',
                  child: PartitionTable(controller: _scrollController),
                ),
              ),
            ),
            const SizedBox(height: kWizardSpacing / 2),
            Focus(
              focusNode: _buttonsFocusNode,
              onFocusChange: (hasFocus) {
                if (hasFocus && mounted) {
                  final hasSelection = model.selectedObject != null;
                  SemanticsService.announce(
                    hasSelection 
                        ? 'Partition action buttons. New, Edit, and Delete available'
                        : 'Partition action buttons. Only New is available',
                    TextDirection.ltr,
                  );
                }
              },
              child: Semantics(
                label: 'Partition action buttons',
                hint: 'Create, edit, or delete partitions',
                child: const AccessiblePartitionButtonRow(),
              ),
            ),
            const SizedBox(height: kWizardSpacing / 2),
            FractionallySizedBox(
              widthFactor: 0.5,
              alignment: Alignment.topLeft,
              child: Focus(
                focusNode: _bootLoaderFocusNode,
                onFocusChange: (hasFocus) {
                  if (hasFocus && mounted) {
                    final selectedDisk = model.bootDiskIndex >= 0 && model.bootDiskIndex < model.disks.length
                        ? model.disks[model.bootDiskIndex].sysname
                        : 'none';
                    SemanticsService.announce(
                      'Boot loader device selector. Currently selected: $selectedDisk',
                      TextDirection.ltr,
                    );
                  }
                },
                child: Semantics(
                  label: 'Boot loader device selection dropdown',
                  hint: 'Select where to install the boot loader',
                  child: StorageSelector(
                    title: lang.bootLoaderDevice,
                    storages: model.disks,
                    selected: model.bootDiskIndex,
                    enabled: (disk) => disk.canBeBootDevice,
                    onSelected: (storage) {
                      model.selectBootDisk(storage!);
                      if (mounted) {
                        SemanticsService.announce(
                          'Boot loader will be installed on ${storage.sysname}',
                          TextDirection.ltr,
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomBar: WizardBar(
          leading: Semantics(
            button: true,
            label: 'Back button',
            child: const BackWizardButton(),
          ),
          trailing: [
            Semantics(
              button: true,
              label: 'Next button ${model.isValid ? "enabled" : "disabled. Please configure at least one partition for Ubuntu"}',
              enabled: model.isValid,
              child: NextWizardButton(
                enabled: model.isValid,
                onNext: () async {
                  SemanticsService.announce(
                    'Applying manual partition configuration',
                    TextDirection.ltr,
                  );
                  await model.setStorage();
                },
                onReturn: model.resetStorage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Accessible Partition Button Row
class AccessiblePartitionButtonRow extends ConsumerWidget {
  const AccessiblePartitionButtonRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.watch(manualStorageModelProvider);
    final hasSelection = model.selectedObject != null;
    
    // Wrap the original PartitionButtonRow with semantics
    return Semantics(
      container: true,
      label: 'Partition action buttons. ${hasSelection ? "New, Edit, and Delete available" : "Only New is available"}',
      child: const PartitionButtonRow(),
    );
  }
}