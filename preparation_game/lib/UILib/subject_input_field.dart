import 'package:flutter/material.dart';

class SubjectInputField extends StatelessWidget {
  final int index;
  final TextEditingController controller;
  final bool canRemove;
  final VoidCallback onRemove;

  const SubjectInputField({
    super.key,
    required this.index,
    required this.controller,
    required this.canRemove,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.3),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              IconData(
                0x2212,
                fontFamily: 'CustomFont2'
              ),
              color: Colors.black87,
              size: 20,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: canRemove ? onRemove : null,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              style: const TextStyle(
                fontFamily: 'CustomFont2',
                fontSize: 13,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                hintText: 'Subject ${index + 1}...',
                hintStyle: TextStyle(
                  fontFamily: 'CustomFont2',
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 6,
                ),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}