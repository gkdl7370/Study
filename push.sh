#!/bin/bash

# --- 지호님 정보 설정 ---
GIT_NAME="gkdl7370"
GIT_EMAIL="gkdl7370@gmail.com" 

# REPO_URL 설정
REPO_URL="https://${GITHUB_TOKEN}@github.com/gkdl7370/Study.git"

# 1. 도커 컨테이너 내부의 Git 환경 설정
git config --global --add safe.directory /workspace
git config --global user.name "$GIT_NAME"
git config --global user.email "$GIT_EMAIL"

# [추가] 깃허브와 내 컴퓨터 내용을 합치는 방식을 "Merge(합치기)"로 정해줍니다.
git config --global pull.rebase false

# 2. 작업 폴더로 이동
cd /workspace

# 3. Git 저장소 초기화 체크
if [ ! -d ".git" ]; then
    echo ">>> [로봇] 저장소 초기화 중..."
    git init
    git remote add origin "$REPO_URL"
    git checkout -b main
fi

# 4. 변경 사항 확인 및 추가
echo ">>> [로봇] 공부 폴더의 변경 사항을 확인 중입니다..."
git add .

# 5. 업로드 실행 여부 판단
if git diff-index --quiet HEAD -- 2>/dev/null; then
    echo ">>> [로봇] 새로 업로드할 내용이 없습니다."
else
    echo ">>> [로봇] 새로운 기록을 발견했습니다. 커밋을 시작합니다..."
    DATE=$(date +'%Y-%m-%d %H:%M:%S')
    git commit -m "지호의 자동 업데이트: $DATE"
    
    # ---------------------------------------------------------
    # 깃허브에 있는 기존 파일들과 합치는 과정 (전략 설정 후 다시 시도)
    echo ">>> [로봇] 깃허브와 동기화 시도 중 (Pull)..."
    git pull origin main --allow-unrelated-histories --no-edit
    # ---------------------------------------------------------

    echo ">>> [로봇] 깃허브 서버로 전송 중 (Push)..."
    git push origin main 
    
    if [ $? -eq 0 ]; then
        echo ">>> [성공] 깃허브 업로드 완료!"
    else
        echo ">>> [실패] 전송 오류! GITHUB_TOKEN 권한 혹은 브랜치명을 확인하세요."
    fi
fi