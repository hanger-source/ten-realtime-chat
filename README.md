# Ten Realtime Chat

`ten-realtime-chat` 是一个全面的实时聊天应用示例，旨在展示如何高效整合基于 WebSocket 的前端和基于 Java `ten4j` 框架的后端，实现高性能、高并发的双向实时通信。

**⚠️ 注意**: 本项目目前仅保证核心功能可正常运行。部分功能代码可能仍存在错误或未经过全面测试。

## 项目结构

- `ten-chat-websocket-demo/`: 前端应用 (基于 React, Vite, Tailwind CSS 和 TypeScript)
- `ten4j/`: 后端服务 (基于 Java, Maven, Netty 和 TEN-framework)

## 核心特性

- **实时消息传输**: 利用 WebSocket 协议，实现消息的即时发送与接收，确保沟通无延迟。
- **直观的用户界面**: 前端采用 React 和 Tailwind CSS 构建，提供简洁、美观且响应式的聊天界面，适配不同设备。
- **深度集成 ten4j**: 后端完全基于 `ten4j` 框架开发，充分展现其在构建高性能、高并发实时通信应用方面的强大能力。
- **高性能事件循环 (Runloop)**: `ten4j` 核心 `Runloop` 基于 Agrona `AgentRunner` 实现，提供高效的任务调度和线程管理，确保系统响应性和吞吐量。
- **可插拔扩展机制 (Extension)**: `ten4j` 通过灵活的扩展机制，轻松集成外部 AI 服务（如 ASR、TTS、LLM）和其他系统组件，目前已支持部分阿里云 Bailian 平台的 ASR、TTS 和 LLM 集成。
- **命令处理机制**: `ten4j` 实现了灵活的命令接收和分发机制，能够处理来自前端或外部系统的各类指令。
- **AI 服务集成接口**: `ten4j` 预留了与 ASR (自动语音识别)、TTS (文本转语音) 和 LLM (大型语言模型) 等 AI 服务集成的能力，方便构建多模态 AI 应用。
- **模块化设计**: 项目结构清晰，前端和后端均采用模块化设计，易于理解和扩展，方便开发者在此基础上进行二次开发。
- **图（Graph）运行时**: `ten4j` 支持基于图（Graph）的会话流程定义和执行，提供灵活的业务逻辑编排能力。
- **跨平台兼容**: 前端可在现代浏览器中运行，后端基于 Java，具备良好的跨平台特性。

## 技术栈

### 前端 (`ten-chat-websocket-demo`)

- **框架**: [React](https://react.dev/)
- **构建工具**: [Vite](https://vitejs.dev/)
- **样式**: [Tailwind CSS](https://tailwindcss.com/)
- **语言**: [TypeScript](https://www.typescriptlang.org/)
- **包管理**: [Bun](https://bun.sh/)

### 后端 (`ten4j`)

- **核心框架**: [TEN-framework Java](https://github.com/hanger-source/ten4j)
- **构建工具**: [Maven](https://maven.apache.org/)
- **网络通信**: [Netty](https://netty.io/) (用于 WebSocket 服务器)
- **协议**: WebSocket
- **语言**: [Java](https://www.java.com/)
- **日志**: SLF4J / Logback
- **JSON 处理**: Jackson

## 如何运行

### 1. 克隆项目

首先，将整个仓库克隆到本地：

```bash
git clone <项目地址> # 请替换为实际的项目地址
cd ten-realtime-chat
```

### 2. 启动后端服务 (`ten4j`)

进入 `ten4j` 目录并编译运行后端服务。请确保您的系统已安装 Java 开发环境 (JDK 21 或更高版本) 和 Apache Maven。

```bash
cd ten4j
mvn clean install
java -Dserver.port=8080 --add-opens java.base/sun.nio.ch=ALL-UNNAMED --add-opens java.base/jdk.internal.misc=ALL-UNNAMED --add-opens java.base/java.util=ALL-UNNAMED -jar ten4j-server/target/ten4j-server-1.0-SNAPSHOT.jar
```

### 环境变量

您需要设置以下环境变量，以便后端服务能够正常与阿里云百炼平台集成：

- `BAILIAN_DASHSCOPE_API_KEY`: 您的DashScope API Key。例如：`export BAILIAN_DASHSCOPE_API_KEY=sk-xxxx`

请确认后端服务已成功启动，并监听 WebSocket 连接 (通常在 `ws://localhost:8080/websocket` 等地址)。您可以通过 `-Dserver.port=<端口号>` 参数来指定后端服务的端口，例如 `-Dserver.port=8080`。

### 3. 启动前端应用 (`ten-chat-websocket-demo`)

在新终端中，进入 `ten-chat-websocket-demo` 目录，安装依赖并启动前端应用：

```bash
cd ten-chat-websocket-demo
bun install
bun run dev
```

前端应用通常会在 `http://localhost:3000` 或类似地址上启动。在浏览器中打开该地址即可访问功能完备的实时聊天应用。

### 注意

在启动前端之前，请确保后端服务已经启动并正在运行。

## 通过 Docker 运行

您可以使用 Docker 来构建和运行整个应用，而无需手动设置前端和后端环境。

### 1. 构建 Docker 镜像

在项目根目录执行以下命令来构建 Docker 镜像：

```bash
docker build -t ten-realtime-chat .
```

### 2. 运行 Docker 容器

构建成功后，您可以运行以下命令来启动容器：

```bash
docker run -p 3000:3000 -p 8080:8080 -e BAILIAN_DASHSCOPE_API_KEY="sk-xxxx" ten-realtime-chat
```

请将 `sk-xxxx` 替换为您的实际 DashScope API Key。容器启动后，前端应用将可以通过 `http://localhost:3000` 访问。

## 通过 Docker Compose 运行

您可以使用 Docker Compose 轻松地构建和运行前端和后端服务。

### 1. 设置环境变量

在项目根目录创建一个 `.env` 文件，并添加您的 DashScope API Key：

```
BAILIAN_DASHSCOPE_API_KEY=sk-xxxx # 请替换为您的实际API Key
```

### 2. 构建并运行服务

在项目根目录执行以下命令来构建并启动所有服务：

```bash
docker compose up --build
```

服务启动后，前端应用将可以通过 `http://localhost:3000` 访问。

## 文件结构

```
ten-realtime-chat/
├── ten-chat-websocket-demo/ # 前端项目，包含 React 应用的源代码、配置和资源。
│   ├── public/              # 静态资源目录。
│   ├── src/                 # 前端核心源代码。
│   │   ├── app/             # Next.js 路由和页面。
│   │   ├── assets/          # 图片、字体等静态资源。
│   │   ├── common/          # 通用工具函数和常量。
│   │   ├── components/      # 可复用的 React 组件。
│   │   ├── hooks/           # 自定义 React Hooks。
│   │   ├── lib/             # 库文件和实用工具。
│   │   ├── manager/         # 状态管理和 WebSocket 连接管理。
│   │   ├── store/           # Redux 存储配置。
│   │   └── types/           # TypeScript 类型定义。
│   ├── .env                 # 环境变量配置文件。
│   ├── package.json         # 前端项目依赖和脚本。
│   └── vite.config.ts       # Vite 构建工具配置。
└── ten4j/                 # 后端项目，基于 Java 和 ten-framework 构建。
    ├── ten4j-agent/         # ten4j 代理模块。
    ├── ten4j-core/          # ten4j 核心模块。
    ├── ten4j-server/        # ten4j 服务器模块。
    ├── pom.xml              # Maven 主配置文件，管理所有子模块。
    └── README.md            # ten4j 项目说明。
```

## 与 TEN-framework 的关系

`ten4j` 是 `TEN-framework` (一个开源的会话式 AI 代理框架) 的一个 Java 实现。`TEN-framework` 旨在提供构建多模态、实时 AI 代理的通用能力，而 `ten4j` 则是利用 Java 语言和生态系统，对其中部分核心概念和功能进行了具体实现和探索。您可以访问 `TEN-framework` 的官方 GitHub 仓库了解更多信息：

- **TEN-framework GitHub**: [https://github.com/TEN-framework/ten-framework](https://github.com/TEN-framework/ten-framework)

衷心感谢 `TEN-framework` 社区为本项目提供了丰富的灵感和宝贵的开源代码，供我们学习和借鉴。

## AI 辅助开发

本项目在开发过程中充分利用了 Cursor 的 AI 编码能力，包括但不限于项目分析、方案设计、代码实现、问题调试等环节。Cursor AI 有效提升了开发效率和代码质量。

## 许可证

本项目采用 Apache 2.0 许可证。更多详情请参阅 [LICENSE](LICENSE) 文件。
