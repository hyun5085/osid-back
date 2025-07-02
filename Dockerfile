# ── 1단계: Java 빌드 ──
FROM eclipse-temurin:17-jdk-jammy AS builder
WORKDIR /app

# Gradle 설정 복사 및 빌드
COPY gradlew settings.gradle build.gradle ./
COPY gradle gradle
RUN chmod +x gradlew
COPY src src
RUN ./gradlew clean bootJar -x test

# ── 2단계: 런타임 ──
FROM eclipse-temurin:17-jdk-jammy
WORKDIR /app

# (A) Python 설치 및 'python' 링크 생성
RUN apt-get update && \
    apt-get install -y python3 python3-pip && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3 1 && \
    rm -rf /var/lib/apt/lists/*

# (B) Java 애플리케이션 복사
COPY --from=builder /app/build/libs/*.jar app.jar

# (C) Python 스크립트와 라이브러리 설치
COPY train.py requirements.txt ./
RUN pip3 install --no-cache-dir -r requirements.txt

# 컨테이너 기동 시 Java 앱 실행
ENTRYPOINT ["java","-Xms256m","-Xmx512m","-jar","/app/app.jar"]
