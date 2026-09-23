import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../data/models/jaap_profile.dart';
import '../../../state/jaap_controller.dart';
import '../../library/mantra_library_sheet.dart';

class ProfileSheet extends StatefulWidget {
  final JaapController jaapController;

  const ProfileSheet({
    super.key,
    required this.jaapController,
  });

  @override
  State<ProfileSheet> createState() => _ProfileSheetState();
}

class _ProfileSheetState extends State<ProfileSheet> {
  bool _isCreating = false;
  JaapProfile? _editingProfile;

  // Form fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _originalTextController = TextEditingController();
  int _malaSize = 108;
  int _dailyGoal = 108;
  int _selectedAccentIndex = 0;

  @override
  void dispose() {
    _nameController.dispose();
    _originalTextController.dispose();
    super.dispose();
  }

  void _startCreate({JaapProfile? editProfile}) {
    setState(() {
      _isCreating = true;
      _editingProfile = editProfile;
      if (editProfile != null) {
        _nameController.text = editProfile.name;
        _originalTextController.text = editProfile.originalText;
        _malaSize = editProfile.malaSize;
        _dailyGoal = editProfile.dailyGoal;
        final idx = AppColors.accents.indexWhere((a) => a.hex == editProfile.accentColorHex);
        _selectedAccentIndex = idx >= 0 ? idx : 0;
      } else {
        _nameController.clear();
        _originalTextController.clear();
        _malaSize = 108;
        _dailyGoal = 108;
        _selectedAccentIndex = 0;
      }
    });
  }

  void _saveProfile() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    final accentHex = AppColors.getAccent(_selectedAccentIndex).hex;

    if (_editingProfile != null) {
      final updated = _editingProfile!.copyWith(
        name: name,
        originalText: _originalTextController.text.trim(),
        malaSize: _malaSize,
        dailyGoal: _dailyGoal,
        accentColorHex: accentHex,
      );
      widget.jaapController.updateProfile(updated);
    } else {
      final newProfile = JaapProfile(
        id: 'jaap_${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        originalText: _originalTextController.text.trim(),
        transliteration: name,
        malaSize: _malaSize,
        dailyGoal: _dailyGoal,
        accentColorHex: accentHex,
        createdAt: DateTime.now(),
      );
      widget.jaapController.addProfile(newProfile);
    }

    setState(() {
      _isCreating = false;
      _editingProfile = null;
    });
  }

  void _openMantraLibrary() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => MantraLibrarySheet(
        onSelectMantra: (item) {
          _nameController.text = item.name;
          _originalTextController.text = item.originalScript;
          setState(() {
            _malaSize = item.defaultMalaSize;
            _dailyGoal = item.defaultMalaSize;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      padding: const EdgeInsets.only(top: 16, bottom: 24),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: _isCreating ? _buildCreateOrEditForm(l10n, isDark) : _buildProfileList(l10n, isDark),
      ),
    );
  }

  Widget _buildProfileList(AppLocalizations l10n, bool isDark) {
    final activeId = widget.jaapController.activeProfile?.id;
    final profiles = widget.jaapController.profiles;

    return Column(
      key: const ValueKey('list'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  l10n.translate('navJaap'),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              const SizedBox(width: 8),
              TextButton.icon(
                onPressed: () => _startCreate(),
                icon: const Icon(Icons.add_rounded, size: 18),
                label: Text(l10n.translate('add')),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Flexible(
          child: ListView.separated(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            itemCount: profiles.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final profile = profiles[index];
              final isSelected = profile.id == activeId;
              final accentColor = AppColors.parseHex(profile.accentColorHex);

              return InkWell(
                onTap: () {
                  widget.jaapController.setActiveProfile(profile.id);
                  Navigator.pop(context);
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? accentColor.withValues(alpha: 0.12)
                        : (isDark ? AppColors.darkSurface : AppColors.lightSurface),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? accentColor
                          : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: accentColor,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profile.name,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${profile.malaSize} ${l10n.translate('mala')} • ${profile.totalLifetimeCount} ${l10n.translate('jaaps')}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, size: 18),
                        onPressed: () => _startCreate(editProfile: profile),
                      ),
                      if (profiles.length > 1)
                        IconButton(
                          icon: const Icon(Icons.delete_outline_rounded, size: 18),
                          onPressed: () => _confirmDelete(profile),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCreateOrEditForm(AppLocalizations l10n, bool isDark) {
    return SingleChildScrollView(
      key: const ValueKey('form'),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: () => setState(() => _isCreating = false),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  _editingProfile != null
                      ? l10n.translate('editJaap')
                      : l10n.translate('createJaap'),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              const SizedBox(width: 8),
              TextButton.icon(
                onPressed: _openMantraLibrary,
                icon: const Icon(Icons.auto_stories_outlined, size: 16),
                label: Text(l10n.translate('library')),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: l10n.translate('mantraNameHint'),
              filled: true,
              fillColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _originalTextController,
            decoration: InputDecoration(
              labelText: 'Original Script (Optional)',
              hintText: 'e.g. ॐ नमः शिवाय',
              filled: true,
              fillColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            '${l10n.translate('mala')} ($_malaSize)',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Row(
            children: [27, 54, 108].map((size) {
              final isSel = _malaSize == size;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: OutlinedButton(
                    onPressed: () => setState(() => _malaSize = size),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: isSel
                          ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.15)
                          : null,
                      side: BorderSide(
                        color: isSel
                            ? Theme.of(context).colorScheme.primary
                            : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                      ),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text('$size'),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.translate('dailyGoal'),
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              Text(
                '$_dailyGoal ${l10n.translate('jaaps')}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          Slider(
            value: _dailyGoal.toDouble(),
            min: 0,
            max: 1080,
            divisions: 20,
            label: '$_dailyGoal',
            onChanged: (val) => setState(() => _dailyGoal = val.round()),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.translate('accent'),
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: AppColors.accents.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final accent = AppColors.accents[index];
                final isSelected = _selectedAccentIndex == index;

                return GestureDetector(
                  onTap: () => setState(() => _selectedAccentIndex = index),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: accent.color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? Colors.white : Colors.transparent,
                        width: 2.5,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: accent.color.withValues(alpha: 0.5),
                                blurRadius: 6,
                                spreadRadius: 1,
                              )
                            ]
                          : null,
                    ),
                    child: isSelected
                        ? const Icon(Icons.check_rounded, color: Colors.white, size: 20)
                        : null,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: FilledButton(
              onPressed: _saveProfile,
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: Text(
                l10n.translate('save'),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(JaapProfile profile) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.translate('deleteJaap')),
        content: Text(l10n.translate('deleteConfirm')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.translate('cancel')),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              widget.jaapController.deleteProfile(profile.id);
            },
            child: Text(
              l10n.translate('delete'),
              style: const TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }
}
