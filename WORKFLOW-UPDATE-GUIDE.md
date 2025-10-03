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
- Teste automatiquement les nouvelles fonctionnalités

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