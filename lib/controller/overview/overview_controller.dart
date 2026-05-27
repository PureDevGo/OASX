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
    await syncTaskNextRun(taskName, 'run', DateTime.now());
  }

  Future<void> waitTaskOneHour(String taskName) async {
    await syncTaskNextRun(
      taskName,
      'wait',
      DateTime.now().add(const Duration(hours: 1)),
    );
  }

  Future<void> syncTaskNextRun(
    String taskName,
    String action,
    DateTime target,
  ) async {
    if (taskName.isEmpty || taskActionState.containsKey(taskName)) return;

    taskActionState[taskName] = action;
    try {
      final success = await ApiClient().syncScriptTaskNextRun(
        name,
        taskName,
        target,
      );
      if (success) {
        final message = action == 'run'
            ? 'Task queued for immediate run'
            : 'Delayed by 1 hour';
        Get.snackbar(I18n.tip.tr, message);
        await scriptService.wsService.send(name, 'get_schedule');
      } else {
        final message =
            action == 'run' ? 'Run now failed' : 'Wait now failed';
        Get.snackbar(I18n.network_error.tr, message);
      }
    } finally {
      taskActionState.remove(taskName);
    }
  }
}
