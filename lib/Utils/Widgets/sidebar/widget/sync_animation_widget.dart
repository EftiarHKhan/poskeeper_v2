import 'package:flutter/animation.dart';
import 'package:get/get.dart';

class SyncController extends GetxController with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  var isAnimating = false.obs;

  @override
  void onInit() {
    super.onInit();

    animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 2000));
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    animationController.dispose();
  }

  void startRotation() {
    if(animationController.isAnimating){
      isAnimating.value = false;
      animationController.stop();
    }else{
      isAnimating.value = true;
      animationController.forward();
      //animationController.repeat();

    }
  }
}
