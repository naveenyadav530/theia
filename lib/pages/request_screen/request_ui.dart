import 'package:flutter/material.dart';
import 'package:pangeachat/utils/api/user_details_api.dart';
import 'package:vrouter/vrouter.dart';

class RequestEnrollUI extends StatefulWidget {
  const RequestEnrollUI({Key? key}) : super(key: key);

  @override
  State<RequestEnrollUI> createState() => _RequestEnrollUIState();
}

class _RequestEnrollUIState extends State<RequestEnrollUI> {


  @override
  Widget build(BuildContext context) {
    String roomID = VRouter.of(context).queryParameters["room_id"] ?? "";
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Request to enroll?"),
            const SizedBox(
              height: 6.0,
            ),
            Text("(other important info here?)"),
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Container(
                //   height: 50,
                //   padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                //   decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(15.0),
                //       border: Border.all(color: Colors.black, width: 1.0)),
                //   child: Center(
                //     child: Text(
                //       "Cancel",
                //       style: TextStyle()
                //           .copyWith(fontWeight: FontWeight.w400, fontSize: 15),
                //     ),
                //   ),
                // ),
                SizedBox(
                  width: 200,
                  child: Flexible(
                    flex: 0,
                    fit: FlexFit.tight,
                    child: OutlinedButton(
                      style:
                      OutlinedButton.styleFrom(
                        shape:
                        RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius
                                .circular(
                                25.0)),
                        side: BorderSide(
                          width: 2,
                          color: Theme.of(context)
                              .colorScheme
                              .onPrimary ==
                              Colors.white
                              ? Theme.of(context)
                              .primaryColor
                              : Theme.of(context)
                              .colorScheme
                              .onPrimary,
                        ),
                      ),
                      onPressed: () {
                        print("value is printted");
                       // UserDetails.enrollClassValidate(context: context, room_id: '${classDetailUi!.pangeaClassRoomId}');
                       // VRouter.of(context).to('/classDetails', queryParameters: { "id":id });
                      },
                      child: Text(
                        "cancel",
                        style: const TextStyle()
                            .copyWith(
                            color: Theme.of(
                                context)
                                .textTheme
                                .bodyText1!
                                .color,
                            fontWeight:
                            FontWeight.w400,
                            fontSize: 12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                SizedBox(
                  width: 200,
                  child: Flexible(
                    flex: 0,
                    fit: FlexFit.tight,
                    child: OutlinedButton(
                      style:
                      OutlinedButton.styleFrom(
                        shape:
                        RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius
                                .circular(
                                25.0)),
                        side: BorderSide(
                          width: 2,
                          color: Theme.of(context)
                              .colorScheme
                              .onPrimary ==
                              Colors.white
                              ? Theme.of(context)
                              .primaryColor
                              : Theme.of(context)
                              .colorScheme
                              .onPrimary,
                        ),
                      ),
                      onPressed: () {
                        print("value is printted");
                        final String room_ID = context.vRouter
                            .queryParameters['room_id'] ??
                            "";
                        print(room_ID);
                        print(roomID);
                        print(room_ID);
                        UserDetails.enrollClassValidate(context: context, room_id: '${room_ID}');

                      },
                      child: Text(
                        "Request an Enroll",
                        style: const TextStyle()
                            .copyWith(
                            color: Theme.of(
                                context)
                                .textTheme
                                .bodyText1!
                                .color,
                            fontWeight:
                            FontWeight.w400,
                            fontSize: 12),
                      ),
                    ),
                  ),
                ),
                // Container(
                //   height: 50,
                //   padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                //   decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(15.0),
                //       border: Border.all(color: Colors.black, width: 1.0)),
                //   child: Center(
                //     child: Text("Request",
                //         style: TextStyle().copyWith(
                //             color: Theme.of(context).textTheme.bodyText1!.color,
                //             fontWeight: FontWeight.w400,
                //             fontSize: 15)),
                //   ),
                // ),
              ],
            )
          ],
        ),
      ),
    );
  }
}


//