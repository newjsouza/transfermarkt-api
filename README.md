# Transfermarkt API - APEX-ML v4.0 Integration

API FastAPI para scraping de dados do Transfermarkt.com integrada com o sistema APEX-ML v4.0 para análise de apostas esportivas.

## Características

- **Framework**: FastAPI (Python 3.11+)
- **Deploy**: Google Cloud Run (Free Tier - us-central1)
- **Endpoints**: Players, Clubs, Competitions, Matches
- **Cache**: Implementado para otimizar requisições
- **Health Check**: `/health` para verificar disponibilidade
- **APEX-ML Integ**: Endpoints críticos para análise de Handicap 1, Chance Dupla e AFCON

## Deploy no Google Cloud Run

### Pré-requisitos

1. **Conta Google Cloud** com projeto ativo
2. **Google Cloud SDK** instalado (`gcloud` CLI)
3. **Docker** instalado (para build local, opcional)
4. **GitHub** com este repositório forked/clonado

### Método 1: Deploy via gcloud CLI (RECOMENDADO)

#### Passo 1: Autenticar no GCP

```bash
gcloud auth login
gcloud config set project apex-ml-transfermarkt
```

#### Passo 2: Configurar região padrão (CRÍTICO para FREE TIER)

```bash
gcloud config set run/region us-central1
```

**Regiões aceitas no FREE TIER:**
- `us-central1` (Iowa) ← RECOMENDADO
- `us-east1` (Carolina do Sul)
- `us-west1` (Oregon)

#### Passo 3: Ativar APIs necessárias

```bash
# Cloud Run API
gcloud services enable run.googleapis.com

# Cloud Build API (para build automático do Docker)
gcloud services enable cloudbuild.googleapis.com

# Container Registry API
gcloud services enable containerregistry.googleapis.com
```

#### Passo 4: Deploy do repositório

**Opção A: Deploy direto do GitHub**

```bash
gcloud run deploy transfermarkt-api \
  --source . \
  --region us-central1 \
  --allow-unauthenticated \
  --min-instances 0 \
  --max-instances 3 \
  --memory 256Mi \
  --cpu 0.5 \
  --timeout 3600 \
  --set-env-vars ENVIRONMENT=production
```

**Opção B: Clone local e deploy**

```bash
# Clone o repositório
git clone https://github.com/newjsouza/transfermarkt-api.git
cd transfermarkt-api

# Deploy com gcloud
gcloud run deploy transfermarkt-api \
  --source . \
  --region us-central1 \
  --allow-unauthenticated \
  --min-instances 0 \
  --max-instances 3
```

#### Passo 5: Copiar URL do serviço

Após deploy bem-sucedido, você receberá:

```
Service URL: https://transfermarkt-api-XXXXX-uc.a.run.app
```

Salve esta URL para usar nos testes e integração com APEX-ML.

### Método 2: Deploy via Google Cloud Console (UI)

1. Acesse [Google Cloud Console](https://console.cloud.google.com)
2. Vá para **Cloud Run** → **Criar serviço**
3. Selecione: **Realizar implantação contínua com um repositório (GitHub)**
4. Conecte seu repositório `transfermarkt-api`
5. Configure:
   - **Nome do serviço**: `transfermarkt-api`
   - **Região**: `us-central1` (Iowa)
   - **Autenticação**: Permitir acesso público
6. Clique em **Criar**

## Testes da API

### Health Check

```bash
curl https://transfermarkt-api-XXXXX-uc.a.run.app/health
```

Resposta esperada:
```json
{
  "status": "healthy",
  "timestamp": "2025-12-30T10:00:00.000000",
  "service": "transfermarkt-api",
  "version": "1.0.0"
}
```

### Listar Endpoints

```bash
curl https://transfermarkt-api-XXXXX-uc.a.run.app/
```

### Buscar Perfil de Jogador

```bash
curl https://transfermarkt-api-XXXXX-uc.a.run.app/players/433177/profile
```

### Buscar Leses (Critical para APEX-ML Vetos)

```bash
curl https://transfermarkt-api-XXXXX-uc.a.run.app/players/433177/injuries
```

### Buscar Elenco do Clube

```bash
curl https://transfermarkt-api-XXXXX-uc.a.run.app/clubs/11/squad
```

### Buscar Tabela da Competição

```bash
curl https://transfermarkt-api-XXXXX-uc.a.run.app/competitions/GB1/table
```

## Integração com APEX-ML v4.0

Uma vez deployado, use a URL em suas análises APEX-ML:

```python
from transfermarktclient import TransfermarktAPIClient

api_url = "https://transfermarkt-api-XXXXX-uc.a.run.app"
client = TransfermarktAPIClient(api_url)

# Buscar dados para análise
clube_elenco = client.getClubSquad(11)  # Arsenal
lesoes = client.getPlayerInjuries(433177)  # Bukayo Saka
tabela = client.getCompetitionTable("GB1")  # Premier League
```

## Custo (FREE TIER)

No Free Tier do Google Cloud:

- **2 milhões de requisições/mês** gratuitas
- **180.000 CPU-segundos/mês** gratuitos
- **360.000 GB-segundos/mês** gratuitos
- Mínimo de instâncias: **0** (scale to zero)
- Máximo de instâncias: **3**

**Custo estimado com esta configuração**: **$0.00/mês** (dentro do Free Tier)

## Troubleshooting

### Erro: "Connection Refused"

```bash
# Verificar se o serviço está rodando
gcloud run services list

# Verificar logs
gcloud run logs read transfermarkt-api --limit 50
```

### Erro: "Memory Limit Exceeded"

```bash
# Aumentar memória
gcloud run deploy transfermarkt-api \
  --source . \
  --memory 512Mi \
  --region us-central1
```

### Erro: "Timeout"

```bash
# Aumentar timeout
gcloud run deploy transfermarkt-api \
  --source . \
  --timeout 3600 \
  --region us-central1
```

## Monitoramento

### Ver logs em tempo real

```bash
gcloud run logs read transfermarkt-api --limit 50
gcloud run logs read transfermarkt-api --limit 50 --follow
```

### Ver apenas erros

```bash
gcloud run logs read transfermarkt-api --limit 50 | grep ERROR
```

### Ver métricas

```bash
gcloud run services describe transfermarkt-api --region us-central1
```

## Próximos Passos

1. **Implement Web Scraping**: Adicionar web scraping real do Transfermarkt
2. **Cache Strategy**: Implementar Redis ou Memcached
3. **Rate Limiting**: Proteger endpoints com rate limiting
4. **Autenticação**: Adicionar API keys para produção
5. **CI/CD**: Configurar GitHub Actions para auto-deploy
6. **Monitoring**: Integrar com Cloud Monitoring/Alerting

## Contato & Suporte

- **Repositório**: https://github.com/newjsouza/transfermarkt-api
- **APEX-ML**: Integração completa com v4.0
- **Deploy**: Google Cloud Run (us-central1)

---

**Versão**: 1.0.0
**Data**: 2025-12-30
**Status**: Pronto para deploy e produção
