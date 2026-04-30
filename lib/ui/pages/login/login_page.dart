import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:unitask/app/extensions/sized_box_extension.dart';
import 'package:unitask/app/extensions/snackbar_extension.dart';
import 'package:unitask/app/router/app_page.dart';
import 'package:unitask/ui/common/label_text_field.dart';
import 'package:unitask/ui/common/text_divider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: .all(20),
        child: Center(
          child: SingleChildScrollView(
            //SingleChildScrollView -> 키보드가 올라와도 에러가 뜨지 않는다.
            child: Column(
              mainAxisSize: .min,
              children: [
                Icon(LucideIcons.graduationCap, size: 50),
                Text(
                  'UniTask',
                  style: TextStyle(fontSize: 28, fontWeight: .bold),
                ),
                Text('과제 관리를 스마트하게'),
                50.heightBox,

                //이메일
                LabelTextField(
                  icon: LucideIcons.mail,
                  label: '이메일',
                  hintText: 'yoonseo@university.edu',
                ),
                20.heightBox,

                //비밀번호
                LabelTextField(
                  icon: LucideIcons.lockKeyhole,
                  label: '비밀번호',
                  hintText: '000000',
                  enableObscure: true,
                ),

                //패스워드 잊음
                Align(
                  alignment: .centerRight,
                  child: TextButton(
                    onPressed: () {
                      context.showSnackbar('곧 기능이 출시합니다!');
                    },
                    child: Text('비밀번호를 잊으셨나요?'),
                  ),
                ),

                20.heightBox,
                //로그인 버튼
                SizedBox(
                  width: .infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      '로그인',
                      style: TextStyle(fontWeight: .bold, fontSize: 20),
                    ),
                  ),
                ),

                20.heightBox,
                //또는
                TextDivider(),

                20.heightBox,
                //회원가입
                Row(
                  mainAxisAlignment: .center,
                  children: [
                    Text('계정이 없으신가요?'),
                    TextButton(
                      onPressed: () {
                        context.pushNamed(
                          AppPage.signup.name,
                        ); //goNamed는 스택이 쌓이지 않는 방식으로 화면 전환이 된다.
                      },
                      child: Text('회원가입'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
