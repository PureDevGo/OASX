part of overview;

class OverviewController extends GetxController with LogMixin {
  String name;
  final scriptService = Get.find<ScriptService>();
  final taskActionState = <String, String>{}.obs;
  late final scriptModel = scriptService.findScriptModel(name)!;

  OverviewController({required this.name});

  @override
  void onInit() {
    super.onInit();
  }

  @override
  Future<void> onClose() async {
    super.onClose();
  }

  Future<void> toggleScript() async {
    if (scriptModel.state.value != ScriptState.running) {
      scriptService.startScript(name);
      clearLog();
    } else {
      scriptService.stopScript(name);
    }
  }

  bool isTaskActionRunning(String taskName, String action) =>
      taskActionState[taskName] == action;

  Future<void> runTaskNow(String taskName) async {
    if (taskName.isEmpty || taskActionState.containsKey(taskName)) return;

    taskActionState[taskName] = 'run';
    try {
      final success = await ApiClient().runScriptTaskNow(name, taskName);
      if (success) {
        Get.snackbar(I18n.tip.tr, '立即执行已加入队列');
        await scriptService.wsService.send(name, 'get_schedule');
      } else {
        Get.snackbar(I18n.network_error.tr, '立即执行失败');
      }
    } finally {
      taskActionState.remove(taskName);
    }
  }

  Future<void> waitTaskOneHour(String taskName) async {
    if (taskName.isEmpty || taskActionState.containsKey(taskName)) return;

    taskActionState[taskName] = 'wait';
    try {
      final target = DateTime.now().add(const Duration(hours: 1));
      final success = await ApiClient().delayScriptTaskTo(name, taskName, target);
      if (success) {
        Get.snackbar(I18n.tip.tr, '已延后 1 小时');
        await scriptService.wsService.send(name, 'get_schedule');
      } else {
        Get.snackbar(I18n.network_error.tr, '立即等待失败');
      }
    } finally {
      taskActionState.remove(taskName);
    }
  }
}
