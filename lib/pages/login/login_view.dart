import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pangeachat/config/app_config.dart';
import 'package:pangeachat/config/themes.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../widgets/matrix.dart';
import 'login.dart';

class LoginView extends StatelessWidget {
  final LoginController controller;

  const LoginView(this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final avatar = Matrix.of(context).loginAvatar;
    return Scaffold(
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.7),
            image: const DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                'assets/newAssets/home_wallpaper.png',
              ),
            ),
          ),
          alignment: Alignment.center,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only( top: 60),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ///out of Container
                          ConstrainedBox(
                            constraints: BoxConstraints(maxHeight: 100),
                            child: SvgPicture.asset(
                              "assets/newAssets/pangea-bare.svg",
                            ),
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children: [
                        Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 550),
                            child: ClipRect(
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade100.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(15.0),
                                      border: Border.all(
                                          width: 1, color: Colors.white)),
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 10.0),
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Center(
                                          child: Stack(
                                            children: [
                                              Material(
                                                borderRadius:  BorderRadius.circular(54),
                                                elevation: 10,
                                                color: Colors.transparent,
                                                clipBehavior: Clip.hardEdge,
                                                child: CircleAvatar(
                                                  radius: 44,
                                                  backgroundColor:
                                                  Colors.white.withAlpha(200),
                                                  child: avatar == null
                                                      ? const Icon(
                                                    Icons.person_outlined,
                                                    color: Colors.black,
                                                    size: 34,
                                                  )
                                                      : FutureBuilder<Uint8List>(
                                                    future: avatar
                                                        .readAsBytes(),
                                                    builder: (context,
                                                        snapshot) {
                                                      final bytes =
                                                          snapshot.data;
                                                      if (bytes == null) {
                                                        return const CircularProgressIndicator
                                                            .adaptive();
                                                      }
                                                      return Image.memory(
                                                        bytes,
                                                        fit: BoxFit.cover,
                                                        width: 118,
                                                        height: 118,
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                              // Positioned(
                                              //   bottom: 0,
                                              //   right: 0,
                                              //   child: FloatingActionButton(
                                              //     mini: true,
                                              //     onPressed:  controller.pickAvatar,
                                              //     backgroundColor: Colors.white,
                                              //     foregroundColor: Colors.black,
                                              //     child: const Icon(
                                              //         Icons.camera_alt_outlined),
                                              //   ),
                                              // ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10,),
                                      ConstrainedBox(
                                        constraints:
                                            const BoxConstraints(maxWidth: 400),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                          child: TextFormField(
                                            readOnly: controller.loading,
                                            autocorrect: false,
                                            autofocus: true,
                                            onChanged: controller
                                                .checkWellKnownWithCoolDown,
                                            controller:
                                            controller.usernameController,
                                            textInputAction:
                                            TextInputAction.next,
                                            keyboardType:
                                            TextInputType.emailAddress,
                                            style: FluffyThemes
                                                .loginTextFieldStyle,
                                            autofillHints: controller.loading
                                                ? null
                                                : [AutofillHints.username],
                                            decoration: InputDecoration(
                                              contentPadding:
                                              EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      25.0),
                                                  borderSide:
                                                  const BorderSide(
                                                      color:
                                                      Colors.white)),
                                              enabledBorder:
                                              OutlineInputBorder(
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(25.0),
                                                  borderSide:
                                                  const BorderSide(
                                                      color: Colors
                                                          .white)),
                                              focusedBorder:
                                              OutlineInputBorder(
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(25.0),
                                                  borderSide:
                                                  const BorderSide(
                                                      color: Colors
                                                          .white)),
                                              fillColor:
                                              const Color(0xFFDADDE2),
                                              filled: true,
                                              prefixIcon: const Icon(
                                                Icons.person,
                                                color: Colors.black,
                                              ),
                                              errorText:
                                              controller.usernameError,
                                              hintText: "Username",
                                              hintStyle: const TextStyle(
                                                color: Color(0x35204880),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      ConstrainedBox(
                                        constraints:
                                            const BoxConstraints(maxWidth: 400),
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child:TextField(
                                            readOnly: controller.loading,
                                            autocorrect: false,
                                            autofillHints: controller.loading
                                                ? null
                                                : [AutofillHints.password],
                                            controller:
                                            controller.passwordController,
                                            textInputAction:
                                            TextInputAction.next,
                                            obscureText:
                                            !controller.showPassword,
                                            onSubmitted: controller.login,
                                            style: FluffyThemes
                                                .loginTextFieldStyle,
                                            decoration: InputDecoration(
                                              contentPadding:
                                              EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      25.0),
                                                  borderSide:
                                                  const BorderSide(
                                                      color:
                                                      Colors.white)),
                                              enabledBorder:
                                              OutlineInputBorder(
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(25.0),
                                                  borderSide:
                                                  const BorderSide(
                                                      color: Colors
                                                          .white)),
                                              focusedBorder:
                                              OutlineInputBorder(
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(25.0),
                                                  borderSide:
                                                  const BorderSide(
                                                      color: Colors
                                                          .white)),
                                              fillColor:
                                              const Color(0xFFDADDE2),
                                              filled: true,
                                              prefixIcon: const Icon(
                                                Icons.lock,
                                                color: Colors.black,
                                              ),
                                              errorText:
                                              controller.passwordError,
                                              suffixIcon: IconButton(
                                                tooltip: L10n.of(context)!
                                                    .showPassword,
                                                icon: Icon(
                                                  controller.showPassword
                                                      ? Icons
                                                      .visibility_off_outlined
                                                      : Icons
                                                      .visibility_outlined,
                                                  color: Colors.black,
                                                ),
                                                onPressed: controller
                                                    .toggleShowPassword,
                                              ),
                                              hintText:
                                              L10n.of(context)!.password,
                                              hintStyle: const TextStyle(
                                                  color: Color(0x35204880)),
                                            ),
                                          ),
                                        ),
                                      ),
                                      ConstrainedBox(
                                        constraints:
                                            const BoxConstraints(maxWidth: 400),
                                        child: Hero(
                                          tag: 'signinButton',
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 16),
                                            child: ElevatedButton(
                                              onPressed: controller.loading
                                                  ? null
                                                  : () =>//controller.handleSignIn(),
                                                  controller.login(context),
                                              style: ElevatedButton.styleFrom(
                                                primary:
                                                    const Color(0xFF352048),
                                                onPrimary: Colors.white,
                                                shadowColor: Colors.white,
                                              ),
                                              child: controller.loading
                                                  ? const LinearProgressIndicator()
                                                  : Text(
                                                      L10n.of(context)!.login),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Text(
                                            "Don't have an account ?",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          const SizedBox(
                                            width: 10.0,
                                          ),
                                          InkWell(
                                            onTap: () => Navigator.pop(context),
                                            child: const Text(
                                              "Sign Up",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),

                                        ],
                                      ),

                                      Row(
                                        children: [
                                          const Expanded(
                                              child:
                                                  Divider(color: Colors.white)),
                                          Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Text(
                                              L10n.of(context)!.or,
                                              style: const TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                          const Expanded(
                                              child:
                                                  Divider(color: Colors.white)),
                                        ],
                                      ),
                                      ConstrainedBox(
                                        constraints:
                                            const BoxConstraints(maxWidth: 400),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 16),
                                          child: ElevatedButton(
                                            onPressed: controller.loading
                                                ? () {}
                                                : controller.passwordForgotten,
                                            style: ElevatedButton.styleFrom(
                                              primary: const Color(0xFF352048),
                                              onPrimary: Colors.white,
                                              shadowColor: Colors.white,
                                            ),
                                            child: Text(L10n.of(context)!
                                                .passwordForgotten),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10.0,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: InkWell(
                            onTap: () =>
                                launch(AppConfig.privacyUrl),
                            child: Text(
                              L10n.of(context)!.privacy,
                              style: const TextStyle(
                                decoration:
                                TextDecoration.underline,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
