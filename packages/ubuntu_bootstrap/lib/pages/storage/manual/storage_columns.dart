import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subiquity_client/subiquity_client.dart';
import 'package:ubuntu_bootstrap/l10n.dart';
import 'package:ubuntu_bootstrap/pages/storage/manual/manual_storage_model.dart';
import 'package:ubuntu_bootstrap/pages/storage/manual/storage_types.dart';
import 'package:yaru/icons.dart';

typedef DiskBuilder = Widget Function(BuildContext context, Disk disk);
typedef GapBuilder = Widget Function(BuildContext context, Disk disk, Gap gap);
typedef PartitionBuilder = Widget Function(
  BuildContext context,
  Disk disk,
  Partition partition,
);

class StorageColumn {
  const StorageColumn({
    required this.titleBuilder,
    required this.diskBuilder,
    required this.gapBuilder,
    required this.partitionBuilder,
  });

  final WidgetBuilder titleBuilder;
  final DiskBuilder diskBuilder;
  final GapBuilder gapBuilder;
  final PartitionBuilder partitionBuilder;
}

class StorageDeviceColumn extends StorageColumn {
  StorageDeviceColumn()
      : super(
          titleBuilder: (context) {
            final lang = UbuntuBootstrapLocalizations.of(context);
            return Semantics(
              header: true,
              child: Text(lang.diskHeadersDevice),
            );
          },
          diskBuilder: (context, disk) {
            return Semantics(
              label: 'Disk device: ${disk.sysname}',
              child: Row(
                children: [
                  const Icon(YaruIcons.drive_harddisk_filled),
                  const SizedBox(width: 16),
                  Text(disk.sysname),
                ],
              ),
            );
          },
          gapBuilder: (context, disk, gap) {
            final lang = UbuntuBootstrapLocalizations.of(context);
            final color = gap.tooManyPrimaryPartitions
                ? Theme.of(context).disabledColor
                : null;
            return Semantics(
              label: gap.tooManyPrimaryPartitions
                  ? 'Error: Too many primary partitions'
                  : 'Free disk space',
              child: Tooltip(
                message: gap.tooManyPrimaryPartitions
                    ? lang.tooManyPrimaryPartitions
                    : '',
                child: Row(
                  children: [
                    Icon(
                      gap.tooManyPrimaryPartitions
                          ? YaruIcons.drive_harddisk_error
                          : YaruIcons.drive_harddisk,
                      color: color,
                    ),
                    const SizedBox(width: 16),
                    Text(
                      gap.tooManyPrimaryPartitions
                          ? lang.partitionLimitReached
                          : lang.freeDiskSpace,
                      style: TextStyle(color: color),
                    ),
                  ],
                ),
              ),
            );
          },
          partitionBuilder: (context, disk, partition) {
            return Semantics(
              label: 'Partition device: ${partition.sysname}${partition.isEncrypted ? ', encrypted' : ''}',
              child: Row(
                children: [
                  Icon(
                    partition.isEncrypted
                        ? YaruIcons.lock
                        : YaruIcons.drive_harddisk,
                  ),
                  const SizedBox(width: 16),
                  Text(partition.sysname),
                ],
              ),
            );
          },
        );
}

class StorageTypeColumn extends StorageColumn {
  StorageTypeColumn()
      : super(
          titleBuilder: (context) {
            final lang = UbuntuBootstrapLocalizations.of(context);
            return Semantics(
              header: true,
              child: Text(lang.diskHeadersType),
            );
          },
          diskBuilder: (context, disk) {
            return const SizedBox.shrink();
          },
          gapBuilder: (context, disk, gap) {
            return const SizedBox.shrink();
          },
          partitionBuilder: (context, disk, partition) {
            final formatName = PartitionFormat.fromPartition(partition)?.displayName ??
                partition.format ??
                '';
            return Semantics(
              label: 'Type: $formatName',
              child: Text(formatName),
            );
          },
        );
}

class StorageMountColumn extends StorageColumn {
  StorageMountColumn()
      : super(
          titleBuilder: (context) {
            final lang = UbuntuBootstrapLocalizations.of(context);
            return Semantics(
              header: true,
              child: Text(lang.diskHeadersMountPoint),
            );
          },
          diskBuilder: (context, disk) {
            return const SizedBox.shrink();
          },
          gapBuilder: (context, disk, gap) {
            return const SizedBox.shrink();
          },
          partitionBuilder: (context, disk, partition) {
            final mountPoint = partition.mount ?? '';
            return Semantics(
              label: 'Mount point: ${mountPoint.isEmpty ? 'none' : mountPoint}',
              child: Text(mountPoint),
            );
          },
        );
}

class StorageSizeColumn extends StorageColumn {
  StorageSizeColumn()
      : super(
          titleBuilder: (context) {
            final lang = UbuntuBootstrapLocalizations.of(context);
            return Semantics(
              header: true,
              child: Text(lang.diskHeadersSize),
            );
          },
          diskBuilder: (context, disk) {
            return Semantics(
              label: 'Disk size: ${context.formatByteSize(disk.size)}',
              child: Text(context.formatByteSize(disk.size)),
            );
          },
          gapBuilder: (context, disk, gap) {
            final lang = UbuntuBootstrapLocalizations.of(context);
            final color = gap.tooManyPrimaryPartitions
                ? Theme.of(context).disabledColor
                : null;
            return Semantics(
              label: 'Free space: ${context.formatByteSize(gap.size)}${gap.tooManyPrimaryPartitions ? ', too many primary partitions' : ''}',
              child: Tooltip(
                message: gap.tooManyPrimaryPartitions
                    ? lang.tooManyPrimaryPartitions
                    : '',
                child: Text(
                  context.formatByteSize(gap.size),
                  style: TextStyle(color: color),
                ),
              ),
            );
          },
          partitionBuilder: (context, disk, partition) {
            return Semantics(
              label: 'Partition size: ${context.formatByteSize(partition.size ?? 0)}',
              child: Text(context.formatByteSize(partition.size ?? 0)),
            );
          },
        );
}

class StorageSystemColumn extends StorageColumn {
  StorageSystemColumn()
      : super(
          titleBuilder: (context) {
            final lang = UbuntuBootstrapLocalizations.of(context);
            return Semantics(
              header: true,
              child: Text(lang.diskHeadersSystem),
            );
          },
          diskBuilder: (context, disk) {
            return const SizedBox.shrink();
          },
          gapBuilder: (context, disk, gap) {
            return const SizedBox.shrink();
          },
          partitionBuilder: (context, disk, partition) {
            final systemName = partition.os?.long ?? '';
            return Semantics(
              label: 'System: ${systemName.isEmpty ? 'none' : systemName}',
              child: Text(systemName),
            );
          },
        );
}

class StorageWipeColumn extends StorageColumn {
  StorageWipeColumn({required this.onWipe})
      : super(
          titleBuilder: (context) {
            final lang = UbuntuBootstrapLocalizations.of(context);
            return Semantics(
              header: true,
              child: Text(lang.diskHeadersFormat),
            );
          },
          diskBuilder: (context, disk) {
            return const SizedBox.shrink();
          },
          gapBuilder: (context, disk, gap) {
            return const SizedBox.shrink();
          },
          partitionBuilder: (context, disk, partition) {
            return Consumer(
              builder: (context, ref, child) {
                final model = ref.read(manualStorageModelProvider);
                final config = model.originalConfig(partition);
                final forceWipe = config?.mustWipe(partition.format) ?? true;
                final isWiped = partition.isWiped || forceWipe;
                return Semantics(
                  label: 'Format: ${isWiped ? 'selected' : 'not selected'}',
                  child: Icon(
                    isWiped
                        ? YaruIcons.checkbox_checked_filled
                        : YaruIcons.checkbox,
                  ),
                );
              },
            );
          },
        );

  final void Function(Disk disk, Partition partition, bool wipe) onWipe;
}