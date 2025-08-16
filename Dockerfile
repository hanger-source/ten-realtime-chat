## 构建后端 (Java)
FROM eclipse-temurin:21-jdk-jammy AS backend-builder
RUN apt-get update && apt-get install -y maven
WORKDIR /app/ten4j
COPY ten4j/pom.xml .
COPY ten4j/ten4j-core/pom.xml ten4j-core/
COPY ten4j/ten4j-server/pom.xml ten4j-server/
COPY ten4j/ten4j-agent/pom.xml ten4j-agent/
COPY ten4j/ .
RUN mvn clean install -DskipTests -Pbuild-jar

## 构建前端 (React)
FROM oven/bun:latest AS frontend-builder
WORKDIR /app/ten-chat-websocket-demo
ARG VITE_BACKEND_URL
COPY ten-chat-websocket-demo/package.json ten-chat-websocket-demo/bun.lock ten-chat-websocket-demo/tsconfig.json ten-chat-websocket-demo/postcss.config.cjs ten-chat-websocket-demo/tailwind.config.js ten-chat-websocket-demo/vite-env.d.ts ten-chat-websocket-demo/vite.config.ts ./
RUN bun install
ENV VITE_BACKEND_URL=$VITE_BACKEND_URL
COPY ten-chat-websocket-demo/src ./src
COPY ten-chat-websocket-demo/index.html ./index.html
RUN bun run build

## 最终镜像
FROM eclipse-temurin:21-jre-jammy
WORKDIR /app

# 复制后端jar包
COPY --from=backend-builder /app/ten4j/ten4j-server/target/ten4j-server.jar ./ten4j-server.jar

# 复制前端构建产物
COPY --from=frontend-builder /app/ten-chat-websocket-demo ./ten-chat-websocket-demo

# 复制bun可执行文件
COPY --from=frontend-builder /usr/local/bin/bun /usr/local/bin/bun

# 暴露端口
EXPOSE 3000
EXPOSE 8080

# 启动后端服务
CMD java -Dserver.port=8080 --enable-preview --add-opens java.base/sun.nio.ch=ALL-UNNAMED --add-opens java.base/jdk.internal.misc=ALL-UNNAMED --add-opens java.base/java.util=ALL-UNNAMED -jar ten4j-server.jar & \
    bun run --cwd ./ten-chat-websocket-demo preview --host 0.0.0.0 --port 3000
