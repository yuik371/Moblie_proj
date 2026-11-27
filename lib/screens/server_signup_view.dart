import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class ServerSignupView extends StatefulWidget {
  const ServerSignupView({super.key});

  @override
  State<ServerSignupView> createState() => _ServerSignupViewState();
}

class _ServerSignupViewState extends State<ServerSignupView> {
  final _email = TextEditingController();
  final _code = TextEditingController();
  final _nickname = TextEditingController();
  final _password = TextEditingController();
  final _passwordConfirm = TextEditingController();

  bool _busy = false;
  bool _sent = false;
  bool _verified = false;

  @override
  void dispose() {
    for (final controller in [
      _email,
      _code,
      _nickname,
      _password,
      _passwordConfirm,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  void _message(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
  }

  // 통신 중 중복 클릭을 막고 오류를 화면에 표시합니다.
  Future<void> _run(Future<void> Function() action) async {
    if (_busy) return;

    FocusScope.of(context).unfocus();
    setState(() => _busy = true);

    try {
      await action();
    } catch (error) {
      if (mounted) _message(error.toString());
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _sendCode() async {
    final email = _email.text.trim();

    if (email.isEmpty || !email.contains('@')) {
      _message('이메일 주소를 확인해주세요.');
      return;
    }

    await _run(() async {
      await AuthService.sendCode(email);

      if (!mounted) return;

      setState(() {
        _sent = true;
        _verified = false;
        _code.clear();
      });
      _message('인증번호를 보냈습니다. 메일을 확인해주세요.');
    });
  }

  Future<void> _verifyCode() async {
    if (!RegExp(r'^[0-9]{6}$').hasMatch(_code.text.trim())) {
      _message('6자리 인증번호를 입력해주세요.');
      return;
    }

    await _run(() async {
      await AuthService.verifyCode(_email.text, _code.text);

      if (!mounted) return;

      setState(() => _verified = true);
      _message('이메일 인증이 완료되었습니다.');
    });
  }

  Future<void> _register() async {
    if (!_verified) {
      _message('이메일 인증을 먼저 완료해주세요.');
      return;
    }

    if (_nickname.text.trim().isEmpty) {
      _message('닉네임을 입력해주세요.');
      return;
    }

    if (_password.text.isEmpty) {
      _message('비밀번호를 입력해주세요.');
      return;
    }

    if (_password.text != _passwordConfirm.text) {
      _message('비밀번호가 일치하지 않습니다.');
      return;
    }

    await _run(() async {
      await AuthService.register(
        email: _email.text,
        password: _password.text,
        nickname: _nickname.text,
      );

      if (!mounted) return;

      // 가입한 이메일을 로그인 화면에 전달합니다.
      Navigator.pop(context, _email.text.trim());
    });
  }

  Widget _input(
    TextEditingController controller,
    String label, {
    bool obscure = false,
    bool enabled = true,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        enabled: enabled && !_busy,
        obscureText: obscure,
        autocorrect: false,
        enableSuggestions: !obscure,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_busy,
      child: Scaffold(
        appBar: AppBar(title: const Text('이메일 회원가입')),
        body: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            _input(
              _email,
              '이메일',
              enabled: !_sent,
              keyboardType: TextInputType.emailAddress,
            ),
            if (!_verified)
              FilledButton(
                onPressed: _busy ? null : _sendCode,
                child: Text(_sent ? '인증번호 다시 받기' : '인증번호 받기'),
              ),
            if (_sent && !_verified) ...[
              TextButton(
                onPressed: _busy
                    ? null
                    : () {
                        setState(() {
                          _sent = false;
                          _verified = false;
                          _code.clear();
                        });
                      },
                child: const Text('이메일 주소 변경'),
              ),
              const SizedBox(height: 16),
              _input(
                _code,
                '인증번호 6자리',
                keyboardType: TextInputType.number,
              ),
              OutlinedButton(
                onPressed: _busy ? null : _verifyCode,
                child: const Text('인증번호 확인'),
              ),
              const Text('인증번호는 5분 이내에 입력해주세요.'),
            ],
            if (_verified) ...[
              const Text(
                '이메일 인증 완료',
                style: TextStyle(color: Colors.green),
              ),
              const SizedBox(height: 20),
              _input(_nickname, '닉네임'),
              _input(_password, '비밀번호', obscure: true),
              _input(_passwordConfirm, '비밀번호 확인', obscure: true),
              FilledButton(
                onPressed: _busy ? null : _register,
                child: const Text('회원가입 완료'),
              ),
            ],
            if (_busy)
              const Padding(
                padding: EdgeInsets.all(20),
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }
}