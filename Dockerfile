# ── 1단계: 빌드 환경 ──
FROM eclipse-temurin:17-jdk-jammy AS builder
WORKDIR /app

# Gradle 빌드
COPY gradlew settings.gradle build.gradle ./
COPY gradle gradle
RUN chmod +x gradlew
COPY src src
RUN ./gradlew clean bootJar -x test

# ── 2단계: 런타임 환경 ──
FROM eclipse-temurin:17-jdk-jammy

# 1) 파이썬 설치
RUN apt-get update && \
    apt-get install -y python3 python3-pip && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# 2) 자바 JAR 복사
COPY --from=builder /app/build/libs/*.jar app.jar

# 3) 파이썬 스크립트·의존성 복사
COPY train.py requirements.txt ./

# 4) pip로 파이썬 패키지 설치
RUN pip3 install --no-cache-dir -r requirements.txt

# 5) JVM 메모리 제한과 ENTRYPOINT
ENTRYPOINT ["sh","-c","java -Xms256m -Xmx512m -jar /app/app.jar"]
