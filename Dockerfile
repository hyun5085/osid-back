# ── 1단계: 빌드 환경 ──
FROM eclipse-temurin:17-jdk-jammy AS builder
WORKDIR /app

# Gradle Wrapper 및 설정 복사
COPY gradlew settings.gradle build.gradle ./
COPY gradle gradle

# 실행 권한 부여
RUN chmod +x gradlew

# 소스 복사 및 JAR 빌드
COPY src src
RUN ./gradlew clean bootJar -x test

# ── 2단계: 런타임 환경 ──
FROM eclipse-temurin:17-jdk-jammy
WORKDIR /app

# 빌드된 JAR 복사
COPY --from=builder /app/build/libs/*.jar app.jar

# JVM 메모리 제한: 최소 256M, 최대 512M
ENTRYPOINT ["java", "-Xms256m", "-Xmx512m", "-jar", "/app/app.jar"]

