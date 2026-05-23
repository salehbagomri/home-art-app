import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/widgets/ha_button.dart';
import '../../../../core/widgets/ha_card.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _loginFormKey = GlobalKey<FormState>();
  final _registerFormKey = GlobalKey<FormState>();

  final _loginUserCtrl = TextEditingController();
  final _loginPassCtrl = TextEditingController();
  final _regNameCtrl = TextEditingController();
  final _regPhoneCtrl = TextEditingController();
  final _regEmailCtrl = TextEditingController();
  final _regPassCtrl = TextEditingController();

  final ValueNotifier<bool> _obscureLoginPassword = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _obscureRegPassword = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _rememberMe = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _loginUserCtrl.dispose();
    _loginPassCtrl.dispose();
    _regNameCtrl.dispose();
    _regPhoneCtrl.dispose();
    _regEmailCtrl.dispose();
    _regPassCtrl.dispose();
    _obscureLoginPassword.dispose();
    _obscureRegPassword.dispose();
    _rememberMe.dispose();
    super.dispose();
  }

  void _submitLogin(BuildContext context) {
    if (_loginFormKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        LoginRequested(_loginUserCtrl.text.trim(), _loginPassCtrl.text),
      );
    }
  }

  void _submitRegister(BuildContext context) {
    if (_registerFormKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        RegisterRequested(
          name: _regNameCtrl.text.trim(),
          phone: _regPhoneCtrl.text.trim(),
          email: _regEmailCtrl.text.trim(),
          password: _regPassCtrl.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            context.go(AppRoutes.home);
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.message,
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.white),
                ),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return Scaffold(
            backgroundColor: AppColors.scaffoldBg,
            body: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // === المنطقة العلوية 30% ===
                    Container(
                      height: MediaQuery.of(context).size.height * 0.32,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [AppColors.galleryCream, AppColors.scaffoldBg],
                        ),
                      ),
                      child: SafeArea(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              AppAssets.inPageLogo,
                              height: 70,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(height: AppDimensions.spacingM),
                            Text(
                              AppStrings.welcomeTitle,
                              style: AppTextStyles.headlineSmall,
                            ),
                            const SizedBox(height: AppDimensions.spacingXS),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingXL),
                              child: Text(
                                AppStrings.welcomeSubtitle,
                                style: AppTextStyles.bodySmall.copyWith(color: AppColors.woodBrown),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // === بطاقة النموذج ===
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.screenPaddingH,
                        vertical: AppDimensions.paddingS,
                      ),
                      child: HaCard(
                        padding: const EdgeInsets.all(AppDimensions.paddingXL),
                        child: Column(
                          children: [
                            // Tab Bar
                            TabBar(
                              controller: _tabController,
                              indicatorColor: AppColors.gold,
                              labelColor: AppColors.gold,
                              unselectedLabelColor: AppColors.subtleText,
                              labelStyle: AppTextStyles.buttonMedium,
                              tabs: const [
                                Tab(text: AppStrings.login),
                                Tab(text: AppStrings.createNewAccount),
                              ],
                            ),
                            const SizedBox(height: AppDimensions.spacingXL),

                            // Tab View (Constraint box needed because TabBarView needs heights)
                            SizedBox(
                              height: 300,
                              child: TabBarView(
                                controller: _tabController,
                                children: [
                                  // Login Tab
                                  Form(
                                    key: _loginFormKey,
                                    child: Column(
                                      children: [
                                        TextFormField(
                                          controller: _loginUserCtrl,
                                          style: AppTextStyles.bodyMedium,
                                          decoration: const InputDecoration(
                                            hintText: AppStrings.emailOrPhone,
                                            prefixIcon: Icon(Iconsax.user, size: AppDimensions.iconS, color: AppColors.woodBrown),
                                          ),
                                          validator: (v) => (v == null || v.isEmpty) ? 'يرجى إدخال البريد أو الهاتف' : null,
                                        ),
                                        const SizedBox(height: AppDimensions.spacingL),
                                        ValueListenableBuilder<bool>(
                                          valueListenable: _obscureLoginPassword,
                                          builder: (context, obscure, child) {
                                            return TextFormField(
                                              controller: _loginPassCtrl,
                                              obscureText: obscure,
                                              style: AppTextStyles.bodyMedium,
                                              decoration: InputDecoration(
                                                hintText: AppStrings.password,
                                                prefixIcon: const Icon(Iconsax.lock, size: AppDimensions.iconS, color: AppColors.woodBrown),
                                                suffixIcon: IconButton(
                                                  icon: Icon(
                                                    obscure ? Iconsax.eye_slash : Iconsax.eye,
                                                    size: AppDimensions.iconS,
                                                    color: AppColors.woodBrown,
                                                  ),
                                                  onPressed: () => _obscureLoginPassword.value = !obscure,
                                                ),
                                              ),
                                              validator: (v) => (v == null || v.length < 6) ? 'كلمة المرور قصيرة' : null,
                                            );
                                          },
                                        ),
                                        const SizedBox(height: AppDimensions.spacingM),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              AppStrings.forgotPassword,
                                              style: AppTextStyles.link.copyWith(fontSize: 12),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  AppStrings.rememberMe,
                                                  style: AppTextStyles.bodySmall,
                                                ),
                                                ValueListenableBuilder<bool>(
                                                  valueListenable: _rememberMe,
                                                  builder: (context, checked, child) {
                                                    return Checkbox(
                                                      value: checked,
                                                      activeColor: AppColors.gold,
                                                      onChanged: (val) => _rememberMe.value = val ?? false,
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const Spacer(),
                                        HaButton.primary(
                                          text: AppStrings.login,
                                          isLoading: isLoading,
                                          onPressed: () => _submitLogin(context),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Register Tab
                                  Form(
                                    key: _registerFormKey,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          TextFormField(
                                            controller: _regNameCtrl,
                                            style: AppTextStyles.bodyMedium,
                                            decoration: const InputDecoration(
                                              hintText: AppStrings.fullName,
                                              prefixIcon: Icon(Iconsax.user, size: AppDimensions.iconS, color: AppColors.woodBrown),
                                            ),
                                            validator: (v) => (v == null || v.isEmpty) ? 'مطلوب الاسم بالكامل' : null,
                                          ),
                                          const SizedBox(height: AppDimensions.spacingM),
                                          TextFormField(
                                            controller: _regPhoneCtrl,
                                            style: AppTextStyles.bodyMedium,
                                            decoration: const InputDecoration(
                                              hintText: AppStrings.phone,
                                              prefixIcon: Icon(Iconsax.call, size: AppDimensions.iconS, color: AppColors.woodBrown),
                                            ),
                                            validator: (v) => (v == null || v.isEmpty) ? 'مطلوب رقم الجوال' : null,
                                          ),
                                          const SizedBox(height: AppDimensions.spacingM),
                                          TextFormField(
                                            controller: _regEmailCtrl,
                                            style: AppTextStyles.bodyMedium,
                                            decoration: const InputDecoration(
                                              hintText: AppStrings.email,
                                              prefixIcon: Icon(Iconsax.sms, size: AppDimensions.iconS, color: AppColors.woodBrown),
                                            ),
                                            validator: (v) => (v == null || !v.contains('@')) ? 'بريد إلكتروني غير صالح' : null,
                                          ),
                                          const SizedBox(height: AppDimensions.spacingM),
                                          ValueListenableBuilder<bool>(
                                            valueListenable: _obscureRegPassword,
                                            builder: (context, obscure, child) {
                                              return TextFormField(
                                                controller: _regPassCtrl,
                                                obscureText: obscure,
                                                style: AppTextStyles.bodyMedium,
                                                decoration: InputDecoration(
                                                  hintText: AppStrings.password,
                                                  prefixIcon: const Icon(Iconsax.lock, size: AppDimensions.iconS, color: AppColors.woodBrown),
                                                  suffixIcon: IconButton(
                                                    icon: Icon(
                                                      obscure ? Iconsax.eye_slash : Iconsax.eye,
                                                      size: AppDimensions.iconS,
                                                      color: AppColors.woodBrown,
                                                    ),
                                                    onPressed: () => _obscureRegPassword.value = !obscure,
                                                  ),
                                                ),
                                                validator: (v) => (v == null || v.length < 6) ? 'مطلوب 6 خانات كحد أدنى' : null,
                                              );
                                            },
                                          ),
                                          const SizedBox(height: AppDimensions.spacingXL),
                                          HaButton.primary(
                                            text: AppStrings.register,
                                            isLoading: isLoading,
                                            onPressed: () => _submitRegister(context),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Faint divider for Social buttons
                            const SizedBox(height: AppDimensions.spacingXL),
                            const Row(
                              children: [
                                Expanded(child: Divider()),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Text(
                                    AppStrings.orContinueWith,
                                    style: TextStyle(color: AppColors.subtleText, fontSize: 12),
                                  ),
                                ),
                                Expanded(child: Divider()),
                              ],
                            ),
                            const SizedBox(height: AppDimensions.spacingM),

                            // 4 Social login buttons
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildSocialButton(Iconsax.global, () {}),
                                const SizedBox(width: AppDimensions.spacingM),
                                _buildSocialButton(Iconsax.message_text, () {}),
                                const SizedBox(width: AppDimensions.spacingM),
                                _buildSocialButton(Iconsax.camera, () {}),
                                const SizedBox(width: AppDimensions.spacingM),
                                _buildSocialButton(Iconsax.mobile, () {}),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    // === شريط المميزات السفلي ===
                    const SizedBox(height: AppDimensions.spacingXL),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.screenPaddingH),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildFeatureItem(Iconsax.award, AppStrings.premiumDesigns),
                          _buildFeatureItem(Iconsax.shield_tick, AppStrings.safeShopping),
                          _buildFeatureItem(Iconsax.headphone, AppStrings.premiumSupport),
                        ],
                      ),
                    ),

                    // Legal text
                    const SizedBox(height: AppDimensions.spacingXL),
                    Padding(
                      padding: const EdgeInsets.all(AppDimensions.paddingM),
                      child: Text.rich(
                        TextSpan(
                          text: '${AppStrings.agreeTerms} ',
                          style: AppTextStyles.caption,
                          children: [
                            TextSpan(
                              text: AppStrings.termsAndConditions,
                              style: AppTextStyles.caption.copyWith(color: AppColors.gold, fontWeight: FontWeight.bold),
                            ),
                            const TextSpan(text: ' و '),
                            TextSpan(
                              text: AppStrings.privacyPolicy,
                              style: AppTextStyles.caption.copyWith(color: AppColors.gold, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spacingXXL),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSocialButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(100),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.cardBorder, width: 1.5),
        ),
        child: Icon(
          icon,
          size: 20,
          color: AppColors.woodBrown,
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String text) {
    return Column(
      children: [
        Icon(
          icon,
          color: AppColors.gold,
          size: AppDimensions.iconM,
        ),
        const SizedBox(height: 4),
        Text(
          text,
          style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w600, color: AppColors.nightBrown),
        ),
      ],
    );
  }
}
