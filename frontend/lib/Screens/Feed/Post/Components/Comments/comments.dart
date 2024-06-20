import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/Screens/Common/bottomMenu.dart';
import 'package:frontend/Screens/Common/bottomMessage.dart';
import 'package:frontend/Screens/Common/emptyState.dart';
import 'package:frontend/Screens/Feed/Post/Components/Comments/tile.dart';
import 'package:frontend/utils/api_manager.dart';
import 'package:frontend/utils/app_service.dart';
import 'package:intl/intl.dart';

class Commenti extends StatefulWidget
{
  final List<dynamic> commenti;
  final String postId;
  final String postUser;

  Commenti({
    super.key, 
    required this.postId,
    required this.commenti,
    required this.postUser
  });
  
  @override
  State<Commenti> createState() => CommentiState();
}

class CommentiState extends State<Commenti>
{
  
  @override
  Widget build(BuildContext context)
  {
    TextEditingController _controller = TextEditingController();
    final ScrollController _scrollController = ScrollController();

    return PopScope(
      onPopInvoked: (didPop) => widget.commenti, 
      child: Scaffold
      (
        appBar: AppBar(title: Text("Commenti")),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            widget.commenti.isNotEmpty ?
            Expanded(child:
              ListView.builder(
                controller: _scrollController,
                itemCount: widget.commenti.length,
                itemBuilder: (context, index)
                {
                  return InkWell(
                    child: CommentoTile(
                      user: widget.commenti[index]['user'],
                      text: widget.commenti[index]['comment'],
                      commentId: widget.commenti[index]['commentId'],
                    ),
                    onTap: () {
                      if(widget.commenti[index]['user'] == AppService.instance.currentUser!.userid ||
                        widget.postUser == AppService.instance.currentUser!.userid
                      )
                        ShowBottomMenu(context, "Rimuovi commento", 
                        [
                          BottomMenuButton(
                            icon: Icons.check, 
                            text: "Sono sicuro", 
                            action: () async {
                              Map<String, dynamic> data = {
                                'post_id': widget.postId,
                                'commentId': widget.commenti[index]['commentId'],
                              };
                              if(widget.commenti[index]['commentId'].isNotEmpty)
                                ApiManager.postData('post/comment/delete', data).then(
                                  (value) => setState(() 
                                  {
                                    widget.commenti.remove(widget.commenti[index]);
                                    ShowBottomMessage(context, 'Commento eliminato');
                                  }),
                                );
                            }
                          ),

                          BottomMenuButton(
                            icon: Icons.arrow_back_rounded, 
                            text: "Annulla", 
                            action: (){}
                          ),
                        ]);
                    }
                  );
                  
                },
              )
            )
            :
              Expanded(
                child:EmptyState(
                  icon: Icons.comments_disabled_rounded,
                  message: "Nessun commento. Sii il primo!",
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      minLines: 1,
                      maxLines: 3,
                      maxLength: 256,
                      decoration: InputDecoration(
                        hintText: 'Scrivi un commento...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(color: Colors.green),
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                      ),
                      onSubmitted: (value) => _submitComment(value),
                    ),
                  ),
                  SizedBox(width: 8.0),
                  IconButton(
                    icon: Icon(Icons.send, color: Colors.green[500]),
                    onPressed: (){
                      _submitComment(_controller.text).then((value)
                      {
                        FocusManager.instance.primaryFocus?.unfocus(); // Chiudi la tastiera
                        _scrollController.animateTo(
                          _scrollController.position.maxScrollExtent,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeOut,
                        );
                      });
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      )
    );
  }

  Future _submitComment(String comment) async
  {
     Map<String, dynamic> data = {
      'post_id': widget.postId,
      'comment': comment
    };
    
    var res = await ApiManager.postData('post/comment', data);  
    var decoded = json.decode(res!);

    Map<String, dynamic> new_comment = {
      'comment': comment.trim(),
      'comment_date': DateFormat('yyyy-MM-dd').format(DateTime.now()),
      'user': AppService.instance.currentUser!.userid!,
      'commentId': decoded['CommentId'],
    };

    setState(() {
      widget.commenti.add(new_comment);
    });
    
  }
}