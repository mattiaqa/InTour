import 'package:flutter/material.dart';
import 'package:frontend/utils/api_manager.dart';

// ignore: must_be_immutable
class LikeButton extends StatefulWidget
{
  bool liked;
  String postId;
  VoidCallback? onTap;

  LikeButton
  (
    {
      required this.liked,
      required this.postId,
      this.onTap,
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
            //Icons.favorite, 
            //Icons.pin_drop_rounded
            Icons.add_location_alt_rounded,
            size: 40,
            //color: Colors.red,
            color: Colors.green,
          )
          :
          const Icon
          (
            //Icons.favorite_border,
            Icons.add_location_alt_outlined,
            size: 40,
          )
      ),
    
      onTap: ()
      {
        Map<String, dynamic> postdata = {
          'post_id': widget.postId,
        };

        if(widget.liked)
        {
          ApiManager.postData('post/dislike', postdata);
        }
        else
        {
          ApiManager.postData('post/like', postdata);
        }

        setState(() {
          widget.liked = !widget.liked;
        });
        _controller.reverse().then((value) => _controller.forward());

        if(widget.onTap != null)
          widget.onTap!();
      }
    );
  }
}