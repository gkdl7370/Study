# 가볍고 빠른 리눅스 환경 사용
FROM alpine:latest

# 필요한 도구(Git, Bash, 줄바꿈 변환기) 설치
RUN apk add --no-cache git bash dos2unix

# 작업 공간 설정
WORKDIR /workspace

# 명령서(push.sh) 복사
COPY push.sh /usr/local/bin/push-to-git

# [필수] Windows 스타일의 줄바꿈을 Linux 스타일로 강제 변환
RUN dos2unix /usr/local/bin/push-to-git

# 실행 권한 부여
RUN chmod +x /usr/local/bin/push-to-git

# 실행 시 스크립트 자동 실행
ENTRYPOINT ["/usr/local/bin/push-to-git"]