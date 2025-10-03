# 🔄 Guide - Modifier le Workflow Logic App

## 🎯 Objectif
Modifier le workflow de ta Logic App **sans redéployer l'infrastructure complète**.

## 🚀 Comment ça marche ?

### 1. **Modifie le workflow**
Édite le fichier `workflows/workflow.json` avec tes nouvelles actions.

### 2. **Push tes changements**  
```bash
git add workflows/workflow.json
git commit -m "feat: add new action X"
git push origin develop  # → Met à jour DEV
# ou
git push origin main     # → Met à jour DEV puis PROD
```

### 3. **Le pipeline se déclenche automatiquement** ⚡
- Valide ton JSON
- Met à jour seulement le workflow  
- Teste automatiquement les **4 actions v2.0** (ping, echo, timestamp, info)
- Vérifie le logging et la validation automatique
- Confirme que la version 2.0 fonctionne correctement

## 🧪 **Test de l'évolution v2.0**

```bash
# Test des nouvelles actions après déploiement
curl -X POST "$LOGIC_APP_URL" -H "Content-Type: application/json" -d '{"action":"timestamp"}'
curl -X POST "$LOGIC_APP_URL" -H "Content-Type: application/json" -d '{"action":"info"}'

# Vérification du logging automatique
curl -X POST "$LOGIC_APP_URL" -H "Content-Type: application/json" -d '{"message":"test evolution"}'
# → Doit retourner requestInfo et validation dans la réponse
```

## 📝 Structure du workflow actuel

### Actions disponibles :

#### 1. **Action par défaut** (aucune action spécifiée)
```json
{
  "message": "Hello World"
}
```
**Réponse :**
```json
{
  "message": "Hello from Logic App!",
  "timestamp": "2025-10-03T06:00:00Z",
  "inputMessage": "Hello World",  
  "availableActions": ["ping", "echo"],
  "usage": "Send {\"action\":\"ping\"} or {\"action\":\"echo\", \"message\":\"your message\"}"
}
```

#### 2. **Action "ping"**
```json
{
  "action": "ping"
}
```
**Réponse :** `"pong"`

#### 3. **Action "echo"**
```json
{
  "action": "echo",
  "message": "Hello World"
}
```
**Réponse :** `"Echo: Hello World"`

---

## 🎯 **WORKFLOW v2.0 - ÉVOLUTION MAJEURE** ⭐

### ✨ Nouvelles Fonctionnalités (Octobre 2025)

#### 4. **Action "timestamp"** 🆕
```json
{
  "action": "timestamp"
}
```
**Réponse :**
```json
{
  "currentTime": "2025-10-03T14:30:00Z",
  "timezone": "UTC",
  "unixTimestamp": 1728048600,
  "formatted": {
    "iso": "2025-10-03T14:30:00Z",
    "readable": "October 3, 2025 at 2:30 PM UTC",
    "date": "2025-10-03",
    "time": "14:30:00"
  }
}
```

#### 5. **Action "info"** 🆕
```json
{
  "action": "info"
}
```
**Réponse :** Métadonnées complètes du workflow avec exemples d'usage

### 🔧 **Architecture v2.0**

#### **Étapes de Logging et Validation**

##### 1. **Log_Request** (Automatique)
- Génère un `requestId` unique
- Enregistre le timestamp de la requête
- Capture l'IP client (si disponible)
- Stocke le corps de la requête complète

##### 2. **Validate_Input** (Automatique)
- Vérifie la présence d'un message
- Valide l'action demandée
- Contrôle la longueur du message
- Détermine si la requête est valide

##### 3. **Switch_Action** (Amélioré)
- **4 actions** disponibles (ping, echo, timestamp, info)
- Réponses enrichies avec métadonnées
- Gestion d'erreurs améliorée

### 📊 **Réponse Enrichie par Défaut**

Toutes les réponses incluent maintenant :
```json
{
  "message": "Welcome to Logic App v2.0!",
  "timestamp": "2025-10-03T14:30:00Z",
  "version": "2.0",
  "availableActions": ["ping", "echo", "timestamp", "info"],
  "validation": {
    "hasMessage": true,
    "hasAction": true,
    "messageLength": 12,
    "isValidRequest": true
  },
  "requestInfo": {
    "requestId": "req-20251003143000-abc12345",
    "timestamp": "2025-10-03T14:30:00Z",
    "workflowName": "logic-app-dev"
  }
}
```

---

## 🚀 **Migration vers v2.0**

### **Changements Incompatibles**
- ⚠️ Format de réponse enrichi (nouvelles propriétés)
- ⚠️ Étapes de logging automatique ajoutées
- ⚠️ Validation des inputs activée

### **Nouvelles Capacités**
- ✅ 4 actions disponibles au lieu de 2
- ✅ Logging automatique de toutes les requêtes
- ✅ Validation des inputs avec règles métier
- ✅ Réponses avec métadonnées complètes
- ✅ Architecture plus robuste

---
**Réponse :**
```json
{
  "status": "pong",
  "timestamp": "2025-10-03T06:00:00Z",
  "message": "Logic App is alive!",
  "version": "1.0"
}
```

#### 3. **Action "echo"**
```json
{
  "action": "echo",
  "message": "Test message"
}
```
**Réponse :**
```json
{
  "status": "echo",
  "timestamp": "2025-10-03T06:00:00Z", 
  "original_message": "Test message",
  "echoed_message": "ECHO: Test message"
}
```

## 🛠️ Ajouter une nouvelle action

### Exemple : Action "reverse"
```json
"reverse": {
  "case": "reverse",
  "actions": {
    "Reverse_Response": {
      "type": "Response",
      "kind": "Http",
      "inputs": {
        "statusCode": 200,
        "body": {
          "status": "reversed",
          "timestamp": "@utcNow()",
          "original": "@triggerBody()?['message']",
          "reversed": "@reverse(triggerBody()?['message'])"
        }
      }
    }
  }
}
```

### Exemple : Action "uppercase"
```json
"uppercase": {
  "case": "uppercase", 
  "actions": {
    "Uppercase_Response": {
      "type": "Response",
      "kind": "Http",
      "inputs": {
        "statusCode": 200,
        "body": {
          "status": "uppercase",
          "timestamp": "@utcNow()",
          "original": "@triggerBody()?['message']",
          "uppercase": "@toUpper(triggerBody()?['message'])"
        }
      }
    }
  }
}
```

## 🧪 Tests automatiques

Le pipeline teste automatiquement :
- ✅ Syntaxe JSON valide
- ✅ Structure du workflow correcte  
- ✅ Action par défaut
- ✅ Action ping
- ✅ Action echo
- ✅ Tes nouvelles actions (ajoute tes propres tests!)

## 🔄 Workflow de développement

### Développement rapide :
```bash
# 1. Modifie workflows/workflow.json
code workflows/workflow.json

# 2. Test en local (optionnel)
jq . workflows/workflow.json  # Valide JSON

# 3. Push sur develop  
git add workflows/workflow.json
git commit -m "feat: add reverse action"
git push origin develop

# 4. Regarde le pipeline tourner dans GitHub Actions
# 5. Teste ton workflow mis à jour !
```

### Déploiement production :
```bash
git checkout main
git merge develop
git push origin main  # → Déploie en PROD après validation
```

## 💡 Avantages de cette approche

- ⚡ **Ultra-rapide** : 2-3 min vs 10+ min pour l'infra complète
- 🎯 **Ciblé** : Change seulement ce qui doit changer
- 🧪 **Testé** : Validation automatique à chaque changement
- 🔄 **Réversible** : Facile de revenir en arrière
- 📊 **Traçable** : Historique Git de tous les changements

## 🚀 Prêt à tester ?

Modifie `workflows/workflow.json` et push tes changements ! 

Le pipeline **"Update Logic App Workflow"** se déclenchera automatiquement ! 🎉