import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:matrix/matrix.dart';
import 'package:pangeachat/pages/chat_list/chat_list_item.dart';
import 'package:pangeachat/pages/search/search_view_controller.dart';
import 'package:pangeachat/services/services.dart';
import 'package:pangeachat/utils/string_extension.dart';
import 'package:pangeachat/widgets/avatar.dart';
import 'package:pangeachat/widgets/contacts_list.dart';
import 'package:pangeachat/widgets/matrix.dart';
import 'package:vrouter/vrouter.dart';

import '../../config/environment.dart';
import '../../services/controllers.dart';
import '../../utils/localized_exception_extension.dart';
import '../../utils/platform_infos.dart';
import 'search.dart';

class SearchView extends StatefulWidget {
  final SearchController controller;
  final searchController = Get.put(SearchViewController());

  SearchView(this.controller, {Key? key}) : super(key: key);

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final searchController = Get.put(SearchViewController());

  var box = GetStorage();
  String id = "";
  Rx<bool> firstTime=true.obs;
  void addAgesAction() => VRouter.of(context).to('/user');

  void createInviteAction() => VRouter.of(context).to('/inviteScreen');

  void createNewClassAction() => VRouter.of(context).to('/addClass');

  void classProfile(String id) => VRouter.of(context).to('/classProfile', queryParameters: {
        "id": id,
      });

  PangeaControllers getxController = Get.put(PangeaControllers());
  @override
  void initState() {
    super.initState();
    final int age1 = box.read("age") ?? 0;
    age1 == 0 ? searchController.age.value = 0 : searchController.age.value = age1;
    searchController.getClasses();




  }

  fetchFlag(String url, int i) {
    try {
      final String path = url + "${searchController.classList[i].flags![1].languageFlag}" ?? "";
      return path.isNotEmpty
          ? Avatar(
              mxContent: Uri.parse(path),
              name: "publicRoomsResponse.chunk[i].name",
              size: 15,
            )
          : Container();
    } catch (e) {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    final server =
        widget.controller.genericSearchTerm?.isValidMatrixId ?? false ? widget.controller.genericSearchTerm!.domain : widget.controller.server;
    if (widget.controller.lastServer != server) {
      widget.controller.lastServer = server;
      widget.controller.publicRoomsResponse = null;
    }
    widget.controller.publicRoomsResponse ??= Matrix.of(context)
        .client
        .queryPublicRooms(
          server: server,
          filter: PublicRoomQueryFilter(
            genericSearchTerm: widget.controller.genericSearchTerm,
          ),
        )
        .catchError((error) {
      if (!(widget.controller.genericSearchTerm?.isValidMatrixId ?? false)) {
        throw error;
      }
      return QueryPublicRoomsResponse.fromJson({
        'chunk': [],
      });
    }).then((QueryPublicRoomsResponse res) {
      final genericSearchTerm = widget.controller.genericSearchTerm;
      if (genericSearchTerm != null && !res.chunk.any((room) => room.canonicalAlias == widget.controller.genericSearchTerm)) {
        // we have to tack on the original alias
        res.chunk.add(
          PublicRoomsChunk(
            name: genericSearchTerm,
            numJoinedMembers: 0,
            roomId: '!unknown',
            worldReadable: true,
            guestCanJoin: true,
          ),
        );
      }
      return res;
    });

    final rooms = List<Room>.from(Matrix.of(context).client.rooms);
    rooms.removeWhere(
      (room) =>
          room.lastEvent == null ||
          !room.displayname.toLowerCase().removeDiacritics().contains(widget.controller.controller.text.toLowerCase().removeDiacritics()),
    );
    const tabCount = 3;
    final String basePath = Environment.baseAPI;
    final List<String> data = basePath.split("/api/v1");
    final String url = data[0];

    return DefaultTabController(
      length: tabCount,
      initialIndex: widget.controller.controller.text.startsWith('#')
          ? 0
          : getxController.throughClassProfile.value
              ? 0
              : 1,
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () {
              getxController.throughClassProfile.value = false;
              VRouter.of(context).to("/rooms");
            },
          ),
          titleSpacing: 0,
          title: TextField(
            autofocus: true,
            controller: widget.controller.controller,
            decoration: InputDecoration(
              suffix: const Icon(Icons.search_outlined),
              hintText: L10n.of(context)!.search,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            onChanged: widget.controller.search,
          ),
          bottom: TabBar(
            indicatorColor: Theme.of(context).colorScheme.secondary,
            labelColor: Theme.of(context).colorScheme.secondary,
            unselectedLabelColor: Theme.of(context).textTheme.bodyText1!.color,
            labelStyle: const TextStyle(fontSize: 16),
            labelPadding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 0,
            ),
            tabs: [
              Tab(child: Text(L10n.of(context)!.discover, maxLines: 1)),
              Tab(child: Text(L10n.of(context)!.chats, maxLines: 1)),
              Tab(child: Text(L10n.of(context)!.people, maxLines: 1)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Obx(() => searchController.age.value <= 18
                ? SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 50,
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Pangea Chat serves schools and other learning communities,ages 13 and up, around the world. In order to protect our young learners, we ask our users to verify their age before connecting to our community. Before you can search Pangea Chat for classes, rooms, and new friends, you must verify you are 18 or older.",
                            style: TextStyle().copyWith(color: Theme.of(context).textTheme.bodyText1!.color, fontSize: 16),
                            overflow: TextOverflow.clip,
                            textAlign: TextAlign.center,
                          ),
                        ),

                        const SizedBox(
                          height: 16,
                        ),
                        GestureDetector(
                          onTap: () {
                            addAgesAction();
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Theme.of(context).colorScheme.onPrimary,
                                  border: Border.all(
                                      color: Theme.of(context).colorScheme.onPrimary == Colors.white
                                          ? Theme.of(context).primaryColor
                                          : Theme.of(context).colorScheme.onPrimary)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 42, vertical: 6),
                                child: Text(
                                  "Verify my account",
                                  style: TextStyle().copyWith(color: Theme.of(context).textTheme.bodyText1!.color, fontSize: 16),
                                ),
                              )),
                        ),
                        const SizedBox(
                          height: 134,
                        ),
                        // GestureDetector(
                        //   onTap: () {
                        //     createInviteAction();
                        //   },
                        //   child: Container(
                        //       decoration: BoxDecoration(
                        //         borderRadius: BorderRadius.circular(10),
                        //         color: Theme.of(context).colorScheme.onPrimary,
                        //           border: Border.all(
                        //               color: Theme.of(context)
                        //                   .colorScheme
                        //                   .onPrimary ==
                        //                   Colors.white
                        //                   ? Theme.of(context).primaryColor
                        //                   : Theme.of(context)
                        //                   .colorScheme
                        //                   .onPrimary
                        //           )
                        //       ),
                        //       child: Padding(
                        //         padding: const EdgeInsets.symmetric(
                        //             horizontal: 42, vertical: 6),
                        //         child: Text(
                        //           "Invite your friends",
                        //           style: TextStyle().copyWith(
                        //               color: Theme.of(context)
                        //                   .textTheme
                        //                   .bodyText1!
                        //                   .color,
                        //               fontSize: 16),
                        //         ),
                        //       )),
                        // ),
                        //
                        //
                        // const SizedBox(
                        //   height: 19,
                        // ),
                        box.read("usertype") == 2
                            ? GestureDetector(
                                onTap: () {
                                  createNewClassAction();
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                        // borderRadius: BorderRadius.circular(10),
                                        borderRadius: BorderRadius.circular(10),
                                        color: Theme.of(context).colorScheme.onPrimary,
                                        border: Border.all(
                                            color: Theme.of(context).colorScheme.onPrimary == Colors.white
                                                ? Theme.of(context).primaryColor
                                                : Theme.of(context).colorScheme.onPrimary)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 42, vertical: 6),
                                      child: Text(
                                        "Create a class",
                                        style: TextStyle().copyWith(color: Theme.of(context).textTheme.bodyText1!.color, fontSize: 16),
                                      ),
                                    )),
                              )
                            : InkWell(
                                onTap: () {
                                  VRouter.of(context).to("/join_with_code");
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                        // borderRadius: BorderRadius.circular(10),
                                        borderRadius: BorderRadius.circular(10),
                                        color: Theme.of(context).colorScheme.onPrimary,
                                        border: Border.all(
                                            color: Theme.of(context).colorScheme.onPrimary == Colors.white
                                                ? Theme.of(context).primaryColor
                                                : Theme.of(context).colorScheme.onPrimary)),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 42, vertical: 6),
                                      child: Text(
                                        "Join with a class code",
                                        style: TextStyle().copyWith(color: Theme.of(context).textTheme.bodyText1!.color, fontSize: 16),
                                      ),
                                    )))
                      ],
                    ),
                  )
                : ListView(
                    keyboardDismissBehavior:
                        PlatformInfos.isIOS ? ScrollViewKeyboardDismissBehavior.onDrag : ScrollViewKeyboardDismissBehavior.manual,
                    children: [
                      const SizedBox(height: 12),
                      widget.controller.controller.text!=""?
                      FutureBuilder(
                          future: searchController.getSearch(widget.controller.controller.text),
                          builder: (BuildContext context, AsyncSnapshot snapshot) {
                            //print(widget.controller.controller.text);
                            if (snapshot.hasError) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(height: 32),
                                  const Icon(
                                    Icons.error_outlined,
                                    size: 80,
                                    color: Colors.grey,
                                  ),
                                  Center(
                                    child: Text(
                                      snapshot.error!.toLocalizedString(context),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }
                            if (snapshot.connectionState != ConnectionState.done) {
                              return const Center(child: CircularProgressIndicator.adaptive(strokeWidth: 2));
                            }
                            return GridView.builder(
                              //controller: searchController.controller,
                              shrinkWrap: true,
                              padding: const EdgeInsets.all(12),
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.75,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                              itemCount: searchController.searchList.length,
                              itemBuilder: (BuildContext context, int i) {
                                //  if(searchController.classList[i])
                                return Material(
                                  elevation: 15,
                                  color: const Color(0xffF6F6F6),
                                  borderRadius: BorderRadius.circular(16),
                                  child: InkWell(
                                    onTap: () async {
                                      id = searchController.searchList[i].pangea_class_room_id.toString();
                                      firstTime.value?classProfile(id):VRouter.of(context).to(
                                          '',
                                          queryParameters: {
                                            "id": id
                                          });
                                      firstTime.value=false;
                                      //print("value of 2 ${firstTime}");


                                      // VRouter.of(context).to("/allclassDetails", queryParameters: {"id": id});
                                    },
                                    borderRadius: BorderRadius.circular(16),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(16.0),
                                          boxShadow: const [
                                            BoxShadow(color: Colors.black12, blurRadius: 1.0, offset: Offset(2.0, 2.0), spreadRadius: 1.0)
                                          ],
                                          color: Theme.of(context).colorScheme.background),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Stack(
                                              children: [
                                                Container(
                                                  child: searchController.searchList[i].profilePic != null
                                                      ? Avatar(
                                                    mxContent: Uri.parse("${searchController.searchList[i].profilePic}"),
                                                  )
                                                      : const Padding(
                                                    padding: EdgeInsets.all(5.0),
                                                    child: Icon(
                                                      Icons.people,
                                                      size: 40,
                                                    ),
                                                  ),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(color: Theme.of(context).colorScheme.onPrimary, width: 2.0),
                                                      shape: BoxShape.circle),
                                                ),
                                                Positioned(
                                                  child: Container(
                                                    padding: const EdgeInsets.all(2.0),
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Theme.of(context).colorScheme.onPrimary,
                                                        border: Border.all(color: Colors.white, width: 2)),
                                                    child: const Icon(
                                                      Icons.school,
                                                      size: 15.0,
                                                    ),
                                                  ),
                                                  bottom: 0,
                                                  right: 0,
                                                )
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10.0,
                                            ),
                                            Text(
                                                searchController.searchList[i].classAuthor != Null
                                                    ? "${searchController.searchList[i].classAuthor}"
                                                    : "Na",
                                                style: TextStyle().copyWith(
                                                  color: Theme.of(context).textTheme.bodyText1!.color,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                  overflow: TextOverflow.clip,
                                                )),
                                            Text(
                                                searchController.searchList[i].className != Null
                                                    ? "${searchController.searchList[i].className}"
                                                    : "Na",
                                                style: TextStyle().copyWith(
                                                  color: Theme.of(context).textTheme.bodyText1!.color,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w400,
                                                  overflow: TextOverflow.clip,
                                                )),
                                            const SizedBox(
                                              height: 10.0,
                                            ),
                                            Row(
                                              children: [
                                                const Icon(Icons.location_pin, size: 12),
                                                const SizedBox(
                                                  width: 10.0,
                                                ),
                                                searchController.searchList[i].city!.isNotEmpty
                                                    ? Text("${searchController.searchList[i].city}",
                                                    style: TextStyle().copyWith(
                                                      color: Theme.of(context).textTheme.bodyText1!.color,
                                                      fontSize: 10,
                                                      fontWeight: FontWeight.w400,
                                                      overflow: TextOverflow.clip,
                                                    ))
                                                    : Text("N/A",
                                                    style: TextStyle().copyWith(
                                                      color: Theme.of(context).textTheme.bodyText1!.color,
                                                      fontSize: 10,
                                                      fontWeight: FontWeight.w400,
                                                      overflow: TextOverflow.clip,
                                                    )),
                                                const SizedBox(
                                                  width: 20,
                                                ),
                                                const Icon(Icons.star, size: 12),
                                                const SizedBox(
                                                  width: 10.0,
                                                ),
                                                searchController.searchList[i].rating.toString().isNotEmpty
                                                    ? Text(
                                                    searchController.searchList[i].rating.toString() != Null
                                                        ? "${searchController.searchList[i].rating.toString()}"
                                                        : "Na",
                                                    style: TextStyle().copyWith(
                                                      color: Theme.of(context).textTheme.bodyText1!.color,
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w400,
                                                      overflow: TextOverflow.clip,
                                                    ))
                                                    : Text("N/A",
                                                    style: TextStyle().copyWith(
                                                      color: Theme.of(context).textTheme.bodyText1!.color,
                                                      fontSize: 10,
                                                      fontWeight: FontWeight.w400,
                                                      overflow: TextOverflow.clip,
                                                    )),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const Icon(Icons.supervisor_account_sharp, size: 12),
                                                const SizedBox(
                                                  width: 10.0,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                      searchController.searchList[i].total_student.toString() != 0
                                                          ? "${searchController.searchList[i].total_student.toString()} Students"
                                                          : "Na",
                                                      style: TextStyle().copyWith(
                                                        color: Theme.of(context).textTheme.bodyText1!.color,
                                                        fontSize: 10,
                                                        fontWeight: FontWeight.w400,
                                                        overflow: TextOverflow.clip,
                                                      )),
                                                )
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const Icon(Icons.query_stats, size: 12),
                                                const SizedBox(
                                                  width: 10.0,
                                                ),
                                                Text(
                                                    searchController.searchList[i].languageLevel.toString() != Null
                                                        ? level(searchController.searchList[i].languageLevel.toString())
                                                        : "Na",
                                                    style: TextStyle().copyWith(
                                                      color: Theme.of(context).textTheme.bodyText1!.color,
                                                      fontSize: 10,
                                                      fontWeight: FontWeight.w400,
                                                      overflow: TextOverflow.clip,
                                                    ))
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const Icon(Icons.account_balance, size: 12),
                                                const SizedBox(
                                                  width: 10.0,
                                                ),
                                                Text(
                                                    searchController.searchList[i].schoolName != ""
                                                        ? "${searchController.searchList[i].schoolName}"
                                                        : "Not disclosed",
                                                    style: TextStyle().copyWith(
                                                      color: Theme.of(context).textTheme.bodyText1!.color,
                                                      fontSize: 10,
                                                      fontWeight: FontWeight.w400,
                                                      overflow: TextOverflow.clip,
                                                    ))
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10.0,
                                            ),
                                            Row(
                                              children: [
                                                const Spacer(),
                                                fetchFlag(url, i),
                                                const SizedBox(
                                                  width: 5.0,
                                                ),
                                                const Icon(Icons.arrow_right_alt_outlined, size: 17),
                                                const SizedBox(
                                                  width: 5.0,
                                                ),
                                                Avatar(
                                                  mxContent: Uri.parse(url + "${searchController.searchList[i].flags![0].languageFlag}"),
                                                  name: "publicRoomsResponse.chunk[i].name",
                                                  size: 15,
                                                ),
                                                const Spacer(),
                                                Text("free",
                                                    style: TextStyle().copyWith(
                                                      color: Theme.of(context).textTheme.bodyText1!.color,
                                                      fontSize: 10,
                                                      fontWeight: FontWeight.w400,
                                                      overflow: TextOverflow.clip,
                                                    ))
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          })
                          :FutureBuilder<QueryPublicRoomsResponse>(
                          future: widget.controller.publicRoomsResponse,
                          builder: (BuildContext context, AsyncSnapshot<QueryPublicRoomsResponse> snapshot) {
                            if (snapshot.hasError) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(height: 32),
                                  const Icon(
                                    Icons.error_outlined,
                                    size: 80,
                                    color: Colors.grey,
                                  ),
                                  Center(
                                    child: Text(
                                      snapshot.error!.toLocalizedString(context),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }
                            if (snapshot.connectionState != ConnectionState.done) {
                              return const Center(child: CircularProgressIndicator.adaptive(strokeWidth: 2));
                            }
                            final publicRoomsResponse = snapshot.data!;
                            if (publicRoomsResponse.chunk.isEmpty) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(height: 32),
                                  const Icon(
                                    Icons.search_outlined,
                                    size: 80,
                                    color: Colors.grey,
                                  ),
                                  Center(
                                    child: Text(
                                      L10n.of(context)!.noPublicRoomsFound,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }
                            return Column(
                              children: [
                                Obx(() => searchController.next.value || searchController.previous.value
                                    ? Container(
                                        child: Row(
                                          children: [
                                            searchController.previous.value
                                                ? InkWell(
                                                    child: Padding(
                                                      padding: EdgeInsets.all(8.0),
                                                      child: Icon(
                                                        Icons.arrow_back_ios,
                                                        size: 20,
                                                        color: Theme.of(context).colorScheme.onPrimary == Colors.white
                                                            ? Theme.of(context).primaryColor
                                                            : Theme.of(context).colorScheme.onPrimary,
                                                      ),
                                                    ),
                                                    onTap: () {


                                                      if(searchController.pageNo.value>0){
                                                        searchController.load1.value=false;
                                                        searchController.pageNo.value = searchController.pageNo.value - 1;
                                                        searchController.getClasses();
                                                      }
                                                      else{
                                                        print(searchController.pageNo.value);
                                                      }

                                                    },
                                                  )
                                                : const SizedBox(),
                                            const Spacer(),
                                            searchController.next.value
                                                ? InkWell(
                                                    onTap: () {
                                                      searchController.load1.value=false;
                                                      searchController.pageNo.value = searchController.pageNo.value + 1;
                                                      searchController.getClasses();

                                                    },
                                                    child: Padding(
                                                      padding: EdgeInsets.all(8.0),
                                                      child: Icon(
                                                        Icons.arrow_forward_ios,
                                                        size: 20,
                                                        color: Theme.of(context).colorScheme.onPrimary == Colors.white
                                                            ? Theme.of(context).primaryColor
                                                            : Theme.of(context).colorScheme.onPrimary,
                                                      ),
                                                    ),
                                                  )
                                                : const SizedBox(),
                                          ],
                                        ),
                                        margin: const EdgeInsets.symmetric(horizontal: 10),
                                      )
                                    : const SizedBox()),
                                Obx(() => !searchController.loading.value && searchController.classList != Null
                                    ? searchController.load1.value==true? GridView.builder(
                                        //controller: searchController.controller,
                                        shrinkWrap: true,
                                        padding: const EdgeInsets.all(12),
                                        physics: const NeverScrollableScrollPhysics(),
                                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          childAspectRatio: 0.75,
                                          crossAxisSpacing: 10,
                                          mainAxisSpacing: 10,
                                        ),
                                        itemCount: searchController.classList.length,
                                        itemBuilder: (BuildContext context, int i) {
                                          //  if(searchController.classList[i])
                                          return Material(
                                            elevation: 15,
                                            color: const Color(0xffF6F6F6),
                                            borderRadius: BorderRadius.circular(16),
                                            child: InkWell(
                                              onTap: () async {
                                                id = searchController.classList[i].pangea_class_room_id.toString();
                                                firstTime.value?classProfile(id):VRouter.of(context).to(
                                                    '',
                                                    queryParameters: {
                                                      "id": id
                                                    });
                                                firstTime.value=false;
                                                print("value of 2 ${firstTime}");


                                               // VRouter.of(context).to("/allclassDetails", queryParameters: {"id": id});
                                              },
                                              borderRadius: BorderRadius.circular(16),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(16.0),
                                                    boxShadow: const [
                                                      BoxShadow(color: Colors.black12, blurRadius: 1.0, offset: Offset(2.0, 2.0), spreadRadius: 1.0)
                                                    ],
                                                    color: Theme.of(context).colorScheme.background),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(10.0),
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Stack(
                                                        children: [
                                                          Container(
                                                            child: searchController.classList[i].profilePic != null
                                                                ? Avatar(
                                                                    mxContent: Uri.parse("${searchController.classList[i].profilePic}"),
                                                                  )
                                                                : const Padding(
                                                                    padding: EdgeInsets.all(5.0),
                                                                    child: Icon(
                                                                      Icons.people,
                                                                      size: 40,
                                                                    ),
                                                                  ),
                                                            decoration: BoxDecoration(
                                                                border: Border.all(color: Theme.of(context).colorScheme.onPrimary, width: 2.0),
                                                                shape: BoxShape.circle),
                                                          ),
                                                          Positioned(
                                                            child: Container(
                                                              padding: const EdgeInsets.all(2.0),
                                                              decoration: BoxDecoration(
                                                                  shape: BoxShape.circle,
                                                                  color: Theme.of(context).colorScheme.onPrimary,
                                                                  border: Border.all(color: Colors.white, width: 2)),
                                                              child: const Icon(
                                                                Icons.school,
                                                                size: 15.0,
                                                              ),
                                                            ),
                                                            bottom: 0,
                                                            right: 0,
                                                          )
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 10.0,
                                                      ),
                                                      Text(
                                                          searchController.classList[i].classAuthor != Null
                                                              ? "${searchController.classList[i].classAuthor}"
                                                              : "Na",
                                                          style: TextStyle().copyWith(
                                                            color: Theme.of(context).textTheme.bodyText1!.color,
                                                            fontSize: 14,
                                                            fontWeight: FontWeight.w400,
                                                            overflow: TextOverflow.clip,
                                                          )),
                                                      Text(
                                                          searchController.classList[i].className != Null
                                                              ? "${searchController.classList[i].className}"
                                                              : "Na",
                                                          style: TextStyle().copyWith(
                                                            color: Theme.of(context).textTheme.bodyText1!.color,
                                                            fontSize: 10,
                                                            fontWeight: FontWeight.w400,
                                                            overflow: TextOverflow.clip,
                                                          )),
                                                      const SizedBox(
                                                        height: 10.0,
                                                      ),
                                                      Row(
                                                        children: [
                                                          const Icon(Icons.location_pin, size: 12),
                                                          const SizedBox(
                                                            width: 10.0,
                                                          ),
                                                          searchController.classList[i].city!.isNotEmpty
                                                              ? Text("${searchController.classList[i].city}",
                                                                  style: TextStyle().copyWith(
                                                                    color: Theme.of(context).textTheme.bodyText1!.color,
                                                                    fontSize: 10,
                                                                    fontWeight: FontWeight.w400,
                                                                    overflow: TextOverflow.clip,
                                                                  ))
                                                              : Text("N/A",
                                                                  style: TextStyle().copyWith(
                                                                    color: Theme.of(context).textTheme.bodyText1!.color,
                                                                    fontSize: 10,
                                                                    fontWeight: FontWeight.w400,
                                                                    overflow: TextOverflow.clip,
                                                                  )),
                                                          const SizedBox(
                                                            width: 20,
                                                          ),
                                                          const Icon(Icons.star, size: 12),
                                                          const SizedBox(
                                                            width: 10.0,
                                                          ),
                                                          searchController.classList[i].rating.toString().isNotEmpty
                                                              ? Text(
                                                                  searchController.classList[i].rating.toString() != Null
                                                                      ? "${searchController.classList[i].rating.toString()}"
                                                                      : "Na",
                                                                  style: TextStyle().copyWith(
                                                                    color: Theme.of(context).textTheme.bodyText1!.color,
                                                                    fontSize: 14,
                                                                    fontWeight: FontWeight.w400,
                                                                    overflow: TextOverflow.clip,
                                                                  ))
                                                              : Text("N/A",
                                                                  style: TextStyle().copyWith(
                                                                    color: Theme.of(context).textTheme.bodyText1!.color,
                                                                    fontSize: 10,
                                                                    fontWeight: FontWeight.w400,
                                                                    overflow: TextOverflow.clip,
                                                                  )),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          const Icon(Icons.supervisor_account_sharp, size: 12),
                                                          const SizedBox(
                                                            width: 10.0,
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                                searchController.classList[i].total_student.toString() != 0
                                                                    ? "${searchController.classList[i].total_student.toString()} Students"
                                                                    : "Na",
                                                                style: TextStyle().copyWith(
                                                                  color: Theme.of(context).textTheme.bodyText1!.color,
                                                                  fontSize: 10,
                                                                  fontWeight: FontWeight.w400,
                                                                  overflow: TextOverflow.clip,
                                                                )),
                                                          )
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          const Icon(Icons.query_stats, size: 12),
                                                          const SizedBox(
                                                            width: 10.0,
                                                          ),
                                                          Text(
                                                              searchController.classList[i].languageLevel.toString() != Null
                                                                  ? level(searchController.classList[i].languageLevel.toString())
                                                                  : "Na",
                                                              style: TextStyle().copyWith(
                                                                color: Theme.of(context).textTheme.bodyText1!.color,
                                                                fontSize: 10,
                                                                fontWeight: FontWeight.w400,
                                                                overflow: TextOverflow.clip,
                                                              ))
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          const Icon(Icons.account_balance, size: 12),
                                                          const SizedBox(
                                                            width: 10.0,
                                                          ),
                                                          Text(
                                                              searchController.classList[i].schoolName != ""
                                                                  ? "${searchController.classList[i].schoolName}"
                                                                  : "Not disclosed",
                                                              style: TextStyle().copyWith(
                                                                color: Theme.of(context).textTheme.bodyText1!.color,
                                                                fontSize: 10,
                                                                fontWeight: FontWeight.w400,
                                                                overflow: TextOverflow.clip,
                                                              ))
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 10.0,
                                                      ),
                                                      Row(
                                                        children: [
                                                          const Spacer(),
                                                          fetchFlag(url, i),
                                                          const SizedBox(
                                                            width: 5.0,
                                                          ),
                                                          const Icon(Icons.arrow_right_alt_outlined, size: 17),
                                                          const SizedBox(
                                                            width: 5.0,
                                                          ),
                                                          Avatar(
                                                            mxContent: Uri.parse(url + "${searchController.classList[i].flags![0].languageFlag}"),
                                                            name: "publicRoomsResponse.chunk[i].name",
                                                            size: 15,
                                                          ),
                                                          const Spacer(),
                                                          Text("free",
                                                              style: TextStyle().copyWith(
                                                                color: Theme.of(context).textTheme.bodyText1!.color,
                                                                fontSize: 10,
                                                                fontWeight: FontWeight.w400,
                                                                overflow: TextOverflow.clip,
                                                              ))
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ):CircularProgressIndicator()
                                    : const Center(
                                        child: CupertinoActivityIndicator(),
                                      )),
                              ],
                            );
                          }),
                    ],
                  )),
            ListView.builder(
              keyboardDismissBehavior: PlatformInfos.isIOS ? ScrollViewKeyboardDismissBehavior.onDrag : ScrollViewKeyboardDismissBehavior.manual,
              itemCount: rooms.length,
              itemBuilder: (_, i) => ChatListItem(rooms[i]),
            ),
            widget.controller.foundProfiles.isNotEmpty
                ? ListView.builder(
                    keyboardDismissBehavior:
                        PlatformInfos.isIOS ? ScrollViewKeyboardDismissBehavior.onDrag : ScrollViewKeyboardDismissBehavior.manual,
                    itemCount: widget.controller.foundProfiles.length,
                    itemBuilder: (BuildContext context, int i) {
                      final foundProfile = widget.controller.foundProfiles[i];
                      return ListTile(
                        onTap: () async {
                          final roomID = await showFutureLoadingDialog(
                            context: context,
                            future: () async {
                              final client = Matrix.of(context).client;
                              final roomId = await client.startDirectChat(foundProfile.userId, enableEncryption: false);

                              return roomId;
                            },
                          );
                          if (roomID.error == null) {
                            VRouter.of(context).toSegments(['rooms', roomID.result!]);
                          }
                        },
                        leading: Avatar(
                          mxContent: foundProfile.avatarUrl,
                          name: foundProfile.displayName ?? foundProfile.userId,
                          //size: 24,
                        ),
                        title: Text(
                          foundProfile.displayName ?? foundProfile.userId.localpart!,
                          style: const TextStyle(),
                          maxLines: 1,
                        ),
                        subtitle: Text(
                          foundProfile.userId,
                          maxLines: 1,
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      );
                    },
                  )
                : ContactsList(searchController: widget.controller.controller),
          ],
        ),
      ),
    );
  }

  String level(text) {
    RxString value = "".obs;
    if (text == "1") {
      value.value = "A1";
    } else if (text == "2") {
      value.value = "A2";
    } else if (text == "3") {
      value.value = "B1";
    } else if (text == "4") {
      value.value = "B2";
    } else if (text == "5") {
      value.value = "C1";
    } else if (text == "6") {
      value.value = "C2";
    }
    return value.value.toString();
  }
}
