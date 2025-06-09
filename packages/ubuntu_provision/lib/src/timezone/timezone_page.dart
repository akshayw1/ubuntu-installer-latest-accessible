import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone_map/timezone_map.dart';
import 'package:ubuntu_provision/interfaces.dart';
import 'package:ubuntu_provision/src/timezone/timezone_l10n.dart';
import 'package:ubuntu_provision/src/timezone/timezone_model.dart';
import 'package:ubuntu_wizard/ubuntu_wizard.dart';
import 'package:yaru/yaru.dart';

/// https://github.com/canonical/ubuntu-desktop-installer/issues/38
class TimezonePage extends ConsumerStatefulWidget with ProvisioningPage {
  const TimezonePage({super.key});

  @override
  ConsumerState<TimezonePage> createState() => _TimezonePageState();

  @override
  Future<bool> load(BuildContext context, WidgetRef ref) {
    return Future.wait([
      TimezoneMap.precacheAssets(context),
      ref.read(timezoneModelProvider).init(),
    ]).then((_) => true);
  }

  static String formatLocation(GeoLocation? location) {
    return location?.toDisplayString() ?? '';
  }

  static String formatTimezone(GeoLocation? location) {
    return location?.toTimezoneString() ?? '';
  }
}

class _TimezonePageState extends ConsumerState<TimezonePage> {
  // Focus node for initial focus
  final FocusNode _initialFocusNode = FocusNode();
  
  // Controllers for text fields
  late TextEditingController _locationController;
  late TextEditingController _timezoneController;
  
  // For managing dropdown state
  List<GeoLocation> _locationSuggestions = [];
  List<GeoLocation> _timezoneSuggestions = [];
  bool _showLocationDropdown = false;
  bool _showTimezoneDropdown = false;

  @override
  void initState() {
    super.initState();
    
    final model = ref.read(timezoneModelProvider);
    _locationController = TextEditingController(
      text: TimezonePage.formatLocation(model.selectedLocation),
    );
    _timezoneController = TextEditingController(
      text: TimezonePage.formatTimezone(model.selectedLocation),
    );
    
    // Announce the page when it loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      
      // Ensure semantics are enabled
      WidgetsBinding.instance.ensureSemantics();
      
      final lang = TimezoneLocalizations.of(context);
      
      // Request focus to ensure Orca is active
      _initialFocusNode.requestFocus();
      
      // Main announcement with delay to ensure Orca catches it
      Future.delayed(const Duration(milliseconds: 100), () {
        if (!mounted) return;
        
        SemanticsService.announce(
          'Select your timezone. ${lang.timezonePageTitle}. You can search for a city or timezone, or click on the map.',
          TextDirection.ltr,
          assertiveness: Assertiveness.assertive,
        );
        
        // Announce current selection if any
        if (model.selectedLocation != null) {
          Future.delayed(const Duration(milliseconds: 600), () {
            if (!mounted) return;
            
            final location = TimezonePage.formatLocation(model.selectedLocation);
            final timezone = TimezonePage.formatTimezone(model.selectedLocation);
            
            SemanticsService.announce(
              'Currently selected: $location, $timezone',
              TextDirection.ltr,
            );
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _initialFocusNode.dispose();
    _locationController.dispose();
    _timezoneController.dispose();
    super.dispose();
  }

  Widget _buildAccessibleLocationField(BuildContext context) {
    final lang = TimezoneLocalizations.of(context);
    final model = ref.watch(timezoneModelProvider);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          label: 'Location search. Current value: ${_locationController.text.isEmpty ? "empty" : _locationController.text}',
          hint: 'Type to search for a city. Use arrow keys to navigate suggestions.',
          textField: true,
          child: TextField(
            controller: _locationController,
            decoration: InputDecoration(
              labelText: lang.timezoneLocationLabel,
              hintText: 'Search for a city...',
              suffixIcon: Icon(Icons.search),
            ),
            onChanged: (value) async {
              if (value.isEmpty) {
                setState(() {
                  _showLocationDropdown = false;
                  _locationSuggestions = [];
                });
                return;
              }
              
              final suggestions = await model.searchLocation(value);
              setState(() {
                _locationSuggestions = suggestions.take(5).toList();
                _showLocationDropdown = _locationSuggestions.isNotEmpty;
              });
              
              if (_locationSuggestions.isNotEmpty && mounted) {
                SemanticsService.announce(
                  '${_locationSuggestions.length} suggestions found. Use down arrow to navigate.',
                  TextDirection.ltr,
                );
              }
            },
            onSubmitted: (value) {
              if (_locationSuggestions.isNotEmpty) {
                _selectLocation(_locationSuggestions.first);
              }
            },
          ),
        ),
        if (_showLocationDropdown)
          Semantics(
            label: 'Location suggestions list',
            hint: 'Use arrow keys to navigate, Enter to select',
            child: Container(
              constraints: BoxConstraints(maxHeight: 200),
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).dividerColor),
                borderRadius: BorderRadius.circular(4),
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _locationSuggestions.length,
                itemBuilder: (context, index) {
                  final location = _locationSuggestions[index];
                  final locationText = TimezonePage.formatLocation(location);
                  
                  return Semantics(
                    label: 'Suggestion ${index + 1} of ${_locationSuggestions.length}: $locationText',
                    button: true,
                    child: InkWell(
                      onTap: () => _selectLocation(location),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Text(locationText),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildAccessibleTimezoneField(BuildContext context) {
    final lang = TimezoneLocalizations.of(context);
    final model = ref.watch(timezoneModelProvider);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          label: 'Timezone search. Current value: ${_timezoneController.text.isEmpty ? "empty" : _timezoneController.text}',
          hint: 'Type to search for a timezone. Use arrow keys to navigate suggestions.',
          textField: true,
          child: TextField(
            controller: _timezoneController,
            decoration: InputDecoration(
              labelText: lang.timezoneTimezoneLabel,
              hintText: 'Search for a timezone...',
              suffixIcon: Icon(Icons.access_time),
            ),
            onChanged: (value) async {
              if (value.isEmpty) {
                setState(() {
                  _showTimezoneDropdown = false;
                  _timezoneSuggestions = [];
                });
                return;
              }
              
              final suggestions = await model.searchTimezone(value);
              setState(() {
                _timezoneSuggestions = suggestions.take(5).toList();
                _showTimezoneDropdown = _timezoneSuggestions.isNotEmpty;
              });
              
              if (_timezoneSuggestions.isNotEmpty && mounted) {
                SemanticsService.announce(
                  '${_timezoneSuggestions.length} timezone suggestions found. Use down arrow to navigate.',
                  TextDirection.ltr,
                );
              }
            },
            onSubmitted: (value) {
              if (_timezoneSuggestions.isNotEmpty) {
                _selectTimezone(_timezoneSuggestions.first);
              }
            },
          ),
        ),
        if (_showTimezoneDropdown)
          Semantics(
            label: 'Timezone suggestions list',
            hint: 'Use arrow keys to navigate, Enter to select',
            child: Container(
              constraints: BoxConstraints(maxHeight: 200),
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).dividerColor),
                borderRadius: BorderRadius.circular(4),
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _timezoneSuggestions.length,
                itemBuilder: (context, index) {
                  final location = _timezoneSuggestions[index];
                  final timezoneText = TimezonePage.formatTimezone(location);
                  
                  return Semantics(
                    label: 'Suggestion ${index + 1} of ${_timezoneSuggestions.length}: $timezoneText',
                    button: true,
                    child: InkWell(
                      onTap: () => _selectTimezone(location),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Text(timezoneText),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
      ],
    );
  }

  void _selectLocation(GeoLocation location) {
    final model = ref.read(timezoneModelProvider);
    model.selectLocation(location);
    
    setState(() {
      _locationController.text = TimezonePage.formatLocation(location);
      _timezoneController.text = TimezonePage.formatTimezone(location);
      _showLocationDropdown = false;
      _locationSuggestions = [];
    });
    
    if (mounted) {
      SemanticsService.announce(
        'Selected location: ${TimezonePage.formatLocation(location)}',
        TextDirection.ltr,
      );
    }
  }

  void _selectTimezone(GeoLocation location) {
    final model = ref.read(timezoneModelProvider);
    model.selectTimezone(location);
    
    setState(() {
      _locationController.text = TimezonePage.formatLocation(location);
      _timezoneController.text = TimezonePage.formatTimezone(location);
      _showTimezoneDropdown = false;
      _timezoneSuggestions = [];
    });
    
    if (mounted) {
      SemanticsService.announce(
        'Selected timezone: ${TimezonePage.formatTimezone(location)}',
        TextDirection.ltr,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = TimezoneLocalizations.of(context);
    final model = ref.watch(timezoneModelProvider);

    // Update controllers when model changes
    if (!_locationController.text.contains(TimezonePage.formatLocation(model.selectedLocation))) {
      _locationController.text = TimezonePage.formatLocation(model.selectedLocation);
    }
    if (!_timezoneController.text.contains(TimezonePage.formatTimezone(model.selectedLocation))) {
      _timezoneController.text = TimezonePage.formatTimezone(model.selectedLocation);
    }

    return Focus(
      focusNode: _initialFocusNode,
      child: Semantics(
        label: 'Select your timezone page',
        container: true,
        child: WizardPage(
          title: YaruWindowTitleBar(
            title: Semantics(
              label: 'Select your timezone. ${lang.timezonePageTitle}',
              header: true,
              child: Text(lang.timezonePageTitle),
            ),
          ),
          contentPadding: EdgeInsets.zero,
          content: Column(
            children: <Widget>[
              // Hidden live region for announcements
              Semantics(
                liveRegion: true,
                hidden: true,
                child: Container(
                  height: 0,
                  child: const Text(
                    'Select your timezone',
                    style: TextStyle(fontSize: 0),
                  ),
                ),
              ),
              Padding(
                padding: kWizardPadding,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: _buildAccessibleLocationField(context),
                    ),
                    const SizedBox(width: kWizardSpacing),
                    Expanded(
                      child: _buildAccessibleTimezoneField(context),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: kWizardSpacing),
              Expanded(
                child: Semantics(
                  label: 'Timezone map. Click on the map to select your location',
                  hint: 'Interactive world map for timezone selection',
                  child: TimezoneMap(
                    size: TimezoneMapSize.medium,
                    offset: model.selectedLocation?.offset,
                    marker: model.selectedLocation?.coordinates,
                    onPressed: (coordinates) =>
                        model.searchMap(coordinates).then((location) {
                          if (location != null) {
                            _selectLocation(location);
                          }
                        }),
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
                label: model.selectedLocation?.timezone != null
                    ? 'Next button'
                    : 'Next button, disabled. Please select a timezone',
                enabled: model.selectedLocation?.timezone != null,
                child: NextWizardButton(
                  onNext: () async {
                    if (mounted) {
                      final location = TimezonePage.formatLocation(model.selectedLocation);
                      final timezone = TimezonePage.formatTimezone(model.selectedLocation);
                      SemanticsService.announce(
                        'Saving timezone: $location, $timezone',
                        TextDirection.ltr,
                      );
                    }
                    await ref.read(timezoneModelProvider).save();
                  },
                  enabled: model.selectedLocation?.timezone != null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension on TimezoneController {
  // Searches for the nearest location on the map but returns a simplified
  // location entry with the administration area and country details removed,
  // and the location name set to the name of the largest city in the timezone
  // to match the behavior of Ubiquity.
  //
  // This ensures that clicking around the timezone map keeps the pin as close
  // as possible to the clicked location (the timezone's largest city could be
  // far away), yet the presented textual result is not too granular i.e. not
  // some small unknown village but the timezone's largest city.
  Future<GeoLocation?> searchMap(LatLng coordinates) async {
    final location = await searchCoordinates(coordinates)
        .then((values) => values.firstOrNull);
    final timezone = await searchTimezone(location?.timezone ?? '')
        .then((values) => values.firstOrNull);
    return location?.copyWith(
      name: timezone?.name ?? location.name,
      admin: '',
      country: '',
    );
  }
}