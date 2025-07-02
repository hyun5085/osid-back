# ── 1단계: 빌드 환경 ──
FROM eclipse-temurin:17-jdk-jammy AS builder
WORKDIR /app

# Gradle Wrapper 및 설정 복사
COPY gradlew settings.gradle build.gradle ./
COPY gradle gradle
RUN chmod +x gradlew

# 소스 복사 및 JAR 빌드
COPY src src
RUN ./gradlew clean bootJar -x test

# ── 2단계: 런타임 환경 ──
FROM eclipse-temurin:17-jdk-jammy
WORKDIR /app

# (1) apt로 Python3 설치
RUN apt-get update \
 && apt-get install -y python3 python3-pip \
 && rm -rf /var/lib/apt/lists/* \
 # (2) python 커맨드를 python3로 가리키도록 심볼릭 링크
 && ln -s /usr/bin/python3 /usr/bin/python

# 빌드된 JAR 복사
COPY --from=builder /app/build/libs/*.jar app.jar

# train.py와 필요하면 venv, requirements.txt도 복사
COPY train.py requirements.txt ./
# (필요하다면) venv 폴더를 미리 만들어 두셨다면
# COPY venv venv

# (3) ENTRYPOINT는 java 그대로 두고, Spring에서 ProcessBuilder("python", "train.py") 호출 가능
ENTRYPOINT ["java", "-Xms256m", "-Xmx512m", "-jar", "/app/app.jar"]
