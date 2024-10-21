import 'package:flutter/material.dart';

class BinaryMessengerWidget extends StatelessWidget {
  final TextEditingController controller;
  final String resultText;
  final VoidCallback onPressed;

  const BinaryMessengerWidget({
    super.key,
    required this.controller,
    required this.resultText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.grey.shade200),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('BinaryMessenger',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                SizedBox(width: 20),
                Expanded(
                  child: IconButton(
                    iconSize: 20,
                    onPressed: onPressed,
                    icon: Icon(Icons.ads_click),
                  ),
                )
              ],
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: controller,
                    decoration: InputDecoration(
                        border: InputBorder.none, hintText: "텍스트 입력하세요"),
                  ),
                  Text(resultText)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
