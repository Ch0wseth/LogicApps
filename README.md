# Logic App - Infrastructure as Code avec GitHub Actions

Template Bicep complet pour déployer une Azure Logic App avec monitoring et pipeline GitHub Actions automatisé.

## 🚀 Fonctionnalités

- ✅ **Infrastructure as Code** avec Bicep
- ✅ **Monitoring complet** (Log Analytics + Application Insights + Alertes)
- ✅ **Pipeline GitHub Actions** pour déploiement automatique
- ✅ **Multi-environnements** (dev/prod) avec protection
- ✅ **Tests automatiques** de la Logic App après déploiement

## 📁 Structure du projet

```
LogicApps/
├── 📁 .github/workflows/        # Pipeline GitHub Actions
│   └── deploy.yml               # Déploiement automatique
├── 📁 infra/                    # Infrastructure Bicep
│   ├── main.bicep              # Template principal avec monitoring
│   └── main.dev.bicepparam     # Paramètres développement
├── � README.md                # Cette documentation
└── 📄 SETUP-GITHUB-ACTIONS.md  # Guide de configuration
```

## 🎯 Déploiement

### Option 1: GitHub Actions (Recommandé) 🚀
1. **Configure Azure & GitHub** : Suis le guide `SETUP-GITHUB-ACTIONS.md`
2. **Push sur develop** → Déploie automatiquement en DEV
3. **Push sur main** → Déploie automatiquement en DEV puis PROD

### Option 2: Déploiement manuel 🔧
```bash
# Se connecter à Azure
az login
az account set --subscription "ton-subscription-id"

# Créer le resource group  
az group create --name "rg-logicapp-dev" --location "West Europe"

# Déployer l'infrastructure
cd infra
az deployment group create \
  --resource-group "rg-logicapp-dev" \
  --template-file main.bicep \
  --parameters @main.dev.bicepparam
```

## 🧪 Tester ta Logic App

```bash
# Récupérer l'URL du trigger
az rest --method post \
  --url "https://management.azure.com/subscriptions/SUBSCRIPTION-ID/resourceGroups/rg-logicapp-dev/providers/Microsoft.Logic/workflows/logicapp-webhook-dev/triggers/manual/listCallbackUrl?api-version=2016-06-01" \
  --query "value"

# Tester avec curl (nouvelles actions v2.0)
curl -X POST "https://prod-xx.westeurope.logic.azure.com/..." \
  -H "Content-Type: application/json" \
  -d '{"action":"timestamp"}'

curl -X POST "https://prod-xx.westeurope.logic.azure.com/..." \
  -H "Content-Type: application/json" \
  -d '{"action":"info"}'
```

## 🎯 Workflow Logic App v2.0 - Évolution Majeure

### ✨ Nouvelles Fonctionnalités (Octobre 2025)

#### **4 Actions Disponibles :**
1. **ping** - Test de connectivité
2. **echo** - Écho de message
3. **timestamp** ⭐ *NOUVEAU* - Informations temporelles complètes
4. **info** ⭐ *NOUVEAU* - Métadonnées du workflow

#### **Logging Automatique** 📊
Chaque requête est automatiquement loggée avec :
- `requestId` unique
- `timestamp` de la requête
- `clientIP` (si disponible)
- Corps de la requête complet

#### **Validation des Inputs** ✅
Validation automatique :
- Vérification de la présence du message
- Validation de l'action demandée
- Contrôle de la longueur du message
- Statut de validité global

### 🧪 Tests des nouvelles actions v2.0

```powershell
# Action timestamp - Retourne l'heure sous plusieurs formats
$response = Invoke-RestMethod -Uri $triggerUrl -Method Post \
  -Body '{"action":"timestamp"}' -ContentType "application/json"
# Retourne: currentTime, timezone, unixTimestamp, formatted {...}

# Action info - Métadonnées complètes du workflow
$response = Invoke-RestMethod -Uri $triggerUrl -Method Post \
  -Body '{"action":"info"}' -ContentType "application/json"
# Retourne: workflow details, actions disponibles, exemples d'usage

# Réponse enrichie par défaut (version 2.0)
$response = Invoke-RestMethod -Uri $triggerUrl -Method Post \
  -Body '{"message":"test"}' -ContentType "application/json"
# Inclut maintenant: validation, requestInfo, version 2.0
```

### 📋 Exemple de réponse complète v2.0

```json
{
  "message": "Welcome to Logic App v2.0!",
  "timestamp": "2025-10-03T14:30:00Z",
  "inputMessage": "test message",
  "version": "2.0",
  "availableActions": ["ping", "echo", "timestamp", "info"],
  "usage": "Send {\"action\":\"actionName\"} - Try ping, echo, timestamp, or info",
  "validation": {
    "hasMessage": true,
    "hasAction": false,
    "messageLength": 12,
    "isValidRequest": true
  },
  "requestInfo": {
    "requestId": "req-20251003143000-abc12345",
    "timestamp": "2025-10-03T14:30:00Z",
    "triggerBody": {"message": "test message"},
    "workflowName": "logic-app-dev"
  }
}
```

## 📊 Ce que déploie le template

### 🎯 Logic App
- **Workflow simple** : HTTP trigger → Response avec timestamp
- **Identité managée** pour la sécurité
- **Configuration optimisée**

### 📊 Monitoring complet
- **Log Analytics Workspace** - Centralisation des logs
- **Application Insights** - Télémétrie et performances  
- **Alertes automatiques** - Notifications en cas d'échec
- **Workbook personnalisé** - Dashboard de monitoring
- ✅ **Alerte métrique** - Détection des échecs d'exécution
- ✅ **Workbook personnalisé** - Dashboard de monitoring

## 🚀 Déploiement

### Prérequis
- Azure CLI ou Azure PowerShell
- Extension Bicep installée
- Connexion à un abonnement Azure

### Déploiement avec Azure PowerShell

```powershell
# Connexion à Azure
Connect-AzAccount

# Création du groupe de ressources
New-AzResourceGroup -Name "rg-logicapp-dev" -Location "France Central"

# Validation du template
Test-AzResourceGroupDeployment `
  -ResourceGroupName "rg-logicapp-dev" `
  -TemplateFile "./infra/main.bicep" `
  -TemplateParameterFile "./infra/main.dev.bicepparam"

# Aperçu des modifications (What-If)
Get-AzResourceGroupDeploymentWhatIfResult `
  -ResourceGroupName "rg-logicapp-dev" `
  -TemplateFile "./infra/main.bicep" `
  -TemplateParameterFile "./infra/main.dev.bicepparam"

# Déploiement
New-AzResourceGroupDeployment `
  -ResourceGroupName "rg-logicapp-dev" `
  -TemplateFile "./infra/main.bicep" `
  -TemplateParameterFile "./infra/main.dev.bicepparam"
```

## 📊 Monitoring et alertes

### Métriques surveillées
- **Exécutions échouées** - Alerte automatique
- **Durée d'exécution** - Suivi des performances
- **Débit des requêtes** - Monitoring de la charge

### Logs collectés
- **WorkflowRuntime** - Détails des exécutions
- **Métriques système** - Performance et utilisation

### Dashboard personnalisé
Un workbook Azure Monitor est automatiquement créé avec :
- Graphiques des exécutions par heure
- Analyse des échecs et succès
- Métriques de performance

## ⚙️ Configuration

### Personnalisation des paramètres

Modifiez le fichier `main.dev.bicepparam` pour adapter :
- Nom de la Logic App
- Période de rétention des logs
- Tags et métadonnées

### Notification des alertes

Par défaut, les alertes sont envoyées à `admin@company.com`. 
Modifiez cette adresse dans le template `main.bicep` :

```bicep
emailReceivers: [
  {
    name: 'EmailAlert'
    emailAddress: 'votre-email@company.com' // ← Modifier ici
    useCommonAlertSchema: true
  }
]
```

## 🔧 Workflow Logic App

Le workflow déployé est un exemple basique qui :
1. ✅ Reçoit une requête HTTP POST
2. ✅ Extrait le message du body JSON
3. ✅ Retourne une réponse avec timestamp

### Test du workflow

```powershell
# Récupérer l'URL de trigger après déploiement
$triggerUrl = (Get-AzLogicAppTriggerCallbackUrl -ResourceGroupName "rg-logicapp-dev" -Name "logicapp-demo-dev" -TriggerName "manual").Value

# Tester la Logic App
$body = @{ message = "Hello Logic App!" } | ConvertTo-Json
Invoke-RestMethod -Uri $triggerUrl -Method Post -Body $body -ContentType "application/json"
```

## 🏷️ Bonnes pratiques implémentées

### Sécurité
- ✅ Identité managée système
- ✅ Pas de secrets dans le code
- ✅ Configuration RBAC recommandée

### Monitoring
- ✅ Logs centralisés dans Log Analytics
- ✅ Métriques dans Application Insights
- ✅ Alertes proactives
- ✅ Dashboard personnalisé

### Déploiement
- ✅ Infrastructure as Code
- ✅ Paramètres de développement
- ✅ Validation avant déploiement
- ✅ Tags et métadonnées

### Nomenclature
- ✅ Convention de nommage cohérente
- ✅ Préfixes par type de ressource
- ✅ Suffixes par environnement



## 📈 Surveillance post-déploiement

### Dans le portail Azure
1. **Logic App** → Onglet "Runs history" pour voir les exécutions
2. **Log Analytics** → Requêtes KQL pour analyser les logs
3. **Application Insights** → Métriques et performances
4. **Workbook** → Dashboard de monitoring personnalisé

### Requêtes KQL utiles

```kql
// Toutes les exécutions de Logic App
AzureDiagnostics
| where ResourceProvider == "MICROSOFT.LOGIC"
| where ResourceName == "votre-logic-app-name"
| project TimeGenerated, ResultType, RunId_g, Status_s

// Exécutions échouées
AzureDiagnostics
| where ResourceProvider == "MICROSOFT.LOGIC"
| where ResultType == "Failed"
| project TimeGenerated, ResourceName, RunId_g, ResultDescription
```

## 🆘 Dépannage

### Erreurs courantes

1. **Template de validation échoue**
   - Vérifiez la syntaxe Bicep
   - Validez les paramètres requis

2. **Déploiement échoue**
   - Vérifiez les quotas de l'abonnement
   - Contrôlez les permissions RBAC

3. **Logic App ne se déclenche pas**
   - Vérifiez l'URL du trigger
   - Contrôlez les paramètres de sécurité



## ⚡ Déploiement rapide

```powershell
# 1. Connexion et création du groupe de ressources
Connect-AzAccount
New-AzResourceGroup -Name "rg-logicapp-dev" -Location "France Central"

# 2. Déploiement
New-AzResourceGroupDeployment -ResourceGroupName "rg-logicapp-dev" -TemplateFile "./infra/main.bicep" -TemplateParameterFile "./infra/main.dev.bicepparam"

# 3. Test (récupérer l'URL avec Azure CLI)
$url = az rest --method post --url "https://management.azure.com/subscriptions/[SUBSCRIPTION-ID]/resourceGroups/rg-logicapp-dev/providers/Microsoft.Logic/workflows/logicapp-demo-dev/triggers/manual/listCallbackUrl?api-version=2016-06-01" --query "value" --output tsv
Invoke-RestMethod -Uri $url -Method Post -Body '{"message":"Hello!"}' -ContentType "application/json"
```

✅ **C'est tout !** Template ultra-minimaliste (4 fichiers) prêt pour le déploiement avec monitoring complet.
#   P i p e l i n e   t e s t   1 0 / 0 2 / 2 0 2 5   1 1 : 2 0 : 0 5 
 
 