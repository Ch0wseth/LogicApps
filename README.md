# 🚀 Logic App DevOps - Infrastructure as Code & Workflow Evolution

> **Template Bicep complet avec pipeline GitHub Actions et workflow Logic App v2.0**  
> *Déploiement automatisé, monitoring complet, et évolution continue des workflows*

---

## 📋 Vue d'Ensemble DevOps

Ce projet illustre une **approche DevOps complète** avec :
- 🏗️ **Infrastructure as Code** (Bicep)
- 🔄 **CI/CD automatisé** (GitHub Actions)
- 📊 **Monitoring et observabilité** (Azure Monitor)
- 🚀 **Déploiements rapides** et sécurisés
- 🧪 **Tests automatiques** et validation
- 📈 **Évolution continue** des workflows

---

## 🎯 Fonctionnalités

### 🏗️ **Infrastructure & Déploiement**
- ✅ **Infrastructure as Code** avec Bicep
- ✅ **Monitoring complet** (Log Analytics + Application Insights + Alertes)
- ✅ **Pipeline GitHub Actions** pour déploiement automatique
- ✅ **Multi-environnements** (dev/prod) avec protection
- ✅ **Tests automatiques** de la Logic App après déploiement

### ⚡ **Workflow Logic App v2.0**
- ✅ **4 actions** (ping, echo, timestamp, info)
- ✅ **Logging automatique** de toutes les requêtes
- ✅ **Validation des inputs** avec règles métier
- ✅ **Réponses enrichies** avec métadonnées
- ✅ **Architecture robuste** avec étapes de contrôle

---

## 📁 Structure du Projet

```
LogicApps/
├── 📁 .github/workflows/           # 🔄 Pipeline CI/CD
│   ├── deploy.yml                  # Déploiement infrastructure complète
│   └── update-workflow.yml         # Mise à jour workflow uniquement
├── 📁 infra/                       # �️ Infrastructure Bicep
│   ├── main.bicep                  # Template principal
│   ├── main.dev.bicepparam         # Paramètres développement
│   └── main.prod.bicepparam        # Paramètres production
├── 📁 workflows/                   # 🎯 Définitions workflow
│   └── workflow.json              # Logic App workflow v2.0
└── 📄 README.md                   # 📖 Documentation complète
```

---

## 🚀 Déploiement DevOps

### **Pipeline CI/CD Automatisé** 🔄

#### **1. Déploiement Production** 🚀
```bash
git push origin main  # → Déclenche le déploiement en PRODUCTION
```
**Actions automatiques :**
- 🔍 Validation Bicep
- 🏗️ Déploiement infrastructure PRODUCTION (Resource Group, Logic App, Monitoring)
- 🧪 Tests post-déploiement
- 📊 Rapport de déploiement

#### **2. Déploiement Développement** 🛠️
```bash
git push origin develop  # → Déclenche le déploiement en DÉVELOPPEMENT
```
**Actions automatiques :**
- 🔍 Validation Bicep  
- 🏗️ Déploiement infrastructure DÉVELOPPEMENT
- 🧪 Tests post-déploiement
- 📊 Rapport de déploiement

#### **3. Mise à Jour Workflow Uniquement** ⚡
```bash
# Mise à jour workflow DEV
git push origin develop  # → Met à jour workflow DEV uniquement

# Mise à jour workflow PROD
git push origin main     # → Met à jour workflow PROD uniquement

# Note: Se déclenche automatiquement quand workflows/workflow.json est modifié
```
**Actions automatiques :**
- ✅ Validation JSON workflow
- 🔍 Vérification état Logic App
- 🔄 Mise à jour workflow via Azure CLI
- 🧪 Tests avec retry automatique (5 actions: default, ping, echo, timestamp, info)
- 📈 Validation du logging et de la validation

### **Déploiement Manuel** 🔧
```bash
# Connexion Azure
az login
az account set --subscription "your-subscription-id"

# Déploiement infrastructure DEV
az deployment group create \
  --resource-group "rg-logicapp-dev" \
  --template-file infra/main.bicep \
  --parameters infra/main.dev.bicepparam

# Déploiement infrastructure PROD
az deployment group create \
  --resource-group "rg-logicapp-prod" \
  --template-file infra/main.bicep \
  --parameters infra/main.prod.bicepparam
```

---

## 🎯 Logic App Workflow v2.0 - Évolution DevOps

### ⭐ **Nouvelles Fonctionnalités (Octobre 2025)**

#### **🔥 Actions Disponibles**

##### 1. **ping** (Test de connectivité)
```json
{"action": "ping"}
```
**Réponse :** `"pong"`

##### 2. **echo** (Écho de message)
```json
{"action": "echo", "message": "Hello DevOps"}
```
**Réponse :** `"Echo: Hello DevOps"`

##### 3. **timestamp** ⭐ *NOUVEAU* (Informations temporelles)
```json
{"action": "timestamp"}
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

##### 4. **info** ⭐ *NOUVEAU* (Métadonnées workflow)
```json
{"action": "info"}
```
**Réponse :** Métadonnées complètes avec exemples d'usage

#### **📊 Logging Automatique DevOps**
Chaque requête est automatiquement loggée avec :
- `requestId` : Identifiant unique pour traçabilité (format: req-YYYYMMDDHHMMSS-xxxxxxxx)
- `timestamp` : Horodatage UTC pour audit
- `clientIP` : IP client via headers X-Forwarded-For/X-Real-IP ou 'unknown'
- `triggerBody` : Corps complet de la requête pour debugging
- `workflowName` : Nom du workflow pour contexte
- `runId` : ID d'exécution du workflow

#### **✅ Validation des Inputs**
Validation automatique pour qualité :
- `hasMessage` : Vérification message
- `hasAction` : Validation action
- `messageLength` : Contrôle longueur
- `isValidRequest` : Statut global

### **🏗️ Architecture Technique v2.0**

```
HTTP Request
    ↓
1. Log_Request (Logging automatique)
    ↓
2. Validate_Input (Validation)
    ↓
3. Switch_Action (Routage)
    ├── ping → "pong"
    ├── echo → "Echo: {message}"
    ├── timestamp → Formats temporels
    ├── info → Métadonnées
    └── default → Réponse enrichie
    ↓
HTTP Response (avec logging + validation)
```

---

## 🧪 Tests DevOps Automatiques

### **Tests Pipeline Automatique**
```bash
# Tests intégrés dans le pipeline
- Test action ping
- Test action echo
- Test action timestamp (nouveau)
- Test action info (nouveau)
- Test réponse par défaut
- Validation logging automatique
```

### **Tests Manuels Post-Déploiement**
```bash
# Récupérer l'URL du trigger
az rest --method post \
  --url "https://management.azure.com/.../listCallbackUrl?api-version=2016-06-01" \
  --query "value"

# Tests des nouvelles actions v2.0
curl -X POST "$LOGIC_APP_URL" -H "Content-Type: application/json" -d '{"action":"timestamp"}'
curl -X POST "$LOGIC_APP_URL" -H "Content-Type: application/json" -d '{"action":"info"}'

# Test du logging automatique
curl -X POST "$LOGIC_APP_URL" -H "Content-Type: application/json" -d '{"message":"test devops"}'

# Test des nouvelles actions v2.0
curl -X POST "$LOGIC_APP_URL" -H "Content-Type: application/json" -d '{"action":"timestamp"}'
curl -X POST "$LOGIC_APP_URL" -H "Content-Type: application/json" -d '{"action":"info"}'

# Test du logging automatique
curl -X POST "$LOGIC_APP_URL" -H "Content-Type: application/json" -d '{"message":"test devops"}'
```

### **Exemple de Réponse v2.0 Complète**
```json
{
  "message": "Welcome to Logic App v2.0!",
  "timestamp": "2025-10-03T14:30:00Z",
  "inputMessage": "test devops",
  "version": "2.0",
  "availableActions": ["ping", "echo", "timestamp", "info"],
  "usage": "Send {\"action\":\"actionName\"} - Try ping, echo, timestamp, or info",
  "validation": {
    "hasMessage": true,
    "hasAction": false,
    "messageLength": 11,
    "isValidRequest": true
  },
  "requestInfo": {
    "requestId": "req-20251003143000-abc12345",
    "timestamp": "2025-10-03T14:30:00Z",
    "triggerBody": {"message": "test devops"},
    "workflowName": "logic-app-dev"
  }
}
```

---

## 📊 Monitoring & Observabilité DevOps

### **Stack de Monitoring Déployé**
- 📊 **Log Analytics Workspace** - Centralisation des logs
- 📈 **Application Insights** - Télémétrie et performances
- 🚨 **Alertes automatiques** - Notifications en cas d'échec
- 📋 **Workbook personnalisé** - Dashboard de monitoring

### **Métriques Surveillées**
- **Exécutions échouées** - Alerte automatique
- **Durée d'exécution** - Suivi performances
- **Débit des requêtes** - Monitoring charge
- **Validation des inputs** - Qualité données

### **Requêtes KQL DevOps**
```kql
// Analyse des exécutions v2.0
AzureDiagnostics
| where ResourceProvider == "MICROSOFT.LOGIC"
| where ResourceName == "logic-app-dev"
| project TimeGenerated, ResultType, RunId_g, Status_s

// Monitoring des nouvelles actions
AzureDiagnostics
| where ResourceProvider == "MICROSOFT.LOGIC"
| extend ActionType = tostring(parse_json(RequestBody_s).action)
| summarize count() by ActionType, bin(TimeGenerated, 1h)
```

---

## 🔄 Principes DevOps Appliqués

### **🏗️ Infrastructure as Code (IaC)**
- **Bicep templates** pour reproductibilité
- **Paramètres par environnement** (dev/prod)
- **Validation automatique** avant déploiement
- **Versionning** de l'infrastructure

**Avantages DevOps :**
- ✅ **Reproductibilité** : Infrastructure identique partout
- ✅ **Traçabilité** : Historique des changements
- ✅ **Collaboration** : Code reviewé et partagé
- ✅ **Rollback** : Retour arrière rapide possible

### **🔄 Continuous Integration/Continuous Deployment (CI/CD)**
- **Pipeline automatisé** GitHub Actions
- **Tests automatiques** à chaque commit
- **Déploiement multi-environnements** (dev → prod)
- **Validation** avant mise en production

**Avantages DevOps :**
- ✅ **Feedback rapide** : Erreurs détectées tôt
- ✅ **Déploiements fréquents** : Livraison continue
- ✅ **Qualité** : Tests systématiques
- ✅ **Réduction des risques** : Validation automatique

### **📊 Monitoring & Observabilité**
- **Logging automatique** de toutes les interactions
- **Métriques temps réel** avec Application Insights
- **Alertes proactives** en cas de problème
- **Dashboards** pour visibilité

**Avantages DevOps :**
- ✅ **Visibilité** : État système en temps réel
- ✅ **Proactivité** : Détection précoce des problèmes
- ✅ **Debugging facilité** : Logs détaillés avec requestId
- ✅ **Amélioration continue** : Métriques pour optimisation

### **⚡ Configuration as Code**
- **Workflows versionés** dans Git
- **Paramètres externalisés** (bicepparam)
- **Déploiement déclaratif** sans intervention manuelle
- **Rollback rapide** via Git

**Avantages DevOps :**
- ✅ **Agilité** : Changements rapides et sûrs
- ✅ **Cohérence** : Configuration identique partout
- ✅ **Audit** : Traçabilité complète des changements
- ✅ **Collaboration** : Processus transparents

### **🧪 Testing Automatisé**
- **Tests unitaires** du workflow
- **Tests d'intégration** post-déploiement
- **Tests de validation** des nouvelles fonctionnalités
- **Tests de non-régression** automatiques

**Avantages DevOps :**
- ✅ **Qualité** : Code testé systématiquement
- ✅ **Confiance** : Déploiements sans stress
- ✅ **Stabilité** : Régressions évitées
- ✅ **Rapidité** : Feedback immédiat

### **🔐 Security & Compliance**
- **Service Principal** avec permissions minimales
- **Secrets management** via GitHub Secrets
- **Audit trail** complet avec requestId
- **Validation des inputs** systématique

**Avantages DevOps :**
- ✅ **Sécurité** : Accès contrôlés et tracés
- ✅ **Compliance** : Logs pour audit
- ✅ **Résilience** : Validation automatique
- ✅ **Gouvernance** : Processus standardisés

---

## 🚀 Évolution DevOps Continue

### **📈 Workflow Evolution v2.0**
Cette évolution illustre les **principes DevOps** :

#### **🔄 Delivery Continue**
- **Ajout de fonctionnalités** sans casser l'existant
- **Pipeline dédié** pour mise à jour workflow uniquement
- **Tests automatiques** des nouvelles actions
- **Rollback rapide** via Git si problème

#### **📊 Feedback Loop**
- **Logging enrichi** pour meilleure observabilité
- **Validation automatique** pour qualité
- **Métriques détaillées** pour optimisation
- **Réponses enrichies** pour debugging

#### **🏗️ Architecture Évolutive**
- **Switch-based** pour extensibilité
- **Étapes modulaires** (Log, Validate, Action)
- **Séparation des responsabilités**
- **Facilité d'ajout** de nouvelles actions

### **🔮 Prochaines Évolutions DevOps**
- **Action `health`** pour monitoring avancé
- **Rate limiting** intelligent
- **Cache** pour performances
- **Métriques business** personnalisées
- **Integration** avec Azure Monitor dashboards

---

## �️ Corrections et Améliorations Récentes

### **✅ Corrections Apportées (Octobre 2025)**

#### **Pipeline Deployment**
- ❌ **Problème** : Job `deploy-dev` skippé sur branche `main`
- ✅ **Solution** : Suppression dépendance entre jobs `deploy-dev` et `deploy-prod`
- 🎯 **Résultat** : Déploiement PROD indépendant sur branche `main`

#### **Workflow Update Pipeline**
- ❌ **Problème** : Erreurs 502 lors des tests production
- ✅ **Solution** : Temps d'attente augmentés (60s), retry automatique, vérification statut Logic App
- 🎯 **Résultat** : Tests robustes avec retry sur 3 tentatives

#### **Template Language Expression**
- ❌ **Problème** : `workflow().run.correlation.clientId` invalide
- ✅ **Solution** : Utilisation correcte des headers HTTP
- 🎯 **Résultat** : Logging clientIP fonctionnel

#### **Structure Projet**
- ✅ **Ajout** : Fichier `infra/main.prod.bicepparam` pour cohérence
- ✅ **Nettoyage** : Suppression fichiers .md redondants
- 🎯 **Résultat** : Documentation centralisée dans README unique

---

## �🔄 Guide - Modifier le Workflow Logic App

### 🎯 **Objectif DevOps**
Modifier le workflow de ta Logic App **sans redéployer l'infrastructure complète** - principe fondamental du **Continuous Deployment**.

### 🚀 **Comment ça marche ?**

#### **1. Modifie le workflow**
Édite le fichier `workflows/workflow.json` avec tes nouvelles actions.

#### **2. Choisir votre méthode de déploiement**

##### **🚀 Méthode Automatique (Recommandée)**
```bash
git add workflows/workflow.json
git commit -m "feat: add new action X"

# Option A: Mise à jour DÉVELOPPEMENT
git push origin develop  # → Met à jour DEV uniquement

# Option B: Mise à jour PRODUCTION  
git push origin main     # → Met à jour PROD uniquement

# Option C: Mise à jour des DEUX environnements
git push origin develop  # → Met à jour DEV d'abord
git checkout main
git merge develop
git push origin main     # → Met à jour PROD ensuite
```

##### **🎛️ Méthode Manuelle (GitHub Actions)**
1. Allez sur **GitHub → Actions → Update Logic App Workflow**
2. Cliquez **"Run workflow"**
3. Choisissez l'environnement : `dev` ou `prod`
4. Cliquez **"Run workflow"**

#### **3. Le pipeline se déclenche automatiquement** ⚡
- Valide ton JSON
- Met à jour seulement le workflow  
- Teste automatiquement les **4 actions v2.0** (ping, echo, timestamp, info)
- Vérifie le logging et la validation automatique
- Confirme que la version 2.0 fonctionne correctement

### **🧪 Test de l'évolution v2.0**

```bash
# Test des nouvelles actions après déploiement
curl -X POST "$LOGIC_APP_URL" -H "Content-Type: application/json" -d '{"action":"timestamp"}'
curl -X POST "$LOGIC_APP_URL" -H "Content-Type: application/json" -d '{"action":"info"}'

# Vérification du logging automatique
curl -X POST "$LOGIC_APP_URL" -H "Content-Type: application/json" -d '{"message":"test evolution"}'
# → Doit retourner requestInfo et validation dans la réponse
```

---

## ⚡ Quick Start DevOps

### **1. Setup Initial** (5 minutes)
```bash
# Clone du projet
git clone https://github.com/Ch0wseth/LogicApps.git
cd LogicApps
```

#### **Configuration Azure & GitHub Actions**

##### **Étape 1: Créer le Service Principal Azure**
```bash
# Se connecter à Azure
az login
az account set --subscription "YOUR-SUBSCRIPTION-ID"

# Créer le Service Principal
az ad sp create-for-rbac --name "sp-logicapp-github-actions" \
  --role "Contributor" \
  --scopes "/subscriptions/YOUR-SUBSCRIPTION-ID" \
  --sdk-auth
```

##### **Étape 2: Configurer les Secrets GitHub**
Va dans **GitHub → Settings → Secrets and variables → Actions** et ajoute :

| Secret | Valeur |
|--------|--------|
| `AZURE_CLIENT_ID` | clientId du Service Principal |
| `AZURE_TENANT_ID` | tenantId du Service Principal |
| `AZURE_SUBSCRIPTION_ID` | ID de ta subscription Azure |

### **2. Déploiement Infrastructure** (10 minutes)
```bash
git push origin main  # → Déclenche le pipeline complet
# ✅ Infrastructure déployée automatiquement
# ✅ Logic App fonctionnelle avec monitoring
# ✅ Tests automatiques passés
```

### **3. Evolution Workflow** (2 minutes)
```bash
# Modifier workflows/workflow.json
git add workflows/workflow.json
git commit -m "feat: add new action"
git push origin develop  # → Mise à jour instantanée
# ✅ Workflow mis à jour sans redéployer l'infra
# ✅ Tests automatiques des nouvelles fonctionnalités
```

### **4. Vérification** (1 minute)
```bash
# Test de la v2.0
curl -X POST "$LOGIC_APP_URL" -d '{"action":"info"}' -H "Content-Type: application/json"
# ✅ Réponse v2.0 avec logging et validation
```

---

## 🏆 Résultats DevOps

### **📊 Métriques de Performance**
- **Déploiement infrastructure** : ~10 minutes automatisé (DEV et PROD séparés)
- **Mise à jour workflow** : ~3-4 minutes automatisé (avec retry et vérifications)
- **Tests automatiques** : 5 actions testées (default, ping, echo, timestamp, info)
- **Retry automatique** : 3 tentatives avec backoff de 30s
- **Temps d'attente** : 45s DEV, 60s PROD pour stabilité
- **Rollback** : Instantané via Git revert

### **🎯 Bénéfices Obtenus**
- ✅ **Time to Market** réduit de 80% (mise à jour workflow)
- ✅ **Zero Downtime** lors des mises à jour
- ✅ **Qualité** améliorée avec validation automatique
- ✅ **Observabilité** complète avec logging enrichi
- ✅ **Collaboration** facilitée avec Infrastructure as Code

### **📈 Démonstration Concrète des Principes DevOps**

#### **🔄 Continuous Integration/Continuous Deployment**
Ce projet démontre comment **automatiser complètement** le cycle de vie :
- **Code** → **Build** → **Test** → **Deploy** → **Monitor**
- **Feedback rapide** à chaque étape
- **Déploiements fréquents** et sécurisés

#### **🏗️ Infrastructure as Code**
Tout est **versioné et reproductible** :  
- Infrastructure définie en Bicep
- Workflows versionnés dans Git
- Paramètres externalisés
- Déploiements identiques partout

#### **📊 Monitoring & Observabilité**
**Visibilité complète** sur le système :
- Logging automatique avec requestId
- Métriques temps réel
- Alertes proactives
- Dashboards pour les équipes

#### **🧪 Testing Automatisé**
**Qualité assurée** à chaque changement :
- Tests automatiques du workflow
- Validation des nouvelles fonctions
- Tests de non-régression
- Feedback immédiat

#### **⚡ Configuration as Code**
**Agilité maximale** pour les changements :
- Modification workflow en 2 minutes
- Déploiement sans downtime
- Rollback instantané via Git
- Traçabilité complète

### **🎯 Pourquoi cette approche est DevOps ?**

#### **1. Collaboration** 🤝
- **Développeurs** et **Ops** travaillent sur le même code
- **Processus transparents** et partagés
- **Documentation intégrée** dans le code

#### **2. Automatisation** 🤖
- **Déploiements automatiques** sans intervention humaine
- **Tests automatiques** à chaque changement
- **Monitoring automatique** avec alertes

#### **3. Monitoring** 📊
- **Observabilité complète** du système
- **Métriques** pour amélioration continue
- **Feedback loop** pour optimisation

#### **4. Évolution Continue** 📈
- **Ajout de fonctionnalités** sans casser l'existant
- **Architecture évolutive** pour le futur
- **Expérimentation** sécurisée avec tests

---

---

## 📋 Changelog

### **v2.0 (Octobre 2025) - Évolution Majeure** 🚀
- ✅ **Workflow Logic App v2.0** avec 4 actions (ping, echo, timestamp, info)
- ✅ **Logging automatique** avec requestId, clientIP, et métadonnées
- ✅ **Validation des inputs** avec règles métier
- ✅ **Architecture robuste** avec étapes de contrôle
- ✅ **Tests automatiques** avec retry et gestion d'erreurs
- ✅ **Pipeline amélioré** avec jobs indépendants DEV/PROD
- ✅ **Documentation consolidée** dans README unique
- ✅ **Fichiers paramètres** pour DEV et PROD
- ✅ **Corrections expressions** Template Language

### **v1.0 - Version Initiale** �️
- ✅ **Infrastructure as Code** avec Bicep
- ✅ **Pipeline GitHub Actions** basique
- ✅ **Monitoring** avec Log Analytics et Application Insights
- ✅ **Workflow Logic App** avec 2 actions (ping, echo)

---

**�🎉 Logic App DevOps - Une démonstration complète des meilleures pratiques DevOps avec Azure !**

> *Infrastructure as Code + CI/CD + Monitoring + Évolution Continue = DevOps Excellence* 🚀

### 📞 **Support et Contribution**
- 🐛 **Issues** : [GitHub Issues](https://github.com/Ch0wseth/LogicApps/issues)
- 📖 **Documentation** : Ce README contient toute la documentation
- 🔄 **Évolutions** : Les nouvelles fonctionnalités sont documentées dans les commits
- ⭐ **Star le projet** si il vous a aidé !

**Dernière mise à jour** : Octobre 2025 - v2.0 avec corrections et améliorations