import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Shimmer skeleton loader for various content types
class ShimmerLoader extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final ShimmerType type;
  final Color baseColor;
  final Color highlightColor;

  const ShimmerLoader({
    super.key,
    required this.isLoading,
    required this.child,
    this.type = ShimmerType.card,
    this.baseColor = const Color(0xFFE0E0E0),
    this.highlightColor = const Color(0xFFF5F5F5),
  });

  @override
  Widget build(BuildContext context) {
    if (!isLoading) return child;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: _buildShimmerContent(),
    );
  }

  Widget _buildShimmerContent() {
    switch (type) {
      case ShimmerType.card:
        return _buildCardSkeleton();
      case ShimmerType.list:
        return _buildListSkeleton();
      case ShimmerType.text:
        return _buildTextSkeleton();
      case ShimmerType.paragraph:
        return _buildParagraphSkeleton();
      case ShimmerType.skillCard:
        return _buildSkillCardSkeleton();
    }
  }

  Widget _buildCardSkeleton() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          height: 16,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 200,
          height: 16,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ],
    );
  }

  Widget _buildListSkeleton() {
    return Column(
      children: List.generate(
        3,
        (index) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 200,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextSkeleton() {
    return Column(
      children: List.generate(
        2,
        (index) => Container(
          width: double.infinity,
          height: 16,
          margin: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Widget _buildParagraphSkeleton() {
    return Column(
      children: List.generate(
        4,
        (index) => Container(
          width: index == 3 ? 200 : double.infinity,
          height: 14,
          margin: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(7),
          ),
        ),
      ),
    );
  }

  Widget _buildSkillCardSkeleton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 200,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            height: 14,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(7),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 300,
            height: 14,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(7),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            children: List.generate(
              3,
              (index) => Container(
                width: 80,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Shimmer types
enum ShimmerType { card, list, text, paragraph, skillCard }

/// Builder widget for shimmer with content
class ShimmerBuilder extends StatelessWidget {
  final AsyncSnapshot<dynamic> snapshot;
  final Widget Function(BuildContext, dynamic) builder;
  final ShimmerType shimmerType;

  const ShimmerBuilder({
    super.key,
    required this.snapshot,
    required this.builder,
    this.shimmerType = ShimmerType.card,
  });

  @override
  Widget build(BuildContext context) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return ShimmerLoader(
        isLoading: true,
        type: shimmerType,
        child: Container(),
      );
    }

    if (snapshot.hasError) {
      return Center(child: Text('Error: ${snapshot.error}'));
    }

    return ShimmerLoader(
      isLoading: false,
      child: builder(context, snapshot.data),
    );
  }
}
