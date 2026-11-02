import 'package:flutter/material.dart';

import '../config/app_theme.dart';
import '../models/listing.dart';

// 상품 목록에서 한 상품의 이미지·제목·가격·찜 상태를 보여 주는 카드입니다.
class ListingTile extends StatelessWidget {
  const ListingTile({required this.listing, required this.onTap, super.key});

  final Listing listing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // 상품 카드를 누르면 상품 상세 화면을 엽니다.
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: line)),
        ),
        child: Row(
          children: [
            ProductThumbnail(listing: listing),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    listing.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: ink),
                  ),
                  const SizedBox(height: 5),
                  Text('${listing.location} · ${listing.time}', style: const TextStyle(fontSize: 12, color: muted)),
                  const SizedBox(height: 9),
                  Text(listing.price, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: ink)),
                ],
              ),
            ),
            // 현재는 표시 전용인 찜 아이콘입니다.
            Icon(listing.liked ? Icons.favorite : Icons.favorite_border, color: listing.liked ? orange : muted, size: 25),
          ],
        ),
      ),
    );
  }
}

// 상품 종류에 맞는 실제 이미지 또는 일러스트 썸네일을 선택합니다.
class ProductThumbnail extends StatelessWidget {
  const ProductThumbnail({required this.listing, super.key});

  final Listing listing;

  @override
  Widget build(BuildContext context) {
    final background = switch (listing.kind) {
      ListingKind.iphone => const Color(0xFFE1E7EB),
      ListingKind.desk => const Color(0xFFDACAAD),
      ListingKind.shoes => const Color(0xFFCBD8E8),
      ListingKind.feeder => const Color(0xFFF0D8BD),
      ListingKind.microwave => const Color(0xFFE0E0E0),
    };
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        width: 98,
        height: 96,
        child: listing.kind == ListingKind.iphone
            ? Image.asset('assets/iphone15_natural_titanium.png', fit: BoxFit.cover)
            : CustomPaint(painter: ProductPainter(listing.kind, background)),
      ),
    );
  }
}

// 실제 상품 이미지가 없는 상품을 간단한 Canvas 일러스트로 그립니다.
class ProductPainter extends CustomPainter {
  ProductPainter(this.kind, this.background);

  final ListingKind kind;
  final Color background;

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = background;
    canvas.drawRect(Offset.zero & size, p);
    final cx = size.width / 2;
    final cy = size.height / 2;

    switch (kind) {
      case ListingKind.desk:
        p.color = const Color(0xFF8B5D39);
        canvas.drawRect(Rect.fromLTWH(12, 53, size.width - 22, 10), p);
        p.strokeWidth = 5;
        canvas.drawLine(const Offset(22, 62), Offset(18, size.height - 9), p);
        canvas.drawLine(Offset(size.width - 20, 62), Offset(size.width - 15, size.height - 9), p);
        p.color = const Color(0xFF3F9757);
        canvas.drawRect(Rect.fromLTWH(67, 26, 3, 27), p);
        canvas.drawCircle(const Offset(62, 22), 8, p);
        canvas.drawCircle(const Offset(73, 17), 8, p);
      case ListingKind.shoes:
        p.color = Colors.white;
        final shoe = Path()
          ..moveTo(cx - 34, cy + 5)
          ..cubicTo(cx - 22, cy + 2, cx - 10, cy - 15, cx - 2, cy - 14)
          ..lineTo(cx + 13, cy + 2)
          ..cubicTo(cx + 21, cy + 9, cx + 34, cy + 10, cx + 37, cy + 18)
          ..lineTo(cx + 36, cy + 24)
          ..lineTo(cx - 33, cy + 24)
          ..close();
        canvas.drawPath(shoe, p);
        p
          ..color = const Color(0xFF4777AB)
          ..strokeWidth = 3;
        canvas.drawLine(Offset(cx - 17, cy + 4), Offset(cx + 7, cy + 11), p);
        canvas.drawLine(Offset(cx - 23, cy + 10), Offset(cx + 3, cy + 17), p);
      case ListingKind.feeder:
        p.color = const Color(0xFFE8ECEF);
        canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx, cy - 3), width: 50, height: 45), const Radius.circular(12)), p);
        p.color = const Color(0xFFBCC6CC);
        canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy - 25), width: 50, height: 18), p);
        p.color = orange;
        canvas.drawCircle(Offset(cx, cy - 20), 4, p);
        p.color = const Color(0xFFA8B1B8);
        canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy + 19), width: 58, height: 19), p);
      case ListingKind.microwave:
        p.color = const Color(0xFFF8F8F7);
        canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx, cy), width: 68, height: 49), const Radius.circular(5)), p);
        p
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = const Color(0xFF96999C);
        canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(cx - 26, cy - 17, 41, 32), const Radius.circular(3)), p);
        p.style = PaintingStyle.fill;
        p.color = const Color(0xFFFFD19F);
        canvas.drawCircle(Offset(cx - 5, cy - 1), 10, p);
        p.color = const Color(0xFF898F92);
        canvas.drawCircle(Offset(cx + 24, cy - 9), 4, p);
        canvas.drawCircle(Offset(cx + 24, cy + 8), 4, p);
      case ListingKind.iphone:
        p.color = const Color(0xFF2A2D33);
        canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx, cy), width: 40, height: 68), const Radius.circular(7)), p);
    }
  }

  @override
  bool shouldRepaint(covariant ProductPainter oldDelegate) => false;
}
