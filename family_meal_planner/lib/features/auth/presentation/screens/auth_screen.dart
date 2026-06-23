import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_provider.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  bool _isLogin = true;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final notifier = ref.read(authNotifierProvider.notifier);
    if (_isLogin) {
      await notifier.signIn(_emailCtrl.text, _passwordCtrl.text);
    } else {
      await notifier.signUp(_emailCtrl.text, _passwordCtrl.text);
    }

    // Show error if still on this screen
    if (!mounted) return;
    final authState = ref.read(authNotifierProvider);
    authState.whenOrNull(
      error: (e, _) {
        final message = _friendlyError(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      },
    );
  }

  String _friendlyError(Object e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'user-not-found':
          return 'Пользователь не найден';
        case 'wrong-password':
        case 'invalid-credential':
          return 'Неверный email или пароль';
        case 'email-already-in-use':
          return 'Email уже используется';
        case 'weak-password':
          return 'Пароль слишком простой (минимум 6 символов)';
        case 'invalid-email':
          return 'Некорректный email';
        case 'too-many-requests':
          return 'Слишком много попыток. Попробуйте позже';
        default:
          return e.message ?? 'Ошибка авторизации';
      }
    }
    return 'Произошла ошибка. Попробуйте ещё раз.';
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState.isLoading;
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colors.surface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo / header
                  Icon(
                    Icons.restaurant_menu_rounded,
                    size: 72,
                    color: colors.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Семейное меню',
                    textAlign: TextAlign.center,
                    style: textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isLogin
                        ? 'Войдите в семейный аккаунт'
                        : 'Создайте семейный аккаунт',
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Form
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Email
                        TextFormField(
                          controller: _emailCtrl,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          autofillHints: const [AutofillHints.email],
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email_outlined),
                            border: OutlineInputBorder(),
                          ),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'Введите email';
                            }
                            if (!v.contains('@')) {
                              return 'Некорректный email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Password
                        TextFormField(
                          controller: _passwordCtrl,
                          obscureText: _obscurePassword,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _submit(),
                          decoration: InputDecoration(
                            labelText: 'Пароль',
                            prefixIcon: const Icon(Icons.lock_outline),
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                              ),
                              onPressed: () => setState(
                                () => _obscurePassword = !_obscurePassword,
                              ),
                            ),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'Введите пароль';
                            }
                            if (!_isLogin && v.length < 6) {
                              return 'Минимум 6 символов';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),

                        // Submit button
                        FilledButton(
                          onPressed: isLoading ? null : _submit,
                          style: FilledButton.styleFrom(
                            minimumSize: const Size(double.infinity, 52),
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  _isLogin ? 'Войти' : 'Зарегистрироваться',
                                  style: const TextStyle(fontSize: 16),
                                ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Toggle login / register
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _isLogin
                            ? 'Нет аккаунта? '
                            : 'Уже есть аккаунт? ',
                        style: textTheme.bodyMedium,
                      ),
                      GestureDetector(
                        onTap: isLoading
                            ? null
                            : () => setState(() => _isLogin = !_isLogin),
                        child: Text(
                          _isLogin ? 'Создать' : 'Войти',
                          style: textTheme.bodyMedium?.copyWith(
                            color: colors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Hint for family usage
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colors.primaryContainer.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.people_outline,
                          color: colors.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Используйте один аккаунт на все устройства семьи — данные будут синхронизированы автоматически.',
                            style: textTheme.bodySmall?.copyWith(
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
