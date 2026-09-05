import 'package:flutter/material.dart';

/// Skeleton loading grid cover — `lib/core/widgets/skeleton.dart`.
class _SkeletonBox extends StatelessWidget {
  const _SkeletonBox({required this.width, required this.height, this.radius = 12});
  final double width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

/// Deretan cover horizontal (untuk seksi beranda).
class SkeletonCoverRow extends StatelessWidget {
  const SkeletonCoverRow({super.key, this.itemCount = 6});
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 226,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: itemCount,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (_, _) => const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SkeletonBox(width: 120, height: 180),
            SizedBox(height: 6),
            _SkeletonBox(width: 110, height: 12, radius: 6),
            SizedBox(height: 4),
            _SkeletonBox(width: 70, height: 10, radius: 6),
          ],
        ),
      ),
    );
  }
}

/// Grid cover (untuk loading pencarian).
class SkeletonCoverGrid extends StatelessWidget {
  const SkeletonCoverGrid({super.key, this.itemCount = 9});
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 160,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.52,
      ),
      itemCount: itemCount,
      itemBuilder: (_, _) => const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _SkeletonBox(width: double.infinity, height: double.infinity)),
          SizedBox(height: 6),
          _SkeletonBox(width: double.infinity, height: 12, radius: 6),
        ],
      ),
    );
  }
}
