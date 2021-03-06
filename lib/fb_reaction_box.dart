import 'dart:async';
import 'dart:io';

import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class FbReactionBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(
            'FB REACTION',
            style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: new FbReaction());
  }
}

class FbReaction extends StatefulWidget {
  @override
  createState() => new FbReactionState();
}

class FbReactionState extends State<FbReaction> with TickerProviderStateMixin {
  AudioPlayer audioPlayer;

  int durationAnimationBox = 500;
  int durationAnimationBtnLongPress = 150;
  int durationAnimationBtnShortPress = 500;
  int durationAnimationIconWhenDrag = 150;
  int durationAnimationIconWhenRelease = 1000;

  // For long press btn
  AnimationController animControlBtnLongPress, animControlBox;
  Animation zoomIconLikeInBtn, tiltIconLikeInBtn, zoomTextLikeInBtn;
  Animation fadeInBox;
  Animation moveRightGroupIcon;
  Animation pushIconLikeUp, pushIconLoveUp, pushIconHahaUp, pushIconWowUp, pushIconSadUp, pushIconAngryUp;
  Animation zoomIconLike, zoomIconLove, zoomIconHaha, zoomIconWow, zoomIconSad, zoomIconAngry;

  // For short press btn
  AnimationController animControlBtnShortPress;
  Animation zoomIconLikeInBtn2, tiltIconLikeInBtn2;

  // For zoom icon when drag
  AnimationController animControlIconWhenDrag;
  AnimationController animControlIconWhenDragInside;
  AnimationController animControlIconWhenDragOutside;
  AnimationController animControlBoxWhenDragOutside;
  Animation zoomIconChosen, zoomIconNotChosen;
  Animation zoomIconWhenDragOutside;
  Animation zoomIconWhenDragInside;
  Animation zoomBoxWhenDragOutside;
  Animation zoomBoxIcon;

  // For jump icon when release
  AnimationController animControlIconWhenRelease;
  Animation zoomIconWhenRelease, moveUpIconWhenRelease;
  Animation moveLeftIconLikeWhenRelease,
      moveLeftIconLoveWhenRelease,
      moveLeftIconHahaWhenRelease,
      moveLeftIconWowWhenRelease,
      moveLeftIconSadWhenRelease,
      moveLeftIconAngryWhenRelease;

  Duration durationLongPress = new Duration(milliseconds: 250);
  Timer holdTimer;
  bool isLongPress = false;
  bool isLiked = false;

  // 0 = nothing, 1 = like, 2 = love, 3 = haha, 4 = wow, 5 = sad, 6 = angry
  int whichIconUserChoose = 0;

  // 0 = nothing, 1 = like, 2 = love, 3 = haha, 4 = wow, 5 = sad, 6 = angry
  int currentIconFocus = 0;
  int previousIconFocus = 0;
  bool isDragging = false;
  bool isDraggingOutside = false;
  bool isJustDragInside = true;

  @override
  void initState() {
    super.initState();

    audioPlayer = new AudioPlayer();

    // Button Like
    initAnimationBtnLike();

    // Box and Icons
    initAnimationBoxAndIcons();

    // Icon when drag
    initAnimationIconWhenDrag();

    // Icon when drag outside
    initAnimationIconWhenDragOutside();

    // Box when drag outside
    initAnimationBoxWhenDragOutside();

    // Icon when first drag
    initAnimationIconWhenDragInside();

    // Icon when release
    initAnimationIconWhenRelease();
  }

  initAnimationBtnLike() {
    // long press
    animControlBtnLongPress =
        new AnimationController(vsync: this, duration: new Duration(milliseconds: durationAnimationBtnLongPress));
    zoomIconLikeInBtn = new Tween(begin: 1.0, end: 0.85).animate(animControlBtnLongPress);
    tiltIconLikeInBtn = new Tween(begin: 0.0, end: 0.2).animate(animControlBtnLongPress);
    zoomTextLikeInBtn = new Tween(begin: 1.0, end: 0.85).animate(animControlBtnLongPress);

    zoomIconLikeInBtn.addListener(() {
      setState(() {});
    });
    tiltIconLikeInBtn.addListener(() {
      setState(() {});
    });
    zoomTextLikeInBtn.addListener(() {
      setState(() {});
    });

    // short press
    animControlBtnShortPress =
        new AnimationController(vsync: this, duration: new Duration(milliseconds: durationAnimationBtnShortPress));
    zoomIconLikeInBtn2 = new Tween(begin: 1.0, end: 0.2).animate(animControlBtnShortPress);
    tiltIconLikeInBtn2 = new Tween(begin: 0.0, end: 0.8).animate(animControlBtnShortPress);

    zoomIconLikeInBtn2.addListener(() {
      setState(() {});
    });
    tiltIconLikeInBtn2.addListener(() {
      setState(() {});
    });
  }

  initAnimationBoxAndIcons() {
    animControlBox = new AnimationController(vsync: this, duration: new Duration(milliseconds: durationAnimationBox));

    // General
    moveRightGroupIcon = new Tween(begin: 0.0, end: 10.0).animate(
      new CurvedAnimation(parent: animControlBox, curve: new Interval(0.0, 1.0)),
    );
    moveRightGroupIcon.addListener(() {
      setState(() {});
    });

    // Box
    fadeInBox = new Tween(begin: 0.0, end: 1.0).animate(
      new CurvedAnimation(parent: animControlBox, curve: new Interval(0.7, 1.0)),
    );
    fadeInBox.addListener(() {
      setState(() {});
    });

    // Icons
    pushIconLikeUp = new Tween(begin: 30.0, end: 60.0).animate(
      new CurvedAnimation(parent: animControlBox, curve: new Interval(0.0, 0.5)),
    );
    zoomIconLike = new Tween(begin: 0.0, end: 1.0).animate(
      new CurvedAnimation(parent: animControlBox, curve: new Interval(0.0, 0.5)),
    );

    pushIconLoveUp = new Tween(begin: 30.0, end: 60.0).animate(
      new CurvedAnimation(parent: animControlBox, curve: new Interval(0.1, 0.6)),
    );
    zoomIconLove = new Tween(begin: 0.0, end: 1.0).animate(
      new CurvedAnimation(parent: animControlBox, curve: new Interval(0.1, 0.6)),
    );

    pushIconHahaUp = new Tween(begin: 30.0, end: 60.0).animate(
      new CurvedAnimation(parent: animControlBox, curve: new Interval(0.2, 0.7)),
    );
    zoomIconHaha = new Tween(begin: 0.0, end: 1.0).animate(
      new CurvedAnimation(parent: animControlBox, curve: new Interval(0.2, 0.7)),
    );

    pushIconWowUp = new Tween(begin: 30.0, end: 60.0).animate(
      new CurvedAnimation(parent: animControlBox, curve: new Interval(0.3, 0.8)),
    );
    zoomIconWow = new Tween(begin: 0.0, end: 1.0).animate(
      new CurvedAnimation(parent: animControlBox, curve: new Interval(0.3, 0.8)),
    );

    pushIconSadUp = new Tween(begin: 30.0, end: 60.0).animate(
      new CurvedAnimation(parent: animControlBox, curve: new Interval(0.4, 0.9)),
    );
    zoomIconSad = new Tween(begin: 0.0, end: 1.0).animate(
      new CurvedAnimation(parent: animControlBox, curve: new Interval(0.4, 0.9)),
    );

    pushIconAngryUp = new Tween(begin: 30.0, end: 60.0).animate(
      new CurvedAnimation(parent: animControlBox, curve: new Interval(0.5, 1.0)),
    );
    zoomIconAngry = new Tween(begin: 0.0, end: 1.0).animate(
      new CurvedAnimation(parent: animControlBox, curve: new Interval(0.5, 1.0)),
    );

    pushIconLikeUp.addListener(() {
      setState(() {});
    });
    zoomIconLike.addListener(() {
      setState(() {});
    });
    pushIconLoveUp.addListener(() {
      setState(() {});
    });
    zoomIconLove.addListener(() {
      setState(() {});
    });
    pushIconHahaUp.addListener(() {
      setState(() {});
    });
    zoomIconHaha.addListener(() {
      setState(() {});
    });
    pushIconWowUp.addListener(() {
      setState(() {});
    });
    zoomIconWow.addListener(() {
      setState(() {});
    });
    pushIconSadUp.addListener(() {
      setState(() {});
    });
    zoomIconSad.addListener(() {
      setState(() {});
    });
    pushIconAngryUp.addListener(() {
      setState(() {});
    });
    zoomIconAngry.addListener(() {
      setState(() {});
    });
  }

  initAnimationIconWhenDrag() {
    animControlIconWhenDrag =
        new AnimationController(vsync: this, duration: new Duration(milliseconds: durationAnimationIconWhenDrag));

    zoomIconChosen = new Tween(begin: 1.0, end: 1.8).animate(animControlIconWhenDrag);
    zoomIconNotChosen = new Tween(begin: 1.0, end: 0.8).animate(animControlIconWhenDrag);
    zoomBoxIcon = new Tween(begin: 50.0, end: 40.0).animate(animControlIconWhenDrag);

    zoomIconChosen.addListener(() {
      setState(() {});
    });
    zoomIconNotChosen.addListener(() {
      setState(() {});
    });
    zoomBoxIcon.addListener(() {
      setState(() {});
    });
  }

  initAnimationIconWhenDragOutside() {
    animControlIconWhenDragOutside =
        new AnimationController(vsync: this, duration: new Duration(milliseconds: durationAnimationIconWhenDrag));
    zoomIconWhenDragOutside = new Tween(begin: 0.8, end: 1.0).animate(animControlIconWhenDragOutside);
    zoomIconWhenDragOutside.addListener(() {
      setState(() {});
    });
  }

  initAnimationBoxWhenDragOutside() {
    animControlBoxWhenDragOutside =
        new AnimationController(vsync: this, duration: new Duration(milliseconds: durationAnimationIconWhenDrag));
    zoomBoxWhenDragOutside = new Tween(begin: 40.0, end: 50.0).animate(animControlBoxWhenDragOutside);
    zoomBoxWhenDragOutside.addListener(() {
      setState(() {});
    });
  }

  initAnimationIconWhenDragInside() {
    animControlIconWhenDragInside =
        new AnimationController(vsync: this, duration: new Duration(milliseconds: durationAnimationIconWhenDrag));
    zoomIconWhenDragInside = new Tween(begin: 1.0, end: 0.8).animate(animControlIconWhenDragInside);
    zoomIconWhenDragInside.addListener(() {
      setState(() {});
    });
    animControlIconWhenDragInside.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        isJustDragInside = false;
      }
    });
  }

  initAnimationIconWhenRelease() {
    animControlIconWhenRelease =
        new AnimationController(vsync: this, duration: new Duration(milliseconds: durationAnimationIconWhenRelease));

    zoomIconWhenRelease = new Tween(begin: 1.8, end: 0.0)
        .animate(new CurvedAnimation(parent: animControlIconWhenRelease, curve: Curves.decelerate));

    moveUpIconWhenRelease = new Tween(begin: 180.0, end: 0.0)
        .animate(new CurvedAnimation(parent: animControlIconWhenRelease, curve: Curves.decelerate));

    moveLeftIconLikeWhenRelease = new Tween(begin: 20.0, end: 10.0)
        .animate(new CurvedAnimation(parent: animControlIconWhenRelease, curve: Curves.decelerate));
    moveLeftIconLoveWhenRelease = new Tween(begin: 68.0, end: 10.0)
        .animate(new CurvedAnimation(parent: animControlIconWhenRelease, curve: Curves.decelerate));
    moveLeftIconHahaWhenRelease = new Tween(begin: 116.0, end: 10.0)
        .animate(new CurvedAnimation(parent: animControlIconWhenRelease, curve: Curves.decelerate));
    moveLeftIconWowWhenRelease = new Tween(begin: 164.0, end: 10.0)
        .animate(new CurvedAnimation(parent: animControlIconWhenRelease, curve: Curves.decelerate));
    moveLeftIconSadWhenRelease = new Tween(begin: 212.0, end: 10.0)
        .animate(new CurvedAnimation(parent: animControlIconWhenRelease, curve: Curves.decelerate));
    moveLeftIconAngryWhenRelease = new Tween(begin: 260.0, end: 10.0)
        .animate(new CurvedAnimation(parent: animControlIconWhenRelease, curve: Curves.decelerate));

    zoomIconWhenRelease.addListener(() {
      setState(() {});
    });
    moveUpIconWhenRelease.addListener(() {
      setState(() {});
    });

    moveLeftIconLikeWhenRelease.addListener(() {
      setState(() {});
    });
    moveLeftIconLoveWhenRelease.addListener(() {
      setState(() {});
    });
    moveLeftIconHahaWhenRelease.addListener(() {
      setState(() {});
    });
    moveLeftIconWowWhenRelease.addListener(() {
      setState(() {});
    });
    moveLeftIconSadWhenRelease.addListener(() {
      setState(() {});
    });
    moveLeftIconAngryWhenRelease.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    animControlBtnLongPress.dispose();
    animControlBox.dispose();
    animControlIconWhenDrag.dispose();
    animControlIconWhenDragInside.dispose();
    animControlIconWhenDragOutside.dispose();
    animControlBoxWhenDragOutside.dispose();
    animControlIconWhenRelease.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      child: new Column(
        children: <Widget>[
          // Just a top space
          new Container(
            width: double.infinity,
            height: 100.0,
          ),

          // main content
          new Container(
            child: new Stack(
              children: <Widget>[
                // Box and icons
                new Stack(
                  children: <Widget>[
                    // Box
                    renderBox(),

                    // Icons
                    renderIcons(),
                  ],
                  alignment: Alignment.bottomCenter,
                ),

                // Button like
                renderBtnLike(),

                // Icons when jump
                // Icon like
                whichIconUserChoose == 1 && !isDragging
                    ? new Container(
                        child: Transform.scale(
                          child: new Image.asset(
                            'images/like.gif',
                            width: 40.0,
                            height: 40.0,
                          ),
                          scale: this.zoomIconWhenRelease.value,
                        ),
                        margin: new EdgeInsets.only(
                          top: processTopPosition(this.moveUpIconWhenRelease.value),
                          left: this.moveLeftIconLikeWhenRelease.value,
                        ),
                      )
                    : new Container(),

                // Icon love
                whichIconUserChoose == 2 && !isDragging
                    ? new Container(
                        child: Transform.scale(
                          child: new Image.asset(
                            'images/love.gif',
                            width: 40.0,
                            height: 40.0,
                          ),
                          scale: this.zoomIconWhenRelease.value,
                        ),
                        margin: new EdgeInsets.only(
                          top: processTopPosition(this.moveUpIconWhenRelease.value),
                          left: this.moveLeftIconLoveWhenRelease.value,
                        ),
                      )
                    : new Container(),

                // Icon haha
                whichIconUserChoose == 3 && !isDragging
                    ? new Container(
                        child: Transform.scale(
                          child: new Image.asset(
                            'images/haha.gif',
                            width: 40.0,
                            height: 40.0,
                          ),
                          scale: this.zoomIconWhenRelease.value,
                        ),
                        margin: new EdgeInsets.only(
                          top: processTopPosition(this.moveUpIconWhenRelease.value),
                          left: this.moveLeftIconHahaWhenRelease.value,
                        ),
                      )
                    : new Container(),

                // Icon Wow
                whichIconUserChoose == 4 && !isDragging
                    ? new Container(
                        child: Transform.scale(
                          child: new Image.asset(
                            'images/wow.gif',
                            width: 40.0,
                            height: 40.0,
                          ),
                          scale: this.zoomIconWhenRelease.value,
                        ),
                        margin: new EdgeInsets.only(
                          top: processTopPosition(this.moveUpIconWhenRelease.value),
                          left: this.moveLeftIconWowWhenRelease.value,
                        ),
                      )
                    : new Container(),

                // Icon sad
                whichIconUserChoose == 5 && !isDragging
                    ? new Container(
                        child: Transform.scale(
                          child: new Image.asset(
                            'images/sad.gif',
                            width: 40.0,
                            height: 40.0,
                          ),
                          scale: this.zoomIconWhenRelease.value,
                        ),
                        margin: new EdgeInsets.only(
                          top: processTopPosition(this.moveUpIconWhenRelease.value),
                          left: this.moveLeftIconSadWhenRelease.value,
                        ),
                      )
                    : new Container(),

                // Icon angry
                whichIconUserChoose == 6 && !isDragging
                    ? new Container(
                        child: Transform.scale(
                          child: new Image.asset(
                            'images/angry.gif',
                            width: 40.0,
                            height: 40.0,
                          ),
                          scale: this.zoomIconWhenRelease.value,
                        ),
                        margin: new EdgeInsets.only(
                          top: processTopPosition(this.moveUpIconWhenRelease.value),
                          left: this.moveLeftIconAngryWhenRelease.value,
                        ),
                      )
                    : new Container(),
              ],
            ),
            margin: new EdgeInsets.only(left: 20.0, right: 20.0),
            // Area of the content can drag
            // decoration: new BoxDecoration(border: Border.all(color: Colors.grey)),
            width: double.infinity,
            height: 350.0,
          ),
        ],
      ),
      onHorizontalDragEnd: onHorizontalDragEndBoxIcon,
      onHorizontalDragUpdate: onHorizontalDragUpdateBoxIcon,
    );
  }

  Widget renderBox() {
    return new Opacity(
      child: new Container(
        decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius: new BorderRadius.circular(30.0),
          border: new Border.all(color: Colors.grey[300], width: 0.3),
          boxShadow: [
            new BoxShadow(
                color: Colors.grey,
                blurRadius: 5.0,
                // LTRB
                offset: Offset.lerp(new Offset(0.0, 0.0), new Offset(0.0, 0.5), 10.0)),
          ],
        ),
        width: 300.0,
        height: isDragging
            ? (previousIconFocus == 0 ? this.zoomBoxIcon.value : 40.0)
            : isDraggingOutside ? this.zoomBoxWhenDragOutside.value : 50.0,
        margin: new EdgeInsets.only(bottom: 130.0, left: 10.0),
      ),
      opacity: this.fadeInBox.value,
    );
  }

  Widget renderIcons() {
    return new Container(
      child: new Row(
        children: <Widget>[
          // icon like
          new Transform.scale(
            child: new Container(
              child: new Column(
                children: <Widget>[
                  currentIconFocus == 1
                      ? new Container(
                          child: new Text(
                            'Like',
                            style: new TextStyle(fontSize: 8.0, color: Colors.white),
                          ),
                          decoration: new BoxDecoration(
                              borderRadius: new BorderRadius.circular(10.0), color: Colors.black.withOpacity(0.3)),
                          padding: new EdgeInsets.only(left: 7.0, right: 7.0, top: 2.0, bottom: 2.0),
                          margin: new EdgeInsets.only(bottom: 8.0),
                        )
                      : new Container(),
                  new Image.asset(
                    'images/like.gif',
                    width: 40.0,
                    height: 40.0,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
              margin: new EdgeInsets.only(bottom: pushIconLikeUp.value),
              width: 40.0,
              height: currentIconFocus == 1 ? 70.0 : 40.0,
            ),
            scale: isDragging
                ? (currentIconFocus == 1
                    ? this.zoomIconChosen.value
                    : (previousIconFocus == 1
                        ? this.zoomIconNotChosen.value
                        : isJustDragInside ? this.zoomIconWhenDragInside.value : 0.8))
                : isDraggingOutside ? this.zoomIconWhenDragOutside.value : this.zoomIconLike.value,
          ),

          // icon love
          new Transform.scale(
            child: new Container(
              child: new Column(
                children: <Widget>[
                  currentIconFocus == 2
                      ? new Container(
                          child: new Text(
                            'Love',
                            style: new TextStyle(fontSize: 8.0, color: Colors.white),
                          ),
                          decoration: new BoxDecoration(
                              borderRadius: new BorderRadius.circular(10.0), color: Colors.black.withOpacity(0.3)),
                          padding: new EdgeInsets.only(left: 7.0, right: 7.0, top: 2.0, bottom: 2.0),
                          margin: new EdgeInsets.only(bottom: 8.0),
                        )
                      : new Container(),
                  new Image.asset(
                    'images/love.gif',
                    width: 40.0,
                    height: 40.0,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
              margin: new EdgeInsets.only(bottom: pushIconLoveUp.value),
              width: 40.0,
              height: currentIconFocus == 2 ? 70.0 : 40.0,
            ),
            scale: isDragging
                ? (currentIconFocus == 2
                    ? this.zoomIconChosen.value
                    : (previousIconFocus == 2
                        ? this.zoomIconNotChosen.value
                        : isJustDragInside ? this.zoomIconWhenDragInside.value : 0.8))
                : isDraggingOutside ? this.zoomIconWhenDragOutside.value : this.zoomIconLove.value,
          ),

          // icon haha
          new Transform.scale(
            child: new Container(
              child: new Column(
                children: <Widget>[
                  currentIconFocus == 3
                      ? new Container(
                          child: new Text(
                            'Haha',
                            style: new TextStyle(fontSize: 8.0, color: Colors.white),
                          ),
                          decoration: new BoxDecoration(
                              borderRadius: new BorderRadius.circular(10.0), color: Colors.black.withOpacity(0.3)),
                          padding: new EdgeInsets.only(left: 7.0, right: 7.0, top: 2.0, bottom: 2.0),
                          margin: new EdgeInsets.only(bottom: 8.0),
                        )
                      : new Container(),
                  new Image.asset(
                    'images/haha.gif',
                    width: 40.0,
                    height: 40.0,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
              margin: new EdgeInsets.only(bottom: pushIconHahaUp.value),
              width: 40.0,
              height: currentIconFocus == 3 ? 70.0 : 40.0,
            ),
            scale: isDragging
                ? (currentIconFocus == 3
                    ? this.zoomIconChosen.value
                    : (previousIconFocus == 3
                        ? this.zoomIconNotChosen.value
                        : isJustDragInside ? this.zoomIconWhenDragInside.value : 0.8))
                : isDraggingOutside ? this.zoomIconWhenDragOutside.value : this.zoomIconHaha.value,
          ),

          // icon wow
          new Transform.scale(
            child: new Container(
              child: new Column(
                children: <Widget>[
                  currentIconFocus == 4
                      ? new Container(
                          child: new Text(
                            'Wow',
                            style: new TextStyle(fontSize: 8.0, color: Colors.white),
                          ),
                          decoration: new BoxDecoration(
                              borderRadius: new BorderRadius.circular(10.0), color: Colors.black.withOpacity(0.3)),
                          padding: new EdgeInsets.only(left: 7.0, right: 7.0, top: 2.0, bottom: 2.0),
                          margin: new EdgeInsets.only(bottom: 8.0),
                        )
                      : new Container(),
                  new Image.asset(
                    'images/wow.gif',
                    width: 40.0,
                    height: 40.0,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
              margin: new EdgeInsets.only(bottom: pushIconWowUp.value),
              width: 40.0,
              height: currentIconFocus == 4 ? 70.0 : 40.0,
            ),
            scale: isDragging
                ? (currentIconFocus == 4
                    ? this.zoomIconChosen.value
                    : (previousIconFocus == 4
                        ? this.zoomIconNotChosen.value
                        : isJustDragInside ? this.zoomIconWhenDragInside.value : 0.8))
                : isDraggingOutside ? this.zoomIconWhenDragOutside.value : this.zoomIconWow.value,
          ),

          // icon sad
          new Transform.scale(
            child: new Container(
              child: new Column(
                children: <Widget>[
                  currentIconFocus == 5
                      ? new Container(
                          child: new Text(
                            'Sad',
                            style: new TextStyle(fontSize: 8.0, color: Colors.white),
                          ),
                          decoration: new BoxDecoration(
                              borderRadius: new BorderRadius.circular(10.0), color: Colors.black.withOpacity(0.3)),
                          padding: new EdgeInsets.only(left: 7.0, right: 7.0, top: 2.0, bottom: 2.0),
                          margin: new EdgeInsets.only(bottom: 8.0),
                        )
                      : new Container(),
                  new Image.asset(
                    'images/sad.gif',
                    width: 40.0,
                    height: 40.0,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
              margin: new EdgeInsets.only(bottom: pushIconSadUp.value),
              width: 40.0,
              height: currentIconFocus == 5 ? 70.0 : 40.0,
            ),
            scale: isDragging
                ? (currentIconFocus == 5
                    ? this.zoomIconChosen.value
                    : (previousIconFocus == 5
                        ? this.zoomIconNotChosen.value
                        : isJustDragInside ? this.zoomIconWhenDragInside.value : 0.8))
                : isDraggingOutside ? this.zoomIconWhenDragOutside.value : this.zoomIconSad.value,
          ),

          // icon angry
          new Transform.scale(
            child: new Container(
              child: new Column(
                children: <Widget>[
                  currentIconFocus == 6
                      ? new Container(
                          child: new Text(
                            'Angry',
                            style: new TextStyle(fontSize: 8.0, color: Colors.white),
                          ),
                          decoration: new BoxDecoration(
                              borderRadius: new BorderRadius.circular(10.0), color: Colors.black.withOpacity(0.3)),
                          padding: new EdgeInsets.only(left: 7.0, right: 7.0, top: 2.0, bottom: 2.0),
                          margin: new EdgeInsets.only(bottom: 8.0),
                        )
                      : new Container(),
                  new Image.asset(
                    'images/angry.gif',
                    width: 40.0,
                    height: 40.0,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
              margin: new EdgeInsets.only(bottom: pushIconAngryUp.value),
              width: 40.0,
              height: currentIconFocus == 6 ? 70.0 : 40.0,
            ),
            scale: isDragging
                ? (currentIconFocus == 6
                    ? this.zoomIconChosen.value
                    : (previousIconFocus == 6
                        ? this.zoomIconNotChosen.value
                        : isJustDragInside ? this.zoomIconWhenDragInside.value : 0.8))
                : isDraggingOutside ? this.zoomIconWhenDragOutside.value : this.zoomIconAngry.value,
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
      ),
      width: 300.0,
      height: 250.0,
      margin: new EdgeInsets.only(left: this.moveRightGroupIcon.value, top: 50.0),
      // uncomment here to see area of draggable
      // color: Colors.amber.withOpacity(0.5),
    );
  }

  Widget renderBtnLike() {
    return new Container(
      child: new GestureDetector(
        onTapDown: onTapDownBtn,
        onTapUp: onTapUpBtn,
        onTap: onTapBtn,
        child: new Container(
          child: new Row(
            children: <Widget>[
              // Icon like
              new Transform.scale(
                child: new Transform.rotate(
                  child: new Image.asset(
                    getImageIconBtn(),
                    width: 25.0,
                    height: 25.0,
                    fit: BoxFit.contain,
                    color: getTintColorIconBtn(),
                  ),
                  angle:
                      !isLongPress ? handleOutputRangeTiltIconLike(tiltIconLikeInBtn2.value) : tiltIconLikeInBtn.value,
                ),
                scale:
                    !isLongPress ? handleOutputRangeZoomInIconLike(zoomIconLikeInBtn2.value) : zoomIconLikeInBtn.value,
              ),

              // Text like
              new Transform.scale(
                child: new Text(
                  getTextBtn(),
                  style: new TextStyle(
                    color: getColorTextBtn(),
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                scale:
                    !isLongPress ? handleOutputRangeZoomInIconLike(zoomIconLikeInBtn2.value) : zoomTextLikeInBtn.value,
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
          padding: new EdgeInsets.all(10.0),
          color: Colors.transparent,
        ),
      ),
      width: 100.0,
      decoration: new BoxDecoration(
        borderRadius: new BorderRadius.circular(4.0),
        color: Colors.white,
        border: new Border.all(color: getColorBorderBtn()),
      ),
      margin: new EdgeInsets.only(top: 190.0),
    );
  }

  String getTextBtn() {
    if (isDragging) {
      return 'Like';
    }
    switch (whichIconUserChoose) {
      case 1:
        return 'Like';
      case 2:
        return 'Love';
      case 3:
        return 'Haha';
      case 4:
        return 'Wow';
      case 5:
        return 'Sad';
      case 6:
        return 'Angry';
      default:
        return 'Like';
    }
  }

  Color getColorTextBtn() {
    if ((!isLongPress && isLiked)) {
      return Color(0xff3b5998);
    } else if (!isDragging) {
      switch (whichIconUserChoose) {
        case 1:
          return Color(0xff3b5998);
        case 2:
          return Color(0xffED5167);
        case 3:
        case 4:
        case 5:
          return Color(0xffFFD96A);
        case 6:
          return Color(0xffF6876B);
        default:
          return Colors.grey;
      }
    } else {
      return Colors.grey;
    }
  }

  String getImageIconBtn() {
    if (!isLongPress && isLiked) {
      return 'images/ic_like_fill.png';
    } else if (!isDragging) {
      switch (whichIconUserChoose) {
        case 1:
          return 'images/ic_like_fill.png';
        case 2:
          return 'images/love2.png';
        case 3:
          return 'images/haha2.png';
        case 4:
          return 'images/wow2.png';
        case 5:
          return 'images/sad2.png';
        case 6:
          return 'images/angry2.png';
        default:
          return 'images/ic_like.png';
      }
    } else {
      return 'images/ic_like.png';
    }
  }

  Color getTintColorIconBtn() {
    if (!isLongPress && isLiked) {
      return new Color(0xff3b5998);
    } else if (!isDragging && whichIconUserChoose != 0) {
      return null;
    } else {
      return Colors.grey;
    }
  }

  double processTopPosition(double value) {
    // margin top 100 -> 40 -> 160 (value from 180 -> 0)
    if (value >= 120.0) {
      return value - 80.0;
    } else {
      return 160.0 - value;
    }
  }

  Color getColorBorderBtn() {
    if ((!isLongPress && isLiked)) {
      return Color(0xff3b5998);
    } else if (!isDragging) {
      switch (whichIconUserChoose) {
        case 1:
          return Color(0xff3b5998);
        case 2:
          return Color(0xffED5167);
        case 3:
        case 4:
        case 5:
          return Color(0xffFFD96A);
        case 6:
          return Color(0xffF6876B);
        default:
          return Colors.grey;
      }
    } else {
      return Colors.grey[400];
    }
  }

  void onHorizontalDragEndBoxIcon(DragEndDetails dragEndDetail) {
    isDragging = false;
    isDraggingOutside = false;
    isJustDragInside = true;
    previousIconFocus = 0;
    currentIconFocus = 0;

    onTapUpBtn(null);
  }

  void onHorizontalDragUpdateBoxIcon(DragUpdateDetails dragUpdateDetail) {
    // return if the drag is drag without press button
    if (!isLongPress) return;

    // the margin top the box is 150
    // and plus the height of toolbar and the status bar
    // so the range we check is about 200 -> 500

    if (dragUpdateDetail.globalPosition.dy >= 200 && dragUpdateDetail.globalPosition.dy <= 500) {
      isDragging = true;
      isDraggingOutside = false;

      if (isJustDragInside && !animControlIconWhenDragInside.isAnimating) {
        animControlIconWhenDragInside.reset();
        animControlIconWhenDragInside.forward();
      }

      if (dragUpdateDetail.globalPosition.dx >= 20 && dragUpdateDetail.globalPosition.dx < 83) {
        if (currentIconFocus != 1) {
          handleWhenDragBetweenIcon(1);
        }
      } else if (dragUpdateDetail.globalPosition.dx >= 83 && dragUpdateDetail.globalPosition.dx < 126) {
        if (currentIconFocus != 2) {
          handleWhenDragBetweenIcon(2);
        }
      } else if (dragUpdateDetail.globalPosition.dx >= 126 && dragUpdateDetail.globalPosition.dx < 180) {
        if (currentIconFocus != 3) {
          handleWhenDragBetweenIcon(3);
        }
      } else if (dragUpdateDetail.globalPosition.dx >= 180 && dragUpdateDetail.globalPosition.dx < 233) {
        if (currentIconFocus != 4) {
          handleWhenDragBetweenIcon(4);
        }
      } else if (dragUpdateDetail.globalPosition.dx >= 233 && dragUpdateDetail.globalPosition.dx < 286) {
        if (currentIconFocus != 5) {
          handleWhenDragBetweenIcon(5);
        }
      } else if (dragUpdateDetail.globalPosition.dx >= 286 && dragUpdateDetail.globalPosition.dx < 340) {
        if (currentIconFocus != 6) {
          handleWhenDragBetweenIcon(6);
        }
      }
    } else {
      whichIconUserChoose = 0;
      previousIconFocus = 0;
      currentIconFocus = 0;
      isJustDragInside = true;

      if (isDragging && !isDraggingOutside) {
        isDragging = false;
        isDraggingOutside = true;
        animControlIconWhenDragOutside.reset();
        animControlIconWhenDragOutside.forward();
        animControlBoxWhenDragOutside.reset();
        animControlBoxWhenDragOutside.forward();
      }
    }
  }

  void handleWhenDragBetweenIcon(int currentIcon) {
    playSound('icon_focus.mp3');
    whichIconUserChoose = currentIcon;
    previousIconFocus = currentIconFocus;
    currentIconFocus = currentIcon;
    animControlIconWhenDrag.reset();
    animControlIconWhenDrag.forward();
  }

  void onTapDownBtn(TapDownDetails tapDownDetail) {
    holdTimer = new Timer(durationLongPress, showBox);
  }

  void onTapUpBtn(TapUpDetails tapUpDetail) {
    if (isLongPress) {
      if (whichIconUserChoose == 0) {
        playSound('box_down.mp3');
      } else {
        playSound('icon_choose.mp3');
      }
    }

    new Timer(new Duration(milliseconds: durationAnimationBox), () {
      isLongPress = false;
    });

    holdTimer.cancel();

    animControlBtnLongPress.reverse();

    setReverseValue();
    animControlBox.reverse();

    animControlIconWhenRelease.reset();
    animControlIconWhenRelease.forward();
  }

  // when user short press the button
  void onTapBtn() {
    if (!isLongPress) {
      if (whichIconUserChoose == 0) {
        isLiked = !isLiked;
      } else {
        whichIconUserChoose = 0;
      }
      if (isLiked) {
        playSound('short_press_like.mp3');
        animControlBtnShortPress.forward();
      } else {
        animControlBtnShortPress.reverse();
      }
    }
  }

  double handleOutputRangeZoomInIconLike(double value) {
    if (value >= 0.8) {
      return value;
    } else if (value >= 0.4) {
      return 1.6 - value;
    } else {
      return 0.8 + value;
    }
  }

  double handleOutputRangeTiltIconLike(double value) {
    if (value <= 0.2) {
      return value;
    } else if (value <= 0.6) {
      return 0.4 - value;
    } else {
      return -(0.8 - value);
    }
  }

  void showBox() {
    playSound('box_up.mp3');
    isLongPress = true;

    animControlBtnLongPress.forward();

    setForwardValue();
    animControlBox.forward();
  }

  // We need to set the value for reverse because if not
  // the angry-icon will be pulled down first, not the like-icon
  void setReverseValue() {
    // Icons
    pushIconLikeUp = new Tween(begin: 30.0, end: 60.0).animate(
      new CurvedAnimation(parent: animControlBox, curve: new Interval(0.5, 1.0)),
    );
    zoomIconLike = new Tween(begin: 0.0, end: 1.0).animate(
      new CurvedAnimation(parent: animControlBox, curve: new Interval(0.5, 1.0)),
    );

    pushIconLoveUp = new Tween(begin: 30.0, end: 60.0).animate(
      new CurvedAnimation(parent: animControlBox, curve: new Interval(0.4, 0.9)),
    );
    zoomIconLove = new Tween(begin: 0.0, end: 1.0).animate(
      new CurvedAnimation(parent: animControlBox, curve: new Interval(0.4, 0.9)),
    );

    pushIconHahaUp = new Tween(begin: 30.0, end: 60.0).animate(
      new CurvedAnimation(parent: animControlBox, curve: new Interval(0.3, 0.8)),
    );
    zoomIconHaha = new Tween(begin: 0.0, end: 1.0).animate(
      new CurvedAnimation(parent: animControlBox, curve: new Interval(0.3, 0.8)),
    );

    pushIconWowUp = new Tween(begin: 30.0, end: 60.0).animate(
      new CurvedAnimation(parent: animControlBox, curve: new Interval(0.2, 0.7)),
    );
    zoomIconWow = new Tween(begin: 0.0, end: 1.0).animate(
      new CurvedAnimation(parent: animControlBox, curve: new Interval(0.2, 0.7)),
    );

    pushIconSadUp = new Tween(begin: 30.0, end: 60.0).animate(
      new CurvedAnimation(parent: animControlBox, curve: new Interval(0.1, 0.6)),
    );
    zoomIconSad = new Tween(begin: 0.0, end: 1.0).animate(
      new CurvedAnimation(parent: animControlBox, curve: new Interval(0.1, 0.6)),
    );

    pushIconAngryUp = new Tween(begin: 30.0, end: 60.0).animate(
      new CurvedAnimation(parent: animControlBox, curve: new Interval(0.0, 0.5)),
    );
    zoomIconAngry = new Tween(begin: 0.0, end: 1.0).animate(
      new CurvedAnimation(parent: animControlBox, curve: new Interval(0.0, 0.5)),
    );
  }

  // When set the reverse value, we need set value to normal for the forward
  void setForwardValue() {
    // Icons
    pushIconLikeUp = new Tween(begin: 30.0, end: 60.0).animate(
      new CurvedAnimation(parent: animControlBox, curve: new Interval(0.0, 0.5)),
    );
    zoomIconLike = new Tween(begin: 0.0, end: 1.0).animate(
      new CurvedAnimation(parent: animControlBox, curve: new Interval(0.0, 0.5)),
    );

    pushIconLoveUp = new Tween(begin: 30.0, end: 60.0).animate(
      new CurvedAnimation(parent: animControlBox, curve: new Interval(0.1, 0.6)),
    );
    zoomIconLove = new Tween(begin: 0.0, end: 1.0).animate(
      new CurvedAnimation(parent: animControlBox, curve: new Interval(0.1, 0.6)),
    );

    pushIconHahaUp = new Tween(begin: 30.0, end: 60.0).animate(
      new CurvedAnimation(parent: animControlBox, curve: new Interval(0.2, 0.7)),
    );
    zoomIconHaha = new Tween(begin: 0.0, end: 1.0).animate(
      new CurvedAnimation(parent: animControlBox, curve: new Interval(0.2, 0.7)),
    );

    pushIconWowUp = new Tween(begin: 30.0, end: 60.0).animate(
      new CurvedAnimation(parent: animControlBox, curve: new Interval(0.3, 0.8)),
    );
    zoomIconWow = new Tween(begin: 0.0, end: 1.0).animate(
      new CurvedAnimation(parent: animControlBox, curve: new Interval(0.3, 0.8)),
    );

    pushIconSadUp = new Tween(begin: 30.0, end: 60.0).animate(
      new CurvedAnimation(parent: animControlBox, curve: new Interval(0.4, 0.9)),
    );
    zoomIconSad = new Tween(begin: 0.0, end: 1.0).animate(
      new CurvedAnimation(parent: animControlBox, curve: new Interval(0.4, 0.9)),
    );

    pushIconAngryUp = new Tween(begin: 30.0, end: 60.0).animate(
      new CurvedAnimation(parent: animControlBox, curve: new Interval(0.5, 1.0)),
    );
    zoomIconAngry = new Tween(begin: 0.0, end: 1.0).animate(
      new CurvedAnimation(parent: animControlBox, curve: new Interval(0.5, 1.0)),
    );
  }

  Future playSound(String nameSound) async {
    // Sometimes multiple sound will play the same time, so we'll stop all before play the new
    await audioPlayer.stop();
    final file = new File('${(await getTemporaryDirectory()).path}/$nameSound');
    await file.writeAsBytes((await loadAsset(nameSound)).buffer.asUint8List());
    await audioPlayer.play(file.path, isLocal: true);
  }

  Future loadAsset(String nameSound) async {
    return await rootBundle.load('sounds/$nameSound');
  }
}
