part of overview;

class TaskItemView extends StatelessWidget {
  final TaskItemModel model;
  final bool isRunningNow;
  final bool isWaitingNow;
  final VoidCallback? onRunNow;
  final VoidCallback? onWaitNow;

  const TaskItemView(
    this.model, {
    super.key,
    this.isRunningNow = false,
    this.isWaitingNow = false,
    this.onRunNow,
    this.onWaitNow,
  });

  @override
  Widget build(BuildContext context) {
    return model.isAllEmpty()
        ? const SizedBox(height: 30)
        : <Widget>[
            _name(context),
            _action(context),
          ]
            .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
            .padding(bottom: 10);
  }

  Widget _name(BuildContext context) {
    return <Widget>[
      Text(model.taskName.tr, style: Theme.of(context).textTheme.labelLarge),
      Text(model.nextRun, style: Theme.of(context).textTheme.labelMedium)
    ].toColumn(crossAxisAlignment: CrossAxisAlignment.start);
  }

  Widget _action(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _actionIcon(
          icon: Icons.play_arrow_rounded,
          tooltip: '立即执行',
          color: const Color(0xFF1F9D55),
          onTap: isRunningNow ? null : onRunNow,
        ),
        const SizedBox(width: 8),
        _actionIcon(
          icon: Icons.schedule_rounded,
          tooltip: '立即等待 1 小时',
          color: const Color(0xFFDD8A00),
          onTap: isWaitingNow ? null : onWaitNow,
        ),
        const SizedBox(width: 8),
        _actionIcon(
          icon: Icons.tune_rounded,
          tooltip: I18n.task_setting.tr,
          color: const Color(0xFF4C6FFF),
          onTap: () => Get.find<NavCtrl>().switchContent(model.taskName),
        ),
      ],
    );
  }

  Widget _actionIcon({
    required IconData icon,
    required String tooltip,
    required Color color,
    required VoidCallback? onTap,
  }) {
    final enabled = onTap != null;
    final backgroundColor =
        enabled ? color.withAlpha(28) : Colors.grey.withAlpha(28);
    final iconColor = enabled ? color : Colors.grey;

    return Tooltip(
      message: tooltip,
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(999),
          child: SizedBox(
            width: 32,
            height: 32,
            child: Icon(
              icon,
              size: 18,
              color: iconColor,
            ),
          ),
        ),
      ),
    );
  }
}
