import 'package:flutter/material.dart';
import 'package:libadwaita/libadwaita.dart';

class FlapController extends ChangeNotifier {
  bool isOpen = true;
  bool isModal = false;

  // bad practice but can live with it
  /// INTERNAL STUFF, DON'T USE DIRECTLY
  BuildContext? context;

  /// INTERNAL STUFF, DON'T USE DIRECTLY
  FoldPolicy policy = FoldPolicy.auto;

  /// INTERNAL STUFF, DON'T USE DIRECTLY
  FlapPosition position = FlapPosition.start;

  bool shouldEnableDrawerGesture(FlapPosition position) {
    return isModal && this.position == position;
  }

  bool shouldHide() {
    switch (policy) {
      case FoldPolicy.never:
        return !isOpen;
      case FoldPolicy.always:
        return true;
      case FoldPolicy.auto:
        return isModal || !isOpen;
    }
  }

  void onDrawerChanged(bool val) {
    updateOpenState(val);
  }

  void updateOpenState(bool val) {
    if (val != isOpen) {
      isOpen = val;
      notifyListeners();
    }
  }

  void updateModalState(BuildContext context, bool val) {
    if (val != isModal) {
      isModal = val;
      // This function will be called on every resize. Thus when we resize from
      // a mobile sized window to a desktop sized window and the drawer is open,
      // then the drawer will stay open and the sidebar will also expand. To
      // prevent this, we close the drawer if its already open on a desktop size
      // window.
      if (!isModal) {
        if ((Scaffold.of(context).isDrawerOpen ||
                Scaffold.of(context).isEndDrawerOpen) &&
            policy != FoldPolicy.always) {
          Navigator.of(context).pop();
        }
      }
      notifyListeners();
    }
  }

  void open({BuildContext? context}) {
    if (!isOpen) {
      isOpen = true;
      // Usually open only should set the isOpen variable, but if we have a
      // mobile sized device OR the fold policy is set to always, we open the
      // drawer because this is how the actual libadwaita behaves
      if (isModal || policy == FoldPolicy.always) {
        switch (position) {
          case FlapPosition.start:
            Scaffold.of(context ?? this.context!).openDrawer();
            break;
          case FlapPosition.end:
            Scaffold.of(context ?? this.context!).openEndDrawer();
            break;
        }
      }
      notifyListeners();
    }
  }

  void close({BuildContext? context}) {
    if (isOpen) {
      isOpen = false;
      var scaffold = Scaffold.of(context ?? this.context!);
      // Usually close only should set the isOpen variable, but if we have a
      // mobile sized device OR the fold policy is set to always, we close the
      // drawer (if its open) because this is how the actual libadwaita behaves
      if ((isModal || policy == FoldPolicy.always) &&
          (scaffold.isDrawerOpen || scaffold.isEndDrawerOpen)) {
        Navigator.of(context ?? this.context!).pop();
      }
      notifyListeners();
    }
  }

  void toggle({BuildContext? context}) {
    if (isOpen) {
      close(context: context ?? this.context);
    } else {
      open(context: context ?? this.context);
    }
  }
}