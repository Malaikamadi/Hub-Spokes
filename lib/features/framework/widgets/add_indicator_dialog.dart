import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/models/dashboard_models.dart';
import '../../../../core/data/mock_data.dart';

class AddIndicatorDialog extends StatefulWidget {
  final VoidCallback onAdded;

  const AddIndicatorDialog({super.key, required this.onAdded});

  @override
  State<AddIndicatorDialog> createState() => _AddIndicatorDialogState();
}

class _AddIndicatorDialogState extends State<AddIndicatorDialog> {
  final _formKey = GlobalKey<FormState>();
  String _selectedLevel = 'Outcome Level';
  
  final _nameController = TextEditingController();
  final _definitionController = TextEditingController();
  final _frequencyController = TextEditingController(text: 'Quarterly');
  final _targetController = TextEditingController();
  final _sourceController = TextEditingController();

  final List<String> _levels = [
    'Impact Level',
    'Outcome Level',
    'Output Level',
    'Input/Process Level',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _definitionController.dispose();
    _frequencyController.dispose();
    _targetController.dispose();
    _sourceController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Find the correct level
      final levelIndex = MockData.frameworkLevels.indexWhere((l) => l.name == _selectedLevel);
      if (levelIndex != -1) {
        final level = MockData.frameworkLevels[levelIndex];
        
        // Count total current indicators across all levels to get a new arbitrary number
        int highestNumber = 0;
        for (var l in MockData.frameworkLevels) {
          for (var ind in l.indicators) {
            if (ind.number > highestNumber) highestNumber = ind.number;
          }
        }

        final newIndicator = IndicatorItem(
          number: highestNumber + 1,
          name: _nameController.text.trim(),
          definition: _definitionController.text.trim(),
          frequency: _frequencyController.text.trim(),
          target: _targetController.text.trim(),
          source: _sourceController.text.trim(),
        );

        // Update the mock data lists to simulate adding
        final updatedIndicators = List<IndicatorItem>.from(level.indicators)..add(newIndicator);
        
        MockData.frameworkLevels[levelIndex] = FrameworkLevel(
          name: level.name,
          indicatorCount: level.indicatorCount + 1,
          indicators: updatedIndicators,
        );

        widget.onAdded();
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: AppColors.cardBg,
      child: Container(
        width: 600,
        padding: const EdgeInsets.all(32),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Add New Indicator',
                    style: GoogleFonts.inter(
                      color: AppColors.textPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.textSecondary),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildDropdownField('Framework Level', _selectedLevel, _levels, (val) {
                if (val != null) setState(() => _selectedLevel = val);
              }),
              const SizedBox(height: 16),
              _buildTextField('Indicator Name', 'e.g., Number of ANC Visits', _nameController, maxLines: 1),
              const SizedBox(height: 16),
              _buildTextField('Definition / Calculation', 'e.g., Total measured over period...', _definitionController, maxLines: 2),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildTextField('Frequency', 'e.g., Quarterly', _frequencyController, maxLines: 1)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildTextField('Target', 'e.g., 20,000', _targetController, maxLines: 1)),
                ],
              ),
              const SizedBox(height: 16),
              _buildTextField('Data Source', 'e.g., DHIS2, Facility Registers', _sourceController, maxLines: 1),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.inter(color: AppColors.textSecondary),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(
                      'Add Indicator',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField(String label, String value, List<String> items, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            color: AppColors.textPrimary,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.scaffoldBg,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.cardBorder),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: value,
              icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textSecondary),
              dropdownColor: AppColors.cardBg,
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: GoogleFonts.inter(color: AppColors.textPrimary, fontSize: 14),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, String hint, TextEditingController controller, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            color: AppColors.textPrimary,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          validator: (value) => value == null || value.trim().isEmpty ? 'Required' : null,
          style: GoogleFonts.inter(fontSize: 14, color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.inter(color: AppColors.textMuted, fontSize: 14),
            filled: true,
            fillColor: AppColors.scaffoldBg,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.cardBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.cardBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
          ),
        ),
      ],
    );
  }
}
