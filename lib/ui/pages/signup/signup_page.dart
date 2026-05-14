import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:unitask/core/extensions/build_context_extension.dart';
import 'package:unitask/core/modles/result.dart';
import 'package:unitask/features/auth/auth_provider.dart';
import 'package:unitask/ui/common/label_text_field.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final TextEditingController _nameController = .new();
  final TextEditingController _emailController = .new();
  final TextEditingController _passwordController = .new();
  final TextEditingController _passwordConfirmController = .new();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();

    super.dispose();
  }

  Future<void> _onSignup() async {
    //async면 앞에 Future로 해두자(왜인지는 모름)
    debugPrint('계정 만들기');

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final passwordconfirm = _passwordConfirmController.text.trim();
    //trim()은 띄워쓰기를 하지 못하도록 막아준다.

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      context.showSnackbar('정보가 올바르지 않습니다.', isError: true);
      return;
    }

    if (password != passwordconfirm) {
      context.showSnackbar('비밀번호가 일치하지 않습니다.', isError: true);
      return;
    }

    final result = await ref
        .read(authProvider.notifier)
        .signup(email: email, password: password, name: name);

    //입력 확인
    switch (result) {
      case Success():
        if (mounted) context.pop();
      case Failure(:final exception):
        if (mounted) {
          context.showSnackbar(exception.toString(), isError: true);
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    //AsyncLoading() 데이터 추출
    final loading = ref.watch(authProvider).isLoading;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('회원가입', style: TextStyle(fontWeight: .bold)),
      ),
      body: Padding(
        padding: .all(20),
        child: SingleChildScrollView(
          child: Column(
            spacing: 25,
            children: [
              LabelTextField(
                controller: _nameController,
                label: '이름',
                icon: LucideIcons.userRoundPen,
              ),
              LabelTextField(
                controller: _emailController,
                label: '이메일',
                icon: LucideIcons.mail,
              ),
              LabelTextField(
                controller: _passwordController,
                label: '비밀번호',
                icon: LucideIcons.lockKeyhole,
                enableObscure: true,
              ),
              LabelTextField(
                controller: _passwordConfirmController,
                label: '비밀번호 확인',
                icon: LucideIcons.lockKeyholeOpen,
                enableObscure: true,
              ),
              SizedBox(
                width: .infinity,
                child: ElevatedButton(
                  onPressed: loading ? null : _onSignup,
                  child: loading
                      ? SizedBox.square(
                          dimension: 30,
                          child: CircularProgressIndicator(color: Colors.white),
                        )
                      : Text(
                          '계정 만들기',
                          style: TextStyle(fontWeight: .bold, fontSize: 20),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
