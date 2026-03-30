# 💓 PulseNet — The Emotional Internet

Real-time emotional intelligence platform. People share how they feel, Claude AI classifies the emotion, and it appears live on a world map.

---

## Quick start

### Option A — One command (recommended)

```bash
cp backend/.env.example backend/.env
# Edit backend/.env → add your ANTHROPIC_API_KEY

chmod +x start.sh
./start.sh
```

Open **http://localhost:3000**

---

### Option B — Manual

**Backend**
```bash
cd backend
cp .env.example .env          # fill in ANTHROPIC_API_KEY
python3 -m venv venv
source venv/bin/activate      # Windows: venv\Scripts\activate
pip install -r requirements.txt
python app.py
```

**Frontend** (new terminal)
```bash
cd frontend
npm install
npm run dev
```

---

## Stack

| Layer    | Tech                                     |
|----------|------------------------------------------|
| Backend  | Python · Flask · SQLite · Anthropic SDK  |
| Frontend | React 18 · Vite · Leaflet                |
| AI       | Claude claude-sonnet-4-5 (emotion analysis)       |

---

## Project structure

```
pulsenet/
├── start.sh                ← boots both servers at once
├── .gitignore
├── README.md
│
├── backend/
│   ├── app.py              ← Flask routes
│   ├── analyzer.py         ← Claude emotion classification
│   ├── database.py         ← SQLite helpers
│   ├── requirements.txt
│   └── .env.example
│
└── frontend/
    ├── index.html
    ├── vite.config.js      ← proxies /api → localhost:5000
    └── src/
        ├── App.jsx          ← root component, data polling, error banner
        ├── App.css          ← dark mission-control theme
        ├── api.js           ← axios helpers, city list, emotion colours
        └── components/
            ├── Header.jsx
            ├── PulseSubmit.jsx  ← submit form + Claude result
            ├── LiveFeed.jsx     ← scrolling pulse feed + skeleton
            ├── EmotionMap.jsx   ← Leaflet world map
            ├── StatsPanel.jsx   ← emotion breakdown + skeleton
            └── ErrorBoundary.jsx
```

---

## API

| Method | Path        | Body / Params            | Description              |
|--------|-------------|--------------------------|--------------------------|
| POST   | /api/pulse  | `{text, city, lat, lng}` | Submit & analyse a pulse |
| GET    | /api/pulses | `?limit=50`              | Recent pulses            |
| GET    | /api/stats  |                          | Emotion counts + avg     |
| GET    | /api/map    |                          | Latest pulse per city    |
| GET    | /api/health |                          | Health check             |

### Example request

```bash
curl -X POST http://localhost:5000/api/pulse \
  -H "Content-Type: application/json" \
  -d '{"text":"I just got promoted!","city":"Nairobi","latitude":-1.29,"longitude":36.82}'
```

```json
{ "emotion": "joy", "intensity": 0.94, "summary": "Elated career milestone." }
```

---

## What to build next

- **WebSockets** — push new pulses to all clients instantly (Flask-SocketIO)
- **User accounts** — personal mood history & streaks
- **City heatmaps** — rolling 24h emotion average per city
- **Trend alerts** — notify when a city's dominant emotion flips
- **Public API** — let other apps tap into the emotional layer
- **Mobile app** — React Native + device GPS for auto-location
