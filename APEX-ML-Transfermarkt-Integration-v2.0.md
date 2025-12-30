# APEX-ML Transfermarkt Integration v2.0

## Visão Geral

A integração APEX-ML com Transfermarkt fornece análise avançada de dados de futebol para análise de apostas esportivas e estatísticas de desempenho de jogadores.

### Objetivos Principais

- **Coleta de Dados**: Integração com API do Transfermarkt para dados em tempo real
- **Análise Avançada**: Machine learning para padrões de desempenho
- **Previsões**: Modelos preditivos para resultados e performance
- **Integração**: Conexão com sistemas APEX-ML existentes

## Arquitetura do Sistema

```
┌─────────────────────────────────────────┐
│     APEX-ML Transfermarkt v2.0          │
├─────────────────────────────────────────┤
│  Frontend (React/Vue) → API Gateway      │
│  │                                       │
│  ├─→ Data Collection Service             │
│  │   └─→ Transfermarkt API               │
│  │       └─→ Player Statistics           │
│  │       └─→ Match Data                  │
│  │       └─→ Team Performance            │
│  │                                       │
│  ├─→ ML Processing Engine                │
│  │   └─→ Feature Engineering             │
│  │   └─→ Model Training                  │
│  │   └─→ Prediction Service              │
│  │                                       │
│  ├─→ Database Layer                      │
│  │   └─→ PostgreSQL/MongoDB              │
│  │   └─→ Redis Cache                     │
│  │                                       │
│  └─→ Analytics Dashboard                 │
│      └─→ Real-time Metrics               │
│      └─→ Performance Charts              │
└─────────────────────────────────────────┘
```

## Instalação

### Pré-requisitos

- Node.js v18+
- Python 3.9+
- Docker & Docker Compose
- PostgreSQL 13+
- Redis 6+

### Passos de Instalação

#### 1. Clone o Repositório

```bash
git clone https://github.com/newjsouza/transfermarkt-api.git
cd transfermarkt-api
```

#### 2. Configuração de Variáveis de Ambiente

Crie um arquivo `.env.local`:

```env
TRANSFERMARKT_API_KEY=seu_api_key_aqui
TRANSFERMARKT_BASE_URL=https://www.transfermarkt.com

# Database
DB_HOST=localhost
DB_PORT=5432
DB_NAME=apex_ml_transfermarkt
DB_USER=apex_user
DB_PASSWORD=senha_segura

# Redis
REDIS_HOST=localhost
REDIS_PORT=6379

# ML Model
ML_MODEL_PATH=./models/apex_ml_v2.pkl
MODEL_UPDATE_INTERVAL=86400  # 24 hours

# API
API_PORT=3000
API_HOST=0.0.0.0
NODE_ENV=development
```

#### 3. Instalação de Dependências

```bash
# JavaScript/Node.js
npm install

# Python (Machine Learning)
pip install -r requirements.txt

# Docker
docker-compose up -d
```

#### 4. Inicialização do Banco de Dados

```bash
# Criar banco de dados
npm run db:create

# Executar migrations
npm run db:migrate

# Seed de dados iniciais
npm run db:seed
```

## Configuração

### Autenticação Transfermarkt

1. Registre-se em Transfermarkt Developer
2. Obtenha sua API Key
3. Adicione ao `.env` como `TRANSFERMARKT_API_KEY`

### Configuração de Machine Learning

```python
# config/ml_config.py

ML_CONFIG = {
    'models': {
        'player_performance': {
            'type': 'ensemble',
            'estimators': ['xgboost', 'random_forest', 'neural_network'],
            'weights': [0.4, 0.35, 0.25]
        },
        'match_prediction': {
            'type': 'deep_learning',
            'architecture': 'transformer',
            'lookback_window': 10  # matches
        }
    },
    'features': {
        'player': ['age', 'position', 'market_value', 'minutes_played', 'goals', 'assists'],
        'team': ['strength', 'form', 'tactics', 'injuries', 'home_advantage']
    },
    'training': {
        'test_split': 0.2,
        'validation_split': 0.1,
        'epochs': 100,
        'batch_size': 32
    }
}
```

## Documentação de API

### Endpoints Principais

#### 1. Obter Dados de Jogador

```bash
GET /api/v2/players/:player_id
```

**Resposta:**

```json
{
  "status": "success",
  "data": {
    "player_id": "123456",
    "name": "João Silva",
    "position": "Forward",
    "current_team": "FC Porto",
    "market_value": 45000000,
    "statistics": {
      "matches_played": 28,
      "goals": 12,
      "assists": 5,
      "minutes_played": 2340,
      "yellow_cards": 3,
      "red_cards": 0
    },
    "form": [
      { "date": "2024-01-15", "rating": 8.2, "goals": 1 },
      { "date": "2024-01-08", "rating": 7.5, "goals": 0 }
    ]
  }
}
```

#### 2. Previsão de Performance

```bash
POST /api/v2/predictions/player-performance
Content-Type: application/json

{
  "player_id": "123456",
  "match_id": "789012",
  "prediction_type": "goals_assists"
}
```

**Resposta:**

```json
{
  "status": "success",
  "data": {
    "player_id": "123456",
    "match_id": "789012",
    "predictions": {
      "goals": {
        "expected_value": 1.2,
        "confidence": 0.82,
        "probability_distribution": [0.15, 0.35, 0.28, 0.15, 0.07]
      },
      "assists": {
        "expected_value": 0.45,
        "confidence": 0.76
      },
      "minutes_played": {
        "expected_value": 72,
        "confidence": 0.89
      }
    }
  }
}
```

#### 3. Análise de Padrões

```bash
GET /api/v2/analysis/player-patterns/:player_id?season=2023-2024
```

**Resposta:**

```json
{
  "status": "success",
  "data": {
    "player_id": "123456",
    "patterns": {
      "home_away_split": {
        "home": { "goals_per_game": 0.65, "assists_per_game": 0.25 },
        "away": { "goals_per_game": 0.45, "assists_per_game": 0.15 }
      },
      "opponent_strength_correlation": 0.68,
      "optimal_lineup_position": "RW",
      "injury_risk_score": 0.12
    }
  }
}
```

## Exemplos de Uso

### JavaScript/Node.js

```javascript
const axios = require('axios');

const api = axios.create({
  baseURL: 'http://localhost:3000/api/v2',
  headers: {
    'Authorization': `Bearer ${process.env.API_TOKEN}`,
    'Content-Type': 'application/json'
  }
});

// Obter dados de jogador
async function getPlayerData(playerId) {
  try {
    const response = await api.get(`/players/${playerId}`);
    return response.data.data;
  } catch (error) {
    console.error('Erro ao obter dados do jogador:', error);
  }
}

// Obter previsão
async function getPrediction(playerId, matchId) {
  try {
    const response = await api.post('/predictions/player-performance', {
      player_id: playerId,
      match_id: matchId,
      prediction_type: 'goals_assists'
    });
    return response.data.data.predictions;
  } catch (error) {
    console.error('Erro na previsão:', error);
  }
}

// Uso
(async () => {
  const playerData = await getPlayerData('123456');
  console.log('Player:', playerData.name);
  
  const prediction = await getPrediction('123456', '789012');
  console.log('Expected Goals:', prediction.goals.expected_value);
})();
```

### Python

```python
import requests
from apex_ml_transfermarkt import APEXMLClient

# Inicializar cliente
client = APEXMLClient(
    base_url='http://localhost:3000/api/v2',
    api_token=os.getenv('API_TOKEN')
)

# Obter dados de múltiplos jogadores
player_ids = ['123456', '234567', '345678']
players_data = client.get_players(player_ids)

# Análise de padrões
patterns = client.analyze_patterns(player_id='123456', season='2023-2024')

for pattern_name, pattern_data in patterns.items():
    print(f"{pattern_name}: {pattern_data}")

# Batch predictions
match_data = [
    {'player_id': '123456', 'match_id': '789012'},
    {'player_id': '234567', 'match_id': '789012'}
]

predictions = client.batch_predict(match_data)

for pred in predictions:
    print(f"Player {pred['player_id']}: {pred['predictions']['goals']['expected_value']} expected goals")
```

## Monitoramento e Logging

### Estrutura de Logs

```bash
# Ativar logs detalhados
export LOG_LEVEL=debug

# Arquivos de log
logs/
├── app.log          # Logs gerais da aplicação
├── ml_training.log  # Logs de treinamento de modelos
├── api.log          # Logs de requisições API
└── errors.log       # Erros e exceções
```

### Métricas Prometheus

```yaml
# prometheus.yml
scrape_configs:
  - job_name: 'apex-ml-transfermarkt'
    static_configs:
      - targets: ['localhost:9090']
    scrape_interval: 15s
```

## Troubleshooting

### Problema: Conexão com Transfermarkt recusada

**Solução:**
1. Verificar API Key no `.env`
2. Confirmar IP na whitelist do Transfermarkt
3. Testar conexão: `curl https://www.transfermarkt.com/api/test`

### Problema: Modelo ML não converge

**Solução:**
1. Aumentar `epochs` na configuração
2. Ajustar `learning_rate`
3. Normalizar features de entrada
4. Verificar dataset para outliers

## Atualização de Modelos

```bash
# Atualizar modelo manualmente
npm run ml:train

# Avaliar performance
npm run ml:evaluate

# Deploy novo modelo
npm run ml:deploy
```

## Suporte

- **Issues**: https://github.com/newjsouza/transfermarkt-api/issues
- **Email**: apostasnewjsouza@gmail.com
- **Discord**: [APEX-ML Community](https://discord.gg/apexml)

---

**Versão**: 2.0.0
**Última Atualização**: 2024
**Licença**: MIT
