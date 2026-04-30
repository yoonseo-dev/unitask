import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:unitask/app/extensions/snackbar_extension.dart';
import 'package:unitask/services/api_service.dart';
import 'package:unitask/ui/common/label_text_field.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _nameController = .new();
  final TextEditingController _emailController = .new();
  final TextEditingController _passwordController = .new();
  final TextEditingController _passwordConfirmController = .new();

  bool _loading = false;

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

    void startLoading() => setState(() => _loading = true);
    void stopLoading() => setState(() => _loading = false);

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      context.showSnackbar('정보가 올바르지 않습니다.', isError: true);
      return;
    }

    if (password != passwordconfirm) {
      context.showSnackbar('비밀번호가 일치하지 않습니다.', isError: true);
      return;
    }

    startLoading();

    final signupResult = await ApiService.signup(
      email: email,
      password: password,
      name: name,
    );

    stopLoading();

    if (signupResult == null) return;

    if (!signupResult) {
      if (mounted) {
        context.showSnackbar('계정 생성에 실패했습니다.', isError: true);
      }
      return;
    }

    if (mounted) context.pop();

    //입력 확인
  }

  @override
  Widget build(BuildContext context) {
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
                  onPressed: _onSignup,
                  child: _loading
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
