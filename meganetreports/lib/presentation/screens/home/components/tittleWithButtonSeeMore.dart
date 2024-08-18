import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TitleWhitButton extends StatelessWidget {
  const TitleWhitButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
      children: [
        const TitleHome(),
        const Spacer(),
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.red[800],
            foregroundColor: Colors.white
          ),
          onPressed: () {}, 
          child: const Text('Ver más'),
        )
      ],
              ),
    );
  }
}

class TitleHome extends StatelessWidget {
  const TitleHome({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24,
      child: Stack(
        children: [
          Text('Incidentes recient..', 
            style: TextStyle(
              fontSize: 30.sp, 
              fontWeight: FontWeight.bold,
              color: Colors.white,
            )
          ),         
        ],
      ),
    );
  }
}

