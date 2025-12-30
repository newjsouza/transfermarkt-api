#!/bin/bash

# ============================================================
# SCRIPT DE DEPLOY - TRANSFERMARKT API PARA GOOGLE CLOUD RUN
# ============================================================
# Execute no Cloud Shell:
# 1. gcloud auth login
# 2. git clone https://github.com/newjsouza/transfermarkt-api.git
# 3. cd transfermarkt-api
# 4. bash deploy-cloud-run.sh
# ============================================================

set -e

echo "================================================="
echo "  DEPLOY TRANSFERMARKT API - GOOGLE CLOUD RUN"
echo "================================================="
echo ""

PROJECT_ID="apex-ml-transfermarkt"
REGION="us-central1"
SERVICE_NAME="transfermarkt-api"

echo "[1/7] Configurando projeto padrão..."
gcloud config set project $PROJECT_ID
echo ""

echo "[2/7] Habilitando APIs necessarias..."
gcloud services enable cloudbuild.googleapis.com
gcloud services enable containerregistry.googleapis.com
gcloud services enable run.googleapis.com
echo "[OK] APIs habilitadas"
echo ""

echo "[3/7] Definindo regiao padrão..."
gcloud config set run/region $REGION
echo "Regiao: $REGION"
echo ""

echo "[4/7] Compilando Docker image..."
echo "Esta etapa pode levar alguns minutos..."
gcloud builds submit --tag gcr.io/$PROJECT_ID/$SERVICE_NAME:latest
echo ""

echo "[5/7] Fazendo deploy no Cloud Run..."
gcloud run deploy $SERVICE_NAME \
  --image=gcr.io/$PROJECT_ID/$SERVICE_NAME:latest \
  --region=$REGION \
  --allow-unauthenticated \
  --memory=256Mi \
  --cpu=0.5 \
  --max-instances=3 \
  --min-instances=0 \
  --timeout=3600 \
  --set-env-vars="ENVIRONMENT=production"
echo ""

echo "[6/7] Obtendo URL da API..."
SERVICE_URL=$(gcloud run services describe $SERVICE_NAME --region=$REGION --format='value(status.url)')
echo "URL: $SERVICE_URL"
echo ""

echo "[7/7] Testando saude da API..."
sleep 3
curl -s $SERVICE_URL/health || echo "API iniciando..."
echo ""
echo ""

echo "================================================="
echo "  DEPLOY CONCLUIDO COM SUCESSO!"
echo "================================================="
echo ""
echo "URL da API: $SERVICE_URL"
echo ""
echo "Proximos passos:"
echo "1. Teste a API: curl $SERVICE_URL/health"
echo "2. Acompanhe logs: gcloud run logs read $SERVICE_NAME"
echo "3. Use em APEX-ML: API_URL=$SERVICE_URL"
echo ""
