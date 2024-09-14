import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';

class UnityAvatarView extends StatefulWidget {
  const UnityAvatarView({super.key});

  @override
  State<UnityAvatarView> createState() => UnityAvatarViewState();
}


class UnityAvatarViewState extends State<UnityAvatarView> {
  UnityWidgetController? _unityWidgetController;

  void onUnityCreated(controller) {
    _unityWidgetController = controller;
  }

  @override
  Widget build(context) {
    return SafeArea(
      bottom: false,
      child: Stack(
        alignment: AlignmentDirectional.bottomEnd,
        children: [
          Container(
            color: Colors.yellow,
            child: UnityWidget(
              onUnityCreated: onUnityCreated,
            )
          ),
          Center(
            heightFactor: 1,
            child: ElevatedButton(
              onPressed: () {
                _unityWidgetController?.postMessage("Avatar", "NextTexture", "");
              },
              child: const Text("Swap texture"),
            ),
          ),
        ]
      ),
          

    );
  }
}

