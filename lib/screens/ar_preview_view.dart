import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../config/app_theme.dart';
import '../services/sensor_service.dart';
import '../widgets/ar_painters.dart';

// 기기 가속도 센서로 상품 카드가 움직이는 AR 스타일 미리보기 화면입니다.
class ArPreviewView extends StatefulWidget {
  const ArPreviewView({required this.onBack, super.key});

  final VoidCallback onBack;

  @override
  State<ArPreviewView> createState() => _ArPreviewViewState();
}

class _ArPreviewViewState extends State<ArPreviewView> with SingleTickerProviderStateMixin {
  late final AnimationController animation;
  final sensorService = SensorService();
  StreamSubscription<AccelerometerEvent>? accelerometer;
  double tiltX = 0;
  double tiltY = 0;
  bool sensorActive = false;

  @override
  void initState() {
    super.initState();
    // 센서가 없을 때도 화면이 자연스럽게 움직이도록 반복 애니메이션을 준비합니다.
    animation = AnimationController(vsync: this, duration: const Duration(seconds: 4))..repeat();
    // 휴대폰 기울기 값을 구독해 상품의 위치와 회전값에 반영합니다.
    accelerometer = sensorService.accelerometerStream.listen((event) {
      if (!mounted) return;
      setState(() {
        sensorActive = true;
        tiltX = (event.x / 9.8).clamp(-0.65, 0.65).toDouble();
        tiltY = (event.y / 9.8).clamp(-0.65, 0.65).toDouble();
      });
    });
  }

  @override
  void dispose() {
    // 화면을 닫을 때 센서 구독과 애니메이션을 해제합니다.
    accelerometer?.cancel();
    animation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B2328),
      appBar: AppBar(
        // 상품 상세 화면으로 돌아가는 버튼입니다.
        leading: IconButton(onPressed: widget.onBack, icon: const Icon(Icons.arrow_back)),
        title: const Text('AR로 보기', style: TextStyle(fontWeight: FontWeight.w700)),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 14, top: 11, bottom: 11),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(color: const Color(0xFFF4F7F8), borderRadius: BorderRadius.circular(18)),
            child: const Center(child: Text('자연 티타늄', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700))),
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          final fallbackX = sensorActive ? 0.0 : math.sin(animation.value * math.pi * 2) * 0.07;
          final fallbackY = math.cos(animation.value * math.pi * 2) * 0.025;
          final x = (tiltX + fallbackX) * 86;
          final y = (tiltY + fallbackY) * 52;
          final angle = (tiltX + fallbackX) * 0.2;
          return Stack(
            children: [
              Positioned.fill(child: CustomPaint(painter: ArGridPainter(animation.value))),
              Center(
                child: Transform.translate(
                  offset: Offset(x, y),
                  child: Transform.rotate(
                    angle: angle,
                    child: Container(
                      width: 300,
                      height: 300,
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(17), boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 25, offset: Offset(0, 15))]),
                      child: ClipRRect(borderRadius: BorderRadius.circular(11), child: Image.asset('assets/iphone15_natural_titanium.png', fit: BoxFit.cover)),
                    ),
                  ),
                ),
              ),
              const Positioned.fill(child: IgnorePointer(child: CustomPaint(painter: ReticlePainter()))),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: SafeArea(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(24, 18, 24, 14),
                    color: Colors.white.withOpacity(.94),
                    child: Column(
                      children: [
                        const Text('기기를 움직여 상품을 살펴보세요', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: ink)),
                        const SizedBox(height: 5),
                        Text(sensorActive ? '자연 티타늄 · 아이폰 15 프로 256G' : '센서를 연결하는 중 · 아이폰 15 프로 256G', style: const TextStyle(fontSize: 12, color: muted)),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            // 현재 배치 상태를 확정하는 예시 버튼입니다.
                            onPressed: () {},
                            style: FilledButton.styleFrom(backgroundColor: orange),
                            child: const Text('AR 배치 완료'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
