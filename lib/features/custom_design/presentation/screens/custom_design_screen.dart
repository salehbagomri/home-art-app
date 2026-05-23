import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/widgets/ha_app_bar.dart';
import '../../../../core/widgets/ha_button.dart';
import '../../../../core/widgets/ha_card.dart';
import '../bloc/custom_design_bloc.dart';
import '../bloc/custom_design_event.dart';
import '../bloc/custom_design_state.dart';

class CustomDesignScreen extends StatefulWidget {
  const CustomDesignScreen({super.key});

  @override
  State<CustomDesignScreen> createState() => _CustomDesignScreenState();
}

class _CustomDesignScreenState extends State<CustomDesignScreen> {
  final _widthCtrl = TextEditingController();
  final _lengthCtrl = TextEditingController();
  final _heightCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  final List<String> _stepperLabels = [
    'المساحة',
    'الصور',
    'القياسات',
    'المواد',
    'الملاحظات',
    'الملخص',
    'التأكيد'
  ];

  final List<Map<String, dynamic>> _spaceTypes = [
    {'name': 'غرفة نوم', 'icon': Iconsax.home_1},
    {'name': 'غرفة معيشة', 'icon': Iconsax.home},
    {'name': 'مجلس', 'icon': Iconsax.lamp},
    {'name': 'مطبخ', 'icon': Iconsax.cup},
    {'name': 'مكتب', 'icon': Iconsax.monitor},
    {'name': 'أخرى', 'icon': Iconsax.category},
  ];

  final List<String> _materialOptions = ['خشب', 'رخام', 'قماش', 'معدن'];
  final List<String> _colorOptions = ['#E8DCC8', '#17130F', '#6B543E', '#BDA36D', '#4F6F55'];
  final List<String> _styleOptions = ['حديث', 'نيو كلاسيك', 'كلاسيكي', 'اسكندنافي'];

  final List<String> _quickSuggestions = [
    'أريد فخامة كلاسيكية',
    'ألوان ترابية فقط',
    'التركيز على الإضاءة الطبيعية',
    'توفير مساحات تخزين ذكية'
  ];

  @override
  void dispose() {
    _widthCtrl.dispose();
    _lengthCtrl.dispose();
    _heightCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CustomDesignBloc(),
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBg,
        appBar: const HaAppBar(showBackButton: true),
        body: BlocBuilder<CustomDesignBloc, CustomDesignState>(
          builder: (context, state) {
            return Column(
              children: [
                // 1. Fixed Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppDimensions.screenPaddingH,
                    AppDimensions.screenPaddingV,
                    AppDimensions.screenPaddingH,
                    0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.customDesignTitle,
                        style: AppTextStyles.headlineSmall,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        AppStrings.customDesignHint,
                        style: AppTextStyles.caption.copyWith(color: AppColors.woodBrown),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingM),

                // 2. Custom Stepper (7 steps)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  height: 65,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(7, (index) {
                      final isCompleted = index < state.currentStep;
                      final isCurrent = index == state.currentStep;

                      return Expanded(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                    color: index == 0
                                        ? Colors.transparent
                                        : (isCompleted || isCurrent ? AppColors.gold : AppColors.cardBorder),
                                    thickness: 2,
                                  ),
                                ),
                                Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isCompleted || isCurrent ? AppColors.gold : AppColors.white,
                                    border: Border.all(
                                      color: isCompleted || isCurrent ? AppColors.gold : AppColors.cardBorder,
                                      width: 2,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: isCompleted
                                      ? const Icon(Icons.check, color: AppColors.white, size: 14)
                                      : Text(
                                          '${index + 1}',
                                          style: TextStyle(
                                            color: isCurrent ? AppColors.white : AppColors.subtleText,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                ),
                                Expanded(
                                  child: Divider(
                                    color: index == 6
                                        ? Colors.transparent
                                        : (isCompleted ? AppColors.gold : AppColors.cardBorder),
                                    thickness: 2,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _stepperLabels[index],
                              style: TextStyle(
                                fontSize: 9,
                                color: isCurrent ? AppColors.gold : AppColors.subtleText,
                                fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingM),

                // 3. Dynamic Form Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: AppDimensions.screenPaddingH),
                    child: _buildStepContent(context, state),
                  ),
                ),

                // 4. Bottom action buttons (always visible)
                if (state.currentStep < 6)
                  Container(
                    padding: const EdgeInsets.all(AppDimensions.paddingL),
                    decoration: const BoxDecoration(
                      color: AppColors.white,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.shadowColor,
                          blurRadius: 8,
                          offset: Offset(0, -2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            if (state.currentStep > 0) ...[
                              Expanded(
                                flex: 3,
                                child: HaButton.outlined(
                                  text: AppStrings.previous,
                                  onPressed: () {
                                    context.read<CustomDesignBloc>().add(PreviousStepRequested());
                                  },
                                ),
                              ),
                              const SizedBox(width: AppDimensions.spacingM),
                            ],
                            Expanded(
                              flex: 7,
                              child: HaButton.primary(
                                text: AppStrings.next,
                                icon: const Icon(Iconsax.arrow_left, color: AppColors.white, size: 18),
                                onPressed: () {
                                  // Update inputs depending on step
                                  if (state.currentStep == 2) {
                                    final w = double.tryParse(_widthCtrl.text) ?? 0.0;
                                    final l = double.tryParse(_lengthCtrl.text) ?? 0.0;
                                    final h = double.tryParse(_heightCtrl.text) ?? 0.0;
                                    context.read<CustomDesignBloc>().add(
                                          DimensionUpdated(width: w, length: l, height: h),
                                        );
                                  } else if (state.currentStep == 4) {
                                    context.read<CustomDesignBloc>().add(
                                          NotesChanged(_notesCtrl.text),
                                        );
                                  }
                                  context.read<CustomDesignBloc>().add(NextStepRequested());
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Iconsax.lock, size: 14, color: AppColors.subtleText),
                            SizedBox(width: 4),
                            Text(
                              AppStrings.requestEncrypted,
                              style: TextStyle(fontSize: 10, color: AppColors.subtleText),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildStepContent(BuildContext context, CustomDesignState state) {
    switch (state.currentStep) {
      case 0:
        return _buildStep1SpaceType(context, state);
      case 1:
        return _buildStep2Photos(context, state);
      case 2:
        return _buildStep3Dimensions(context, state);
      case 3:
        return _buildStep4MaterialsColors(context, state);
      case 4:
        return _buildStep5Notes(context, state);
      case 5:
        return _buildStep6Summary(context, state);
      case 6:
        return _buildStep7Confirm(context, state);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildStep1SpaceType(BuildContext context, CustomDesignState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.step1SpaceType, style: AppTextStyles.headlineSmall),
        const SizedBox(height: AppDimensions.spacingM),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.1,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: _spaceTypes.length,
          itemBuilder: (context, index) {
            final type = _spaceTypes[index];
            final isSelected = state.spaceType == type['name'];

            return HaCard(
              padding: EdgeInsets.zero,
              showBorder: true,
              color: isSelected ? AppColors.galleryCream : AppColors.white,
              onTap: () {
                context.read<CustomDesignBloc>().add(SpaceTypeSelected(type['name']));
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                  border: Border.all(
                    color: isSelected ? AppColors.gold : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      type['icon'],
                      size: 32,
                      color: isSelected ? AppColors.gold : AppColors.woodBrown,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      type['name'],
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? AppColors.gold : AppColors.nightBrown,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildStep2Photos(BuildContext context, CustomDesignState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.step2Photos, style: AppTextStyles.headlineSmall),
        const SizedBox(height: AppDimensions.spacingM),
        Row(
          children: [
            // Upload button
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.gold, style: BorderStyle.values[0] /* wait, standard border */),
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                color: AppColors.white,
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Iconsax.camera, color: AppColors.gold, size: 24),
                  SizedBox(height: 4),
                  Text('إضافة صورة', style: TextStyle(fontSize: 10, color: AppColors.gold)),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Mock Uploaded Image
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                image: const DecorationImage(
                  image: AssetImage('App_Assets/1.jpeg'),
                  fit: BoxFit.cover,
                ),
              ),
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(Icons.cancel, color: AppColors.error, size: 18),
                onPressed: () {},
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.spacingXL),
        Text(
          AppStrings.photoLimit,
          style: AppTextStyles.caption.copyWith(color: AppColors.subtleText),
        ),
      ],
    );
  }

  Widget _buildStep3Dimensions(BuildContext context, CustomDesignState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.step3Dimensions, style: AppTextStyles.headlineSmall),
        const SizedBox(height: AppDimensions.spacingM),

        // Dimensions input
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _widthCtrl,
                keyboardType: TextInputType.number,
                style: AppTextStyles.bodyMedium,
                decoration: const InputDecoration(hintText: AppStrings.width),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: _lengthCtrl,
                keyboardType: TextInputType.number,
                style: AppTextStyles.bodyMedium,
                decoration: const InputDecoration(hintText: AppStrings.length),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: _heightCtrl,
                keyboardType: TextInputType.number,
                style: AppTextStyles.bodyMedium,
                decoration: const InputDecoration(hintText: AppStrings.height),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.spacingXL),

        // Diagram layout mock button
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Iconsax.ruler, size: 18),
          label: const Text('رسم تخطيطي للمساحة (اختياري)'),
        ),
      ],
    );
  }

  Widget _buildStep4MaterialsColors(BuildContext context, CustomDesignState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.step4Materials, style: AppTextStyles.headlineSmall),
        const SizedBox(height: AppDimensions.spacingXL),

        // Preferred Materials
        Text(AppStrings.preferredMaterials, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: AppDimensions.spacingS),
        Row(
          children: _materialOptions.map((mat) {
            final isSelected = state.preferredMaterials.contains(mat);
            return Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: ChoiceChip(
                selected: isSelected,
                label: Text(mat),
                selectedColor: AppColors.gold,
                labelStyle: AppTextStyles.caption.copyWith(
                  color: isSelected ? AppColors.white : AppColors.nightBrown,
                ),
                onSelected: (val) {
                  context.read<CustomDesignBloc>().add(MaterialToggled(mat));
                },
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: AppDimensions.spacingXL),

        // Preferred Colors
        Text(AppStrings.preferredColors, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: AppDimensions.spacingS),
        Row(
          children: _colorOptions.map((colorHex) {
            final isSelected = state.preferredColors.contains(colorHex);
            return GestureDetector(
              onTap: () {
                context.read<CustomDesignBloc>().add(ColorToggled(colorHex));
              },
              child: Container(
                margin: const EdgeInsets.only(left: 12),
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? AppColors.gold : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(int.parse(colorHex.replaceFirst('#', '0xFF'))),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: AppDimensions.spacingXL),

        // Style Preference
        Text(AppStrings.preferredStyle, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: AppDimensions.spacingS),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _styleOptions.map((style) {
            final isSelected = state.preferredStyle == style;
            return GestureDetector(
              onTap: () {
                context.read<CustomDesignBloc>().add(PreferredStyleSelected(style));
              },
              child: Container(
                width: (MediaQuery.of(context).size.width - 44) / 2,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  border: Border.all(
                    color: isSelected ? AppColors.gold : AppColors.cardBorder,
                    width: isSelected ? 2 : 1,
                  ),
                  image: const DecorationImage(
                    image: AssetImage('App_Assets/12.jpeg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.black.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM - 2),
                  ),
                  child: Text(
                    style,
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildStep5Notes(BuildContext context, CustomDesignState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.step5Notes, style: AppTextStyles.headlineSmall),
        const SizedBox(height: AppDimensions.spacingM),

        // Text Area
        TextFormField(
          controller: _notesCtrl,
          maxLines: 5,
          style: AppTextStyles.bodyMedium,
          decoration: const InputDecoration(
            hintText: AppStrings.additionalNotesHint,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingL),

        // Quick suggestions
        Wrap(
          spacing: 8,
          children: _quickSuggestions.map((sug) {
            return ActionChip(
              label: Text(sug),
              labelStyle: AppTextStyles.caption.copyWith(color: AppColors.nightBrown),
              onPressed: () {
                final currentText = _notesCtrl.text;
                if (currentText.isEmpty) {
                  _notesCtrl.text = sug;
                } else {
                  _notesCtrl.text = '$currentText، $sug';
                }
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildStep6Summary(BuildContext context, CustomDesignState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.step6Summary, style: AppTextStyles.headlineSmall),
        const SizedBox(height: AppDimensions.spacingM),

        HaCard(
          child: Column(
            children: [
              _buildSummaryRow('نوع المساحة', state.spaceType),
              const Divider(height: 24),
              _buildSummaryRow('المقاسات', '${state.width} x ${state.length} x ${state.height} م'),
              const Divider(height: 24),
              _buildSummaryRow('المواد المفضلة', state.preferredMaterials.join('، ')),
              const Divider(height: 24),
              _buildSummaryRow('النمط المفضل', state.preferredStyle),
              if (state.notes.isNotEmpty) ...[
                const Divider(height: 24),
                _buildSummaryRow('ملاحظات إضافية', state.notes),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacingXL),

        HaButton.primary(
          text: AppStrings.submitDesignRequest,
          isLoading: state.isSubmitting,
          icon: const Icon(Iconsax.send_2, color: AppColors.white, size: 18),
          onPressed: () {
            context.read<CustomDesignBloc>().add(SubmitDesignRequest());
          },
        ),
      ],
    );
  }

  Widget _buildStep7Confirm(BuildContext context, CustomDesignState state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          const Icon(
            Iconsax.tick_circle,
            color: AppColors.guaranteeGreen,
            size: 80,
          ),
          const SizedBox(height: AppDimensions.spacingXL),
          Text(
            'تم إرسال طلبك بنجاح!',
            style: AppTextStyles.headlineMedium,
          ),
          const SizedBox(height: AppDimensions.spacingM),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingL),
            child: Text(
              'سيقوم مهندسونا ومصممونا بمراجعة طلبك والتواصل معك عبر الواتساب أو الهاتف خلال 24 ساعة لتقديم عرض السعر والتصميم الأولي.',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.woodBrown),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingHuge),
          HaButton.primary(
            text: 'العودة للرئيسية',
            width: 200,
            onPressed: () => context.go(AppRoutes.home),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.subtleText)),
        Text(value.isNotEmpty ? value : 'لم يتم التحديد', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
