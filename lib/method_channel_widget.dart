import 'package:flutter/material.dart';

class MethodChannelWidget extends StatelessWidget {
  final String result;
  final VoidCallback onPressed;

  const MethodChannelWidget({
    super.key,
    required this.result,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.green.shade400,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('MethodChannel',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                Expanded(
                  child: IconButton(
                    iconSize: 20,
                    onPressed: onPressed,
                    icon: Icon(Icons.ads_click),
                  ),
                )
              ],
            ),
            Text('배터리: ${result.toString()}' ?? ''),
          ],
        ),
      ),
    );
  }
}
