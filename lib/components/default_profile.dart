import 'package:flutter/material.dart';
import 'package:voter_smiu/utils/constants.dart';

class DefaultProfile extends StatelessWidget {
  final double? size;
  const DefaultProfile({super.key,this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      height: size,
      width: size,
      decoration: BoxDecoration(
          color: Colors.grey[300],
          shape: BoxShape.circle),
      child: const Icon(Icons.person,color: Colors.black45),
    );
  }
}
