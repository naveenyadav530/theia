import 'dart:async';

import 'package:flutter/material.dart';

import 'package:animations/animations.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:get_storage/get_storage.dart';
import 'package:matrix/matrix.dart';

import 'package:pangeachat/pages/chat_list/chat_list.dart';
import 'package:pangeachat/pages/chat_list/chat_list_item.dart';
import 'package:pangeachat/pages/chat_list/spaces_bottom_bar.dart';
import 'package:pangeachat/pages/chat_list/spaces_entry.dart';
import 'package:pangeachat/pages/chat_list/stories_header.dart';
import '../../utils/stream_extension.dart';
import '../../widgets/matrix.dart';

class ChatListViewBody extends StatefulWidget {
  final ChatListController controller;

  const ChatListViewBody(this.controller, {Key? key}) : super(key: key);

  @override
  State<ChatListViewBody> createState() => _ChatListViewBodyState();
}

class _ChatListViewBodyState extends State<ChatListViewBody> {
  // the matrix sync stream
  late StreamSubscription _subscription;

  // used to check the animation direction
  String? _lastUserId;
  SpacesEntry? _lastSpace;

  @override
  void initState() {
    _subscription = Matrix.of(context)
        .client
        .onSync
        .stream
        .where((s) => s.hasRoomUpdate)
        .rateLimit(const Duration(seconds: 1))
        .listen((d) => setState(() {}));
    super.initState();
  }

  bool _roomInsideSpace(Room room, Room space) {
    if (space.spaceChildren.any((child) => child.roomId == room.id)) {
      print("k");
      return true;
    }
    if (room.spaceParents.any((parent) => parent.roomId == space.id)) {
      print("j");
      return true;
    }
    return true;
  }



  @override
  Widget build(BuildContext context) {
    final reversed = !_animationReversed();
    Widget child;
    if (widget.controller.waitForFirstSync &&  Matrix.of(context).client.prevBatch != null) {
      final rooms = widget.controller.activeSpacesEntry.getRooms(context);
      if (rooms.isEmpty) {
        child = Column(
          key: const ValueKey(null),
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.asset(
              'assets/private_chat_wallpaper.png',
              width: 160,
              height: 160,
            ),
            Center(
              child: Text(
                L10n.of(context)!.startYourFirstChat,
                textAlign: TextAlign.start,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        );
      }
      else {
        try{
         // print("empty");
        // final value =  widget.controller.defaultSpacesEntry;
        //  if(value.getRooms(context).isNotEmpty){
        //   value.getRooms(context).forEach((element) {
        //     print(element.displayname);
        //   });
        //  }

         //  print(widget.controller.defaultSpacesEntry);
          // print(Matrix.of(context)
          //     .client
          //     .getRoomById(widget.controller.activeSpaceId!)!
          //     .displayname);
          // print(widget.controller.activeSpaceId);
        List<String> ids =[];
          widget.controller.spaces.forEach((element) {
            ids.add(element.id);
            //print(element.getParticipants().length);
           // List<Room> data = Matrix.of(context).client.rooms;
           // print(data.length);
            //element.id;
            //print("is class: ${element.isSpace}");
            //print();
          });
          // ids.forEach((element) {
          //   Future.delayed(const Duration(milliseconds: 500), () {
          //    // print(element);
          //     List<User> user = Matrix
          //         .of(context)
          //         .client
          //         .getRoomById(element)!
          //         .getParticipants();
          //     user.forEach((element) {
          //       print(element.displayName);
          //     });
          //   });
          //
          //   // List<User> classUsers = [];
          // });

        //  print(classUsers.length);
        }catch(e){
          print("eerrr");
        }
        final displayStoriesHeader = widget.controller.activeSpacesEntry
            .shouldShowStoriesHeader(context);
        child = ListView.builder(
          key: ValueKey(Matrix.of(context).client.userID.toString() +
              widget.controller.activeSpaceId.toString() +
              widget.controller.activeSpacesEntry.runtimeType.toString()),
          controller: widget.controller.scrollController,
          // add +1 space below in order to properly scroll below the spaces bar
          itemCount: rooms.length + (displayStoriesHeader ? 2 : 1),
          itemBuilder: (BuildContext context, int i) {
            if (displayStoriesHeader) {
              if (i == 0) {
                return const StoriesHeader();
              }
              i--;
            }
            if (i >= rooms.length) {
              return const ListTile();
            }
          //  print(Matrix.of(context).client.getRoomById(rooms[i].id)!.getParticipants());

          //   print(widget.controller.activeChat);
          //   print(widget.controller.selectedRoomIds);
          //   print(widget.controller.selectedRoomIds.contains(rooms[i].id));

            //   Room? classRoom = Matrix.of(context).client.getRoomById(listOfClasses.id);
            //Room? space = Matrix.of(context).client.getRoomById(widget.controller.spaces[0].id);
            //{"class": "listofClasses","students":"[id]"},{"class": "listofClasses","students":"[id]"}
            final List<String> studentsList =[];
            for (final listOfClasses in widget.controller.spaces) {
              print(listOfClasses.id);
              final classRoom =  Matrix.of(context).client.getRoomById(listOfClasses.id)!.getParticipants();
              for (final student in classRoom) {
                if(!studentsList.contains(student.id)){
                  studentsList.add(student.id);
                }
              }
            }
         //  //  print(space!.displayname);
         // // print(widget.controller.spaces[0].displayname);List<String> classIds =[];
         // final data =  Matrix.of(context).client.getRoomById(widget.controller.spaces[0].id)!.getParticipants();
         //
         // data.forEach((element) {
         //   print(element.displayName);
         //   print(element.id);
         //
         // });
          //     print(widget.controller.spaces[1].displayname);
          //     print(widget.controller.spaces[0].spaceParents);
           // print(space.spaceChildren.any((child) => child.roomId == rooms[i].id));
           // print(rooms[i].spaceParents.any((parent) => parent.roomId == space.id));
          //   }else{
          //    print("no room");
          //   }
            GetStorage().write("studentList", studentsList);
            print(studentsList);
            return ChatListItem(
              rooms[i],
              selected: widget.controller.selectedRoomIds.contains(rooms[i].id),
              onTap: widget.controller.selectMode == SelectMode.select? () => widget.controller.toggleSelection(rooms[i].id)
                  : null,
              onLongPress: () => widget.controller.toggleSelection(rooms[i].id),
              activeChat: widget.controller.activeChat == rooms[i].id,
            );
          },
        );
      }
    }
    else {
      const dummyChatCount = 5;
      final titleColor =
          Theme.of(context).textTheme.bodyText1!.color!.withAlpha(100);
      final subtitleColor =
          Theme.of(context).textTheme.bodyText1!.color!.withAlpha(50);
      child = ListView.builder(
        itemCount: dummyChatCount,
        itemBuilder: (context, i) => Opacity(
          opacity: (dummyChatCount - i) / dummyChatCount,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: titleColor,
              child: CircularProgressIndicator(
                strokeWidth: 1,
                color: Theme.of(context).textTheme.bodyText1!.color,
              ),
            ),
            title: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 14,
                    decoration: BoxDecoration(
                      color: titleColor,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
                const SizedBox(width: 36),
                Container(
                  height: 14,
                  width: 14,
                  decoration: BoxDecoration(
                    color: subtitleColor,
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  height: 14,
                  width: 14,
                  decoration: BoxDecoration(
                    color: subtitleColor,
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ],
            ),
            subtitle: Container(
              decoration: BoxDecoration(
                color: subtitleColor,
                borderRadius: BorderRadius.circular(3),
              ),
              height: 12,
              margin: const EdgeInsets.only(right: 22),
            ),
          ),
        ),
      );
    }
    return PageTransitionSwitcher(
      reverse: reversed,
      transitionBuilder: (
        Widget child,
        Animation<double> primaryAnimation,
        Animation<double> secondaryAnimation,
      ) {
        return SharedAxisTransition(
          animation: primaryAnimation,
          secondaryAnimation: secondaryAnimation,
          transitionType: (widget.controller.snappingSheetController.isAttached
                      ? widget
                          .controller.snappingSheetController.currentPosition
                      : 0) ==
                  kSpacesBottomBarHeight
              ? SharedAxisTransitionType.horizontal
              : SharedAxisTransitionType.vertical,
          fillColor: Theme.of(context).scaffoldBackgroundColor,
          child: child,
        );
      },
      child: child,
    );
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  bool _animationReversed() {
    bool reversed;
    // in case the matrix id changes, check the indexOf the matrix id
    final newClient = Matrix.of(context).client;
    if (_lastUserId != newClient.userID) {
      reversed = Matrix.of(context)
              .currentBundle!
              .indexWhere((element) => element!.userID == _lastUserId) <
          Matrix.of(context)
              .currentBundle!
              .indexWhere((element) => element!.userID == newClient.userID);
    }
    // otherwise, the space changed...
    else {
      reversed = widget.controller.spacesEntries
              .indexWhere((element) => element == _lastSpace) <
          widget.controller.spacesEntries.indexWhere(
              (element) => element == widget.controller.activeSpacesEntry);
    }
    _lastUserId = newClient.userID;
    _lastSpace = widget.controller.activeSpacesEntry;
    return reversed;
  }
}
