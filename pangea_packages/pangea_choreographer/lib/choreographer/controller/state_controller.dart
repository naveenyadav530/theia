import 'package:matrix/matrix.dart';

import '../../pangea_choreographer.dart';
import '../constants/route_type.dart';

class ChoreoState {
  ChoreoController controller;
  bool isOpen = false;
  ChoreoState(this.controller);
  bool _isEditing = true;
  String originalText = '';
  String? _roomId;
  String get userId => controller.myMatrixClient!.userId;
  List<int> payLoadIds = [];
  String currentRoute = ChoreoRoute.INITAL_LOADING;
  void reset() {
    this.currentRoute = ChoreoRoute.INITAL_LOADING;
  }

  String? _classId;
  set classId(String? classId) {
    _classId = classId;
  }

  String? get classId => _classId;
  get roomId => _roomId;
  void setRoomId(String? roomId) {
    _roomId = roomId ?? '';
  }

  void openBar() {
    controller.dismissKeyboard();
    Future.delayed(Duration(microseconds: 100), () {
      isOpen = true;
      stopEditing();
    });
    originalText = controller.textController!.value.text;
    controller.step1!.initialize();
  }

  void startEditing() {
    _isEditing = true;
  }

  bool get isEditing => _isEditing;
  void stopEditing() {
    _isEditing = false;
  }

  void closeBar() {
    this.isOpen = false;
  }

  void clearState() {
    this.currentRoute = ChoreoRoute.INITAL_LOADING;
    payLoadIds = [];
    startEditing();
    originalText = '';
    closeBar();
  }

  void _setState() {
    this.controller.setState();
  }

  void changeRoute(String route) {
    _validateRoute(route);
    currentRoute = route;
    _setState();
  }

  void _validateRoute(String route) {
    switch (route) {
      case ChoreoRoute.STEP1:
        {
          break;
        }
      case ChoreoRoute.INITAL_LOADING:
        {
          break;
        }
      case ChoreoRoute.SEND:
        {
          break;
        }
      case ChoreoRoute.STEP2:
        {
          break;
        }
      case ChoreoRoute.STEP1_ERROR:
        {
          break;
        }
      default:
        {
          throw Exception('Invalid route');
        }
    }
  }
}
