import 'package:flutter/material.dart';

class LikeButton extends StatefulWidget
{
  bool liked;

  LikeButton
  (
    {
      required this.liked,
    }
  );

  @override
  State<LikeButton> createState() => LikeButtonState();
}

class LikeButtonState extends State<LikeButton>
  with SingleTickerProviderStateMixin 
{
  late final AnimationController _controller = AnimationController
  (
    duration: const Duration(milliseconds: 200), 
    vsync: this, 
    value: 1.0,
  );

  bool _isFavorite = false;

  @override
  void dispose() 
  {
    super.dispose();
    _controller.dispose();
  }
  @override
  Widget build(BuildContext context)
  {
    return InkWell
    (
      child: ScaleTransition
      (
        scale: Tween(begin: 0.7, end: 1.0).animate
        (
          CurvedAnimation(parent: _controller, curve: Curves.easeOut)
        ),
        child: widget.liked ?
          const Icon
          (
            Icons.favorite, 
            size: 40,
            color: Colors.red,
          )
          :
          const Icon
          (
            Icons.favorite_border, 
            size: 40,
          )
      ),
    
      onTap: ()
      {
        setState(() {
          widget.liked = !widget.liked;
        });
        _controller.reverse().then((value) => _controller.forward());
      }
    );
  }
}