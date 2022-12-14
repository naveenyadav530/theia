import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'controller/choreo_controller.dart';
import 'widgets/it_dropdown/it_dropdown.dart';

class ItSrcSendButton extends StatelessWidget {
  final ChoreoController controller;
  const ItSrcSendButton({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _country(context, controller);
  }

  Widget _completeButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 15,
            offset: Offset(0, 4), // changes position of shadow
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              //margin: EdgeInsets.all(2),
              padding: EdgeInsets.zero,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
              ),
              child: TextButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 7)),
                  backgroundColor: MaterialStateProperty.all(
                    Colors.white,
                  ),
                  textStyle: MaterialStateProperty.all(
                    Theme.of(context).textTheme.bodyMedium,
                  ),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  )),
                ),
                onPressed: controller.step2!.isLoading
                    ? null
                    : () {
                        controller.srcButtonAction();
                      },
                child: Text(controller.srcButtonTxt.toString()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 1, bottom: 1),
              child: Container(
                width: 2,
                color: Color.fromARGB(157, 124, 124, 124),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            _country(context, controller),
            const SizedBox(
              width: 5,
            )
          ],
        ),
      ),
    );
  }

  Widget _country(BuildContext context, ChoreoController controller) {
    const double flagSize = 30;
    return InkWell(
      onTap: () {
        // showDialog(
        //   context: context,
        //   builder: (context) => ItDropDown(
        //       title: 'Source language',
        //       onPress: (lang) {
        //         controller.lang!.changeSrcLang(lang);
        //       },
        //       selectedLang: controller.lang!.srcLang!,
        //       languages: controller.lang!.langList),
        //   useRootNavigator: false,
        // );
      },
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 15,
                offset: Offset(0, 4), // changes position of shadow
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: SizedBox(
              height: flagSize,
              width: flagSize,
              child: controller.step1!.isLoading
                  ? CircularProgressIndicator()
                  : controller.lang!.feedBackLang == null
                      ? SizedBox.shrink()
                      : CachedNetworkImage(
                          imageUrl: controller.lang!.feedBackLang!.flagWithPath,
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) =>
                                  CircularProgressIndicator(
                                      value: downloadProgress.progress),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
            ),
          ),
        ),
      ),
    );
  }
}


    //  Image.asset(controller.lang!.srcLang!.flagWithPath,
    //                       package: 'pangea_choreographer', fit: BoxFit.contain),