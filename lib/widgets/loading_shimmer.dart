import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingShimmer extends StatelessWidget {
  const LoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 6,
        itemBuilder: (context, index) {
          return const Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              leading: CircleAvatar(backgroundColor: Colors.white),
              title: SizedBox(
                width: 100,
                height: 16,
                child: ColoredBox(color: Colors.white),
              ),
              subtitle: SizedBox(
                width: 200,
                height: 14,
                child: ColoredBox(color: Colors.white),
              ),
            ),
          );
        },
      ),
    );
  }
}
