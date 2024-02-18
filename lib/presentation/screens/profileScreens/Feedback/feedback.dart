import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:scarvs/core/models/api_order_detail.dart';
import 'package:scarvs/core/notifiers/authentication.notifer.dart';
import 'package:scarvs/presentation/screens/profileScreens/ordersPage/order_detail_page.dart';

class FeedbackDialog extends StatefulWidget {
  final OrderDetail order;
  final String field;

  FeedbackDialog({required this.order, required this.field});

  @override
  _FeedbackDialogState createState() => _FeedbackDialogState();
}

class _FeedbackDialogState extends State<FeedbackDialog> {
  late TextEditingController _textEditingController;

  double ratingValue = 0;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        _showFeedbackDialog(widget.order, context, widget.field);
        var authNotifier =
            Provider.of<AuthenticationNotifier>(context, listen: false);
        authNotifier.auth.id;
      },
      child: Text("Open Feedback Dialog"),
    );
  }

  void _showFeedbackDialog(
      OrderDetail order, BuildContext context, String field) {
    var authNotifier =
        Provider.of<AuthenticationNotifier>(context, listen: false);
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            body: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 20),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 14),
                  child: TextFormField(
                    controller: _textEditingController,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      labelText: "Enter Your Feedback:",
                      labelStyle: TextStyle(color: Colors.grey),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    cursorColor: Colors.blue,
                    cursorWidth: 3,
                    cursorHeight: 20,
                    textAlignVertical: TextAlignVertical.center,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.sentences,
                    maxLength: 80,
                    maxLines: 3,
                    onChanged: (value) {},
                    onEditingComplete: () {},
                    validator: (value) {},
                  ),
                ),
                SizedBox(height: 25),
                RatingBar.builder(
                  initialRating: 0,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemSize: 30,
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    setState(() {
                      ratingValue = rating;
                    });
                  },
                ),
                SizedBox(height: 25),
                ElevatedButton(
                  onPressed: () {
                    sendFeedBackToApi(
                      productId: order.productId,
                      context: context,
                      title: 'Feedback',
                      content: _textEditingController.text,
                      userId: authNotifier.auth.id,
                      start: ratingValue.toInt(),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 233, 153, 34),
                    onPrimary: Colors.white,
                  ),
                  child: Text("Save"),
                ),
                SizedBox(height: 25),
              ],
            ),
          ),
        );
      },
    );
  }
}