import 'package:flutter/material.dart';

class BasicMessageChannelWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final TextEditingController controller;
  final String result;

  const BasicMessageChannelWidget({
    super.key,
    required this.onPressed,
    required this.controller,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.amber.shade200,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('BasicMessageChannel',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                Expanded(
                  child: IconButton(
                    iconSize: 20,
                    onPressed: onPressed,
                    icon: Icon(Icons.ads_click),
                  ),
                ),
                SizedBox(width: 10),
              ],
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                        border: InputBorder.none, hintText: "텍스트 입력하세요."),
                  ),
                  Text(result)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
