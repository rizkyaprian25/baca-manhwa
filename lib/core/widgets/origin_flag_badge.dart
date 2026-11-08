import 'package:flutter/material.dart';

import '../../features/manga/domain/entities/manga.dart';

/// Badge bendera negara asal komik (Jepang, Korea, China) dengan gaya melingkar elegan.
/// `lib/core/widgets/origin_flag_badge.dart`.
class OriginFlagBadge extends StatelessWidget {
  const OriginFlagBadge({
    super.key,
    required this.origin,
    this.size = 20,
    this.showLabel = false,
  });

  final MangaOrigin origin;
  final double size;
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    if (origin == MangaOrigin.other) return const SizedBox.shrink();

    final flag = SizedBox(
      width: size,
      height: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: ClipOval(
          child: switch (origin) {
            MangaOrigin.kr => const _FlagKr(),
            MangaOrigin.jp => const _FlagJp(),
            MangaOrigin.cn => const _FlagCn(),
            MangaOrigin.other => const SizedBox.shrink(),
          },
        ),
      ),
    );

    if (!showLabel) return flag;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        flag,
        const SizedBox(width: 5),
        Text(
          origin.typeLabel,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
        ),
      ],
    );
  }
}

/// Bendera Korea Selatan (Taegeuk): lingkaran putih, belah merah di atas & biru di bawah.
class _FlagKr extends StatelessWidget {
  const _FlagKr();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(1.5),
      child: ClipOval(
        child: Column(
          children: [
            Expanded(child: Container(color: const Color(0xFFCD2E3A))),
            Expanded(child: Container(color: const Color(0xFF0047A0))),
          ],
        ),
      ),
    );
  }
}

/// Bendera Jepang (Hinomaru): lingkaran putih dengan piringan merah di tengah.
class _FlagJp extends StatelessWidget {
  const _FlagJp();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF7F7F7),
      child: Center(
        child: Container(
          width: 9,
          height: 9,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFFBC002D),
          ),
        ),
      ),
    );
  }
}

/// Bendera China: merah dengan aksen bintang kuning.
class _FlagCn extends StatelessWidget {
  const _FlagCn();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFDE2910),
      child: const Center(
        child: Icon(
          Icons.star_rounded,
          color: Color(0xFFFFDE00),
          size: 11,
        ),
      ),
    );
  }
}
