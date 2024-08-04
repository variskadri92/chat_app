import 'package:flutter/material.dart';
class UserTitle extends StatelessWidget {
  final String text;
  final void Function()? onTap;

  const UserTitle({super.key, required this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration:  BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 25),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              //icon
              Icon(Icons.person),
              const SizedBox(width: 20),
              //use name
              Text(text),
            ],
          ),
        ),
      ),
    );
  }
}
