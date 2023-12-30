import 'package:flutter/animation.dart';
import 'package:get/get.dart';

class SyncController extends GetxController with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;
  RxDouble a = 0.0.obs;

  startRotation(){
    a.value += 2 / 4;
  }
}
