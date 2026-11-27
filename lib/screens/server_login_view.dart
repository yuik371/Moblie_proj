import 'package:flutter/material.dart';

import '../services/post_service.dart';

import 'server_signup_view.dart';

class ServerLoginView extends StatefulWidget {
  const ServerLoginView({super.key});

  @override
  State<ServerLoginView> createState() => _ServerLoginViewState();
}

class _ServerLoginViewState extends State<ServerLoginView> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

    Future<void> _openSignup() async {
    final email = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (_) => const ServerSignupView(),
      ),
    );

    if (email == null || !mounted) return;

    _email.text = email;
    _password.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('회원가입이 완료되었습니다. 로그인해주세요.'),
      ),
    );
  }

  bool _loading = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_loading || !_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      // 로그인 성공 시 AuthSession에도 정보가 저장됩니다.
      await PostService.login(_email.text, _password.text);

      if (!mounted) return;

      // 이전 화면에 로그인 성공을 알립니다.
      Navigator.pop(context, true);
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('로그인 실패: $error')),
      );
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_loading,
      child: Scaffold(
        appBar: AppBar(title: const Text('이메일 로그인')),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const SizedBox(height: 32),
              const Text(
                '다시 만나서 반가워요',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _email,
                enabled: !_loading,
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                decoration: const InputDecoration(
                  labelText: '이메일',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '이메일을 입력해주세요.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _password,
                enabled: !_loading,
                obscureText: true,
                autocorrect: false,
                enableSuggestions: false,
                decoration: const InputDecoration(
                  labelText: '비밀번호',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '비밀번호를 입력해주세요.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _loading ? null : _login,
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6F0F),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(_loading ? '로그인 중...' : '로그인'),
              ),
                            const SizedBox(height: 12),
              TextButton(
                onPressed: _loading ? null : _openSignup,
                child: const Text('처음이신가요? 회원가입'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}