import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pangeachat/config/app_config.dart';
import 'package:pangeachat/pages/language_selection_screen/language_selection.dart';

class LanguageSelectionView extends StatelessWidget {
  final LanguageSelectionController controller;

  const LanguageSelectionView(
    this.controller, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(
              'assets/newAssets/home_wallpaper.png',
            ),
          ),
        ),
        alignment: Alignment.center,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Column(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 60.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 100),
                          child:
                              Image.asset("assets/newAssets/pangea-bare.png")),
                      const SizedBox(
                        width: 18.0,
                      ),
                    ],
                  ),
                ),
              ),
              const Text(
                "Pangea Chat",
                style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.w400),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                    color: Colors.white),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    const Center(
                      child: Text(
                        "I am a (n)",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 40),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3.0),
                          border: Border.all(color: Colors.grey.shade200)),
                      child: DropdownButton(
                        underline: const SizedBox(),
                        alignment: Alignment.center,
                        icon: const Icon(Icons.arrow_drop_down_outlined,
                            color: Colors.black, size: 20),
                        hint: Obx(
                            () => controller.getxController.role.value.isEmpty
                                ? const Center(
                                    child: Text(
                                      "Select One",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15.0,
                                          color: Colors.black),
                                    ),
                                  )
                                : Center(
                                    child: Text(
                                      controller.getxController.role.value,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15.0,
                                          color: Colors.black),
                                    ),
                                  )),
                        isExpanded: true,
                        items: ["Student", "Teacher", "Indie Learner"].map(
                          (val) {
                            return DropdownMenuItem<String>(
                              value: val,
                              child: Center(
                                child: Text(val,
                                    style: const TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w400)),
                              ),
                            );
                          },
                        ).toList(),
                        onChanged: (String? value) {
                          controller.getxController.role.value = value!;
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "What is your base language",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500),
                        ),
                        Obx(() =>
                            Tooltip(
                              message:   controller.getxController.role.value =="Teacher"?"Base language is the language through which you wish to teach.":"Base language is the language through which you wish to learn.",
                              child: const Text("?",  style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500),),
                            ))

                      ],
                    ),

                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 40),
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3.0),
                          border: Border.all(color: Colors.grey.shade200)),
                      child: Obx(() => DropdownButton(
                            underline: const SizedBox(),
                            icon: const Icon(Icons.arrow_drop_down_outlined,
                                color: Colors.black, size: 20),
                            hint: controller
                                    .getxController.selectedLanguageOne.value
                                    .toString()
                                    .isEmpty
                                ? const Center(
                                    child: Text(
                                      "Select Language",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15.0,
                                          color: Colors.black),
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Image.network(
                                          controller.getxController.selectedFlag
                                              .value,
                                          fit: BoxFit.cover,
                                          width: 40,
                                          height: 50,
                                        ),
                                        const SizedBox(
                                          width: 15.0,
                                        ),
                                        Text(
                                          controller.getxController
                                              .selectedLanguageOne.value
                                              .toString()
                                              .toLowerCase()
                                              .capitalizeFirst!,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 15.0,
                                              color: Colors.black),
                                        )
                                      ],
                                    ),
                                  ),
                            isExpanded: true,
                            items: controller.getxController.countriesList1.map(
                              (val) {
                                return DropdownMenuItem(
                                  enabled:
                                      !controller.getxController.loading.value,
                                  alignment: Alignment.center,
                                  value: "${val.languageName}",
                                  onTap: () {
                                    controller.getxController.selectedFlag
                                        .value = val.languageFlag!;
                                    log(controller
                                        .getxController.selectedFlag.value
                                        .toString());
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          ClipRRect(
                                            child: Image.network(
                                              "${val.languageFlag}",
                                              fit: BoxFit.cover,
                                              height: 35,
                                              width: 55,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "${val.languageName.toString().toLowerCase().capitalizeFirst}",
                                          )
                                        ]),
                                  ),
                                );
                              },
                            ).toList(),
                            onChanged: (String? value) {
                              controller.getxController.selectedLanguageOne
                                  .value = value!;
                            },
                          )),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Obx(() =>
                          controller.getxController.role.value == "Teacher"
                              ? const Text(
                                  "What language are you interested in teaching?",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500),
                                )
                              : const Text(
                                  "What language are you interested in learning?",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500),
                                )),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 40),
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3.0),
                          border: Border.all(color: Colors.grey.shade200)),
                      child: Obx(() => DropdownButton(
                            underline: const SizedBox(),
                            icon: const Icon(Icons.arrow_drop_down_outlined,
                                color: Colors.black, size: 20),
                            hint: controller
                                    .getxController.selectedLanguageTwo.value
                                    .toString()
                                    .isEmpty
                                ? const Center(
                                    child: Text(
                                      "Select Language",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15.0,
                                          color: Colors.black),
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Image.network(
                                          controller.getxController
                                              .selectedFlagTwo.value,
                                          fit: BoxFit.cover,
                                          width: 40,
                                          height: 50,
                                        ),
                                        const SizedBox(
                                          width: 15.0,
                                        ),
                                        Text(
                                          controller.getxController
                                              .selectedLanguageTwo.value
                                              .toString()
                                              .toLowerCase()
                                              .capitalizeFirst!,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 15.0,
                                              color: Colors.black),
                                        )
                                      ],
                                    ),
                                  ),
                            isExpanded: true,
                            items: controller.getxController.countriesList2.map(
                              (val) {
                                return DropdownMenuItem(
                                  enabled:
                                      !controller.getxController.loading.value,
                                  alignment: Alignment.center,
                                  value: "${val.languageName}",
                                  onTap: () {
                                    controller.getxController.selectedFlagTwo
                                        .value = val.languageFlag!;
                                  },
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        ClipRRect(
                                          child: Image.network(
                                            "${val.languageFlag}",
                                            fit: BoxFit.cover,
                                            height: 35,
                                            width: 55,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        const SizedBox(
                                          width: 12,
                                        ),
                                        Text(
                                            "${val.languageName.toString().toLowerCase().capitalizeFirst}")
                                      ]),
                                );
                              },
                            ).toList(),
                            onChanged: (String? value) {
                              controller.getxController.selectedLanguageTwo
                                  .value = value!;
                            },
                          )),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: Get.width,
                      height: 45,
                      margin: const EdgeInsets.fromLTRB(40, 30, 40, 40),
                      child: MaterialButton(
                        elevation: 5.0,
                        color: AppConfig.primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0)),
                        onPressed: () {
                          controller.createUser();
                        },
                        child: controller.loading
                            ? const LinearProgressIndicator()
                            : const Text(
                                "Go!",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16.0),
                              ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
