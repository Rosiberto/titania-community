#!/bin/bash

# ANSI colors
CYAN="\033[1;36m"
GREEN="\033[0;32m"
RED="\033[0;31m"
RESET="\033[0m"

TOTAL_STEPS=10
CURRENT_STEP=0

# Esconde cursor
tput civis

# Desenha barra fixa no rodapé
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

# Função para exibir mensagens de progresso
function progress_message() {
  echo -e "$1"
  sleep 1
}

# Função para exibir erro e sair
function error_exit() {
  tput cnorm
  tput cup $((LINES)) 0
  echo -e "${RED}❌ Error: $1${RESET}"
  exit 1
}

# Início
clear
echo -e "\n\033[1;34m###################################################################\033[0m"
echo -e "\033[1;34m#\033[0m                  \033[1;32mWelcome to TiTaniA EasyPlatform\033[0m                \033[1;34m#\033[0m"
echo -e "\033[1;34m###################################################################\033[0m"
sleep 2

# Step 1 - Verifica Docker
docker info >/dev/null 2>&1 || error_exit "Docker daemon is not running. Please start Docker and try again."
((CURRENT_STEP++)); draw_progress_bar

# Step 2 - Para e remove containers antigos
progress_message "\n🔪 Stopping and removing old Docker containers..."

docker compose down -v --remove-orphans >/dev/null 2>&1 || true

# Remover containers parados (exited e created) que estão na rede reflex_default
docker ps -a --filter "network=reflex_default" --filter "status=exited" --filter "status=created" -q | xargs -r docker rm -f

((CURRENT_STEP++)); draw_progress_bar

# Step 2.5 - Força atualização das imagens do Docker Hub
progress_message "\n📦 Pulling versions of Docker Hub images..."

IMAGES=("fiware/orion:4.2.0" "mongo:8.0" "rosiberto/titania:latest" "fiware/iotagent-json:3.14.0" "rosiberto/nginx:1.0.25")

for IMAGE in "${IMAGES[@]}"; do

#  echo -e "🧹 Removing image: $IMAGE"
#  docker rmi -f "$IMAGE" >/dev/null 2>&1 || echo "⚠️ Could not remove image: $IMAGE"
  
  echo -e "⬇️  Pulling $IMAGE"
    
  docker pull "$IMAGE" >/dev/null 2>&1 || echo "⚠️ Could not pull image: $IMAGE"
  
  #docker pull "$IMAGE"
  
  ((CURRENT_STEP++)); draw_progress_bar
done

# Remove imagem local buildada (nginx)
#NGINX_IMAGE_ID=$(docker images -q nginx | head -n1)

#if [ -n "$NGINX_IMAGE_ID" ]; then
#  echo -e "🧹 Removing locally built nginx image: $NGINX_IMAGE_ID"
#  docker rmi -f "$NGINX_IMAGE_ID" >/dev/null 2>&1 || echo "⚠️ Could not remove nginx image."
#else
#  echo -e "⚠️ No local nginx image found."
#fi

# Step 3 - Gerencia rede Docker (não precisamos mais criar a rede manualmente)
progress_message "\n🌐 Checking if the Docker network exists..."

# Não é necessário mais criar a rede reflex_default manualmente. O Compose faz isso quando usamos 'external: true'.
# Apenas verificamos se o Compose está funcionando corretamente.

((CURRENT_STEP++)); draw_progress_bar

# Step 4 - Build & Up com rebuild do nginx
progress_message "\n⏳ Starting the main infrastructure..."
progress_message "🏗️  Building Docker containers...\n"

# Omitir warning do Compose redirecionando a saída de erro para /dev/null
docker compose build --no-cache 2>/dev/null || error_exit "Failed to rebuild Docker containers."
docker compose up -d --remove-orphans 2>/dev/null || error_exit "Failed to build and start Docker containers."

((CURRENT_STEP++)); draw_progress_bar

# Step 5 - Verifica containers
progress_message "\n🔍 Checking if the containers are running..."

if docker compose ps --services --filter "status=running" | grep . >/dev/null; then
  progress_message "✅ Infrastructure and application started successfully!"
else
  error_exit "Containers are not running. Check the logs for more details."
fi
((CURRENT_STEP++)); draw_progress_bar

# Final
progress_message "\n${GREEN} Process completed. Your Docker infrastructure is up and running.${RESET}\n"

draw_progress_bar

sleep 0.2

tput cup $((LINES - 1)) 0
tput el

tput cnorm