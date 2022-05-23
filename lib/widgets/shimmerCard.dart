import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerCard extends StatelessWidget {
  const ShimmerCard({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.all(10),
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          height: 350,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 10,
                color: Colors.grey[300]!,
                offset: Offset(0, 0),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              Shimmer.fromColors(
                baseColor: Colors.grey[100]!,
                highlightColor: Colors.grey[300]!,
                child: Container(
                  height: 250,
                  width: double.infinity,
                  color: Colors.white,
                ),
              ),
              Spacer(),
              // Author and Date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Shimmer.fromColors(
                    baseColor: Colors.grey[100]!,
                    highlightColor: Colors.grey[300]!,
                    child: Container(
                      width: 110,
                      height: 10,
                      color: Colors.white,
                    ),
                  ),
                  Shimmer.fromColors(
                    baseColor: Colors.grey[100]!,
                    highlightColor: Colors.grey[300]!,
                    child: Container(
                      width: 90,
                      height: 10,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Spacer(),
              // Title
              Shimmer.fromColors(
                baseColor: Colors.grey[100]!,
                highlightColor: Colors.grey[300]!,
                child: Container(
                  width: double.infinity,
                  height: 50,
                  color: Colors.white,
                ),
              ),
              Spacer(),
            ],
          ),
        ),
        // Category
        // Positioned(
        //   top: 20,
        //   right: 20,
        //   child: Shimmer.fromColors(
        //     baseColor: Colors.grey[100]!,
        //     highlightColor: Colors.grey[300]!,
        //     child: Container(
        //       padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        //       child: Container(
        //         height: 10,
        //         width: 70,
        //       ),
        //       decoration: BoxDecoration(color: Colors.blue),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
