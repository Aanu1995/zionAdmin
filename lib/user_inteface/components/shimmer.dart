import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoadingList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300],
      highlightColor: Colors.grey[100],
      child: ListView.builder(
        itemCount: 6,
        itemBuilder: (_, __) => Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                radius: 35.0,
                backgroundColor: Colors.white,
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      height: 8.0,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 5.0),
                    Container(
                      width: double.infinity,
                      height: 8.0,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 5.0),
                    Container(
                      width: 40.0,
                      height: 8.0,
                      color: Colors.white,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ShimmerLoadingItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300],
      highlightColor: Colors.grey[100],
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              radius: 35.0,
              backgroundColor: Colors.white,
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: 8.0,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 5.0),
                  Container(
                    width: double.infinity,
                    height: 8.0,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 5.0),
                  Container(
                    width: 40.0,
                    height: 8.0,
                    color: Colors.white,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
