import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  final String text;
  final void Function()? onTap;

  const UserTile({super.key, required this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue[900],
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            // icon
            const Icon(Icons.person_outline,color: Colors.white,),

            const SizedBox(width: 20),

            // user name
            Text(text,style: const TextStyle(color: Colors.white, fontFamily: "Mont", fontSize: 15),),
          ],
        ),
      ),
    );
  }
}
