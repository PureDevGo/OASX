# Web 部署说明

本项目可以作为 Flutter Web 静态站点部署到 GitHub Pages。

## 本地构建

如果站点地址是下面这种仓库子路径：

```text
https://runhey.github.io/OASX/
```

请使用以下命令构建：

```bash
flutter build web --web-renderer canvaskit --base-href "/OASX/"
```

构建产物输出到：

```text
build/web
```

如果你部署到站点根目录或自定义域名，需要相应修改 `--base-href`。
这个值必须以 `/` 开头，并以 `/` 结尾。

例如：

```bash
flutter build web --base-href "/OASX/"
flutter build web --base-href "/"
```

## 仓库内置的 GitHub Pages 工作流

当前仓库已经带有 Web 自动发布流程：

- 工作流文件：`.github/workflows/release-web.yml`
- 触发条件：`push` 到 `master`
- 构建命令：`flutter build web --web-renderer canvaskit --base-href "/OASX/"`
- 发布分支：`page`
- 发布目录：`build/web`

## 发布步骤

1. 在 GitHub 仓库中启用 Actions。
2. 在 GitHub Pages 设置里，把发布来源设置为 `page` 分支。
3. 将代码推送到 `master`。
4. 等待 `release-web.yml` 执行完成。

完成后，页面应可通过以下地址访问：

```text
https://runhey.github.io/OASX/
```

## 说明

- `web/index.html` 使用的是 Flutter 注入的 `base href` 占位符，因此最终访问路径由构建命令中的 `--base-href` 决定。
- GitHub Pages 只能提供静态托管。项目可以正常发布为 Web 页面，但部分依赖桌面环境的功能，仍然需要单独做 Web 兼容处理。
