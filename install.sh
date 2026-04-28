#!/bin/bash

# ANSI colors
CYAN="\033[1;36m"
GREEN="\033[0;32m"
RED="\033[0;31m"
RESET="\033[0m"

TOTAL_STEPS=10
CURRENT_STEP=0

tput civis

function draw_progress_bar() {
  local percent=$((CURRENT_STEP * 100 / TOTAL_STEPS))
  local filled=$((percent / 2))
  local empty=$((50 - filled))
  local bar=""

  for ((i = 0; i < filled; i++)); do bar+="█"; done
  for ((i = 0; i < empty; i++)); do bar+="."; done

  tput sc
  tput cup $((LINES - 1)) 0
  printf "[${bar}] ${CYAN}%3d%%${RESET} complete" "$percent"
  tput rc
}

function progress_message() {
  echo -e "$1"
  sleep 1
}

function error_exit() {
  tput cnorm
  tput cup $((LINES)) 0
  echo -e "${RED}❌ Error: $1${RESET}"
  exit 1
}

clear
echo -e "\n\033[1;34m###################################################################\033[0m"
echo -e "\033[1;34m#\033[0m                  \033[1;32mWelcome to TiTaniA EasyPlatform\033[0m                \033[1;34m#\033[0m"
echo -e "\033[1;34m###################################################################\033[0m"
sleep 2

docker info >/dev/null 2>&1 || error_exit "Docker daemon is not running. Please start Docker and try again."
((CURRENT_STEP++)); draw_progress_bar

progress_message "\n🔪 Stopping and removing old Docker containers..."

docker compose down -v --remove-orphans >/dev/null 2>&1 || true

docker ps -a --filter "network=reflex_default" --filter "status=exited" --filter "status=created" -q | xargs -r docker rm -f

((CURRENT_STEP++)); draw_progress_bar

progress_message "\n📦 Pulling versions of Docker Hub images..."

IMAGES=("fiware/orion:4.2.0" "mongo:8.0" "rosiberto/titania:latest" "fiware/iotagent-json:3.7.0" "rosiberto/nginx:1.0.25")

for IMAGE in "${IMAGES[@]}"; do

  echo -e "⬇️  Pulling $IMAGE"
    
  docker pull "$IMAGE" >/dev/null 2>&1 || echo "⚠️ Could not pull image: $IMAGE"
  
  ((CURRENT_STEP++)); draw_progress_bar
done

progress_message "\n🌐 Checking if the Docker network exists..."

((CURRENT_STEP++)); draw_progress_bar

progress_message "\n⏳ Starting the main infrastructure..."
progress_message "🏗️  Building Docker containers...\n"

docker compose build --no-cache 2>/dev/null || error_exit "Failed to rebuild Docker containers."
docker compose up -d --remove-orphans 2>/dev/null || error_exit "Failed to build and start Docker containers."

((CURRENT_STEP++)); draw_progress_bar

progress_message "\n🔍 Checking if the containers are running..."

if docker compose ps --services --filter "status=running" | grep . >/dev/null; then
  progress_message "✅ Infrastructure and application started successfully!"
else
  error_exit "Containers are not running. Check the logs for more details."
fi
((CURRENT_STEP++)); draw_progress_bar

progress_message "\n${GREEN} Process completed. Your Docker infrastructure is up and running.${RESET}\n"

draw_progress_bar

sleep 0.2

tput cup $((LINES - 1)) 0
tput el

tput cnorm