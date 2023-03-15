import 'dart:async';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

void main() {
  print('run');
  runApp(GameWidget(game: MyGame()));
}

class MyGame extends FlameGame with HasTappables {
  SpriteComponent girl = SpriteComponent();
  SpriteComponent background = SpriteComponent();
  DialogButton dialogButton = DialogButton();

  final Vector2 buttonSize = Vector2(50.0, 50.0);

  final double characterSize = 200.0;

  @override
  FutureOr<void> onLoad() async {
    final screenWidth = size[0];
    final screenHeight = size[1];
    const textBoxHeight = 100;

    add(background
      ..sprite = await loadSprite('background.png')
      ..size = Vector2(size[0], size[1] - 100));

    girl
      ..sprite = await loadSprite('girl.png')
      ..size = await Vector2(characterSize, characterSize)
      ..y = screenHeight - characterSize;
    //..anchor = Anchor.topRight;

    add(girl);

    dialogButton
      ..sprite = await loadSprite('next_button.png')
      ..size = buttonSize
      ..position =
          Vector2(size[0] - buttonSize[0] - 10, size[1] - buttonSize[1] - 10);
  }

  var turned = false;

  @override
  void onTapUp(int pointerId, TapUpInfo info) {
    super.onTapUp(pointerId, info);
    FlameAudio.bgm.play('music.ogg');
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (girl.x < size[0] / 2) {
      girl.x += dt * 30;
      turned = false;
    } else if (turned == false) {
      girl.flipHorizontally();
      turned = true;
      dialogButton.DialogButtonAdd(girl);
      add(dialogButton);
    }
  }
}

class DialogButton extends SpriteComponent with Tappable {
  int scene2Level = 0;
  late SpriteComponent girl;

  DialogButtonAdd(girl) {
    this.girl = girl;
  }

  @override
  bool onTapDown(TapDownInfo event) {
    try {
      print('we will move to the next screen');
      girl.x -= 50;

      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }
}
