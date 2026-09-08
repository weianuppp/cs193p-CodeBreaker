# CodeBreaker

一个 Mastermind（珠玑妙算）风格的 iOS / iPadOS 猜密码游戏，使用 SwiftUI 和 SwiftData 构建，是跟随斯坦福 CS193p 课程完成的实践项目。仓库的提交历史对应课程 **L2–L16** 的学习过程。

## 玩法说明

每局开始时，系统会随机生成一个隐藏的 4 色密码，你需要猜出它：

1. 点击四个密码位置之一，再从下方的调色板中选择颜色。
2. 点击 **Guess** 提交本次猜测。
3. 反馈标记会提示你猜得有多接近：
   - 实心圆点 —— 颜色和位置都正确。
   - 空心圆点 —— 颜色正确，但位置不对。
4. 当猜测与隐藏密码完全一致时，游戏结束并揭晓密码。

## 项目结构

```text
CodeBreaker/
├── CodeBreakerApp.swift          应用入口，注入 SwiftData 容器
├── Assets.xcassets
├── Model/
│   ├── CodeBreaker.swift         游戏模型（SwiftData）：规则、尝试记录、计时
│   ├── Code.swift                一行密码：类型、颜色、匹配计算
│   ├── Kind.swift                Kind 枚举（master / guess / attempt）与字符串互转
│   └── CodeBreaker+Codable.swift JSON 快照的编码与解码
└── UI/
    ├── GameChooser.swift         分栏导航：游戏列表 + 对局详情
    ├── GameList.swift            游戏库：查询、排序、搜索、删除
    ├── GameSummary.swift         紧凑 / 常规 / 大尺寸游戏卡片
    ├── GameEditor.swift          新建与编辑游戏
    ├── PegChoicesChooser.swift   调色板编辑器
    ├── CodeBreakerView.swift     对局主界面
    ├── CodeView.swift            密码行：选中状态与反馈区域
    ├── PegView.swift             菱形 Peg 渲染
    ├── PegChooser.swift          点击选色工具条
    ├── MatchMarker.swift         猜测结果反馈圆点
    ├── ElapsedTime.swift         计时显示
    ├── ElapsedTimeTracker.swift  感知场景与保存事件的计时器
    ├── Diamond.swift             自定义形状（用于 Peg）
    └── Color+String.swift        颜色与十六进制字符串转换
```

## 开发历程

每个提交对应一次课程练习：

| 提交 | 课程 | 内容 |
| --- | --- | --- |
| `752c9f6` | Initial Commit | Xcode 工程骨架、应用入口、资源目录 |
| `54bcce8` | L2 CodeBreaker App | 第一个可玩的界面与反馈标记视图 |
| `fe23f9d` | L3 Model and UI | 早期模型与界面微调 |
| `e137ac5` | L4 Model and UI Demonstration | 核心 `CodeBreaker` 模型与主对局界面 |
| `eb4af95` | L5 Layout & DataFlow | 模型与视图之间的数据流和布局调整 |
| `33e5cc9` | L6 Layout & DataFlow Demonstration | 拆分出 `Code` 模型；构建 `CodeView`、`PegView`、`PegChooser` |
| `01c1b71` | L7 Animation | 整理为 `Model/` 与 `UI/` 目录；重构 `CodeView` |
| `50485c3` | L8 Animation Demonstration | 猜测与反馈的动画过渡 |
| `01546e7` | L9 Protocols | 计时显示与基于协议的 API 组织 |
| `579a2e7` | L10 Complex UIs | 游戏库：`GameChooser`、`GameList`、`GameSummary` |
| `fc20106` | L11 Multiple Platform | 分栏导航（列表 + 详情）；编辑器与游戏列表 |
| `b1d18eb` | L12 Even More Complex UIs | 更完整的编辑器、调色板选择、计时显示 |
| `3bfdc9f` | L13 SwiftData | 通过 `@Model` 持久化；`Kind` 字符串存储；颜色十六进制转换 |
| `277fed5` | L14 SwiftData Demonstration | 查询排序 / 筛选与预览支持 |
| `47805e0` | L15 Multithreading | 感知应用场景与模型保存的计时处理 |
| `de66006` | L16 Shape Gesture Perspective | `Diamond` 形状、Codable JSON 存档 / 读取、示例游戏导入 |
