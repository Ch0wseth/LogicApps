# Logic App avec Monitoring - Template Bicep

[![Deploy Infrastructure](https://github.com/Ch0wseth/LogicApps/actions/workflows/deploy-infrastructure.yml/badge.svg)](https://github.com/Ch0wseth/LogicApps/actions/workflows/deploy-infrastructure.yml)
[![Validate PR](https://github.com/Ch0wseth/LogicApps/actions/workflows/validate-pr.yml/badge.svg)](https://github.com/Ch0wseth/LogicApps/actions/workflows/validate-pr.yml)

Ce projet contient un template Bicep complet pour déployer une Azure Logic App avec un système de monitoring avancé et un pipeline CI/CD GitHub Actions entièrement automatisé.

## 📁 Structure du projet

```
LogicApps/
├── 📁 .github/
│   ├── 📁 workflows/
│   │   ├── deploy-infrastructure.yml  # Pipeline de déploiement principal
│   │   └── validate-pr.yml           # Validation des Pull Requests
│   └── SETUP-SECRETS.md              # Guide configuration secrets
├── 📁 infra/
│   ├── main.bicep                    # Template Bicep principal
│   └── main.dev.bicepparam           # Paramètres développement
├── README.md                         # Cette documentation
└── .gitignore                        # Exclusions Git
```

## 🏗️ Infrastructure
- **`main.bicep`** - Template principal avec toutes les ressources
- **`main.dev.bicepparam`** - Paramètres pour l'environnement de développement

### 📦 Ressources déployées

#### Logic App
- ✅ Azure Logic App avec identité managée système
- ✅ Workflow de base avec trigger HTTP et réponse
- ✅ Configuration sécurisée

#### Monitoring complet
- ✅ **Log Analytics Workspace** - Collecte centralisée des logs
- ✅ **Application Insights** - Monitoring des performances et télémétrie
- ✅ **Paramètres de diagnostic** - Logs WorkflowRuntime et métriques
- ✅ **Action Group** - Notifications par email
- ✅ **Alerte métrique** - Détection des échecs d'exécution
- ✅ **Workbook personnalisé** - Dashboard de monitoring

## 🚀 Déploiement

### Option 1: 🤖 Pipeline GitHub Actions (Recommandé)

Le projet inclut un pipeline GitHub Actions complet pour automatiser les déploiements.

#### ⚡ Setup rapide

1. **Configurer les secrets Azure** (voir [`.github/SETUP-SECRETS.md`](.github/SETUP-SECRETS.md))
2. **Push vers `main`** → Déploiement automatique
3. **Pull Request** → Validation automatique avec What-If

#### 🎯 Fonctionnalités du pipeline

- ✅ **Validation Bicep** automatique
- ✅ **What-If analysis** avant déploiement  
- ✅ **Tests post-déploiement** de la Logic App
- ✅ **Environments GitHub** (dev/staging/prod)
- ✅ **Commentaires PR** avec résultats de validation
- ✅ **OIDC Authentication** (plus sécurisé)

#### 🔧 Déclencheurs

```yaml
# Déploiement automatique
git push origin main  # → Deploy vers DEV

# Déploiement manuel avec choix d'environnement
# GitHub → Actions → "Deploy Logic App Infrastructure" → Run workflow
```

### Option 2: 📋 Déploiement manuel

#### Prérequis
- Azure CLI ou Azure PowerShell
- Extension Bicep installée
- Connexion à un abonnement Azure

#### Déploiement avec Azure PowerShell

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

## 🤖 Pipeline CI/CD

### 🚀 GitHub Actions Workflows

Le projet inclut deux workflows principaux :

#### 1. **Deploy Infrastructure** (`.github/workflows/deploy-infrastructure.yml`)
- **Déclenchement** : Push vers `main` ou manuel
- **Jobs** :
  - 🔍 **Validate** : Syntax Bicep + What-If analysis
  - 🚀 **Deploy** : Déploiement vers l'environnement cible
  - 🧪 **Test** : Tests fonctionnels post-déploiement
  - 📢 **Notify** : Résumé et notifications

#### 2. **PR Validation** (`.github/workflows/validate-pr.yml`)
- **Déclenchement** : Pull Request vers `main`
- **Features** :
  - ✅ Validation syntax Bicep
  - 🔍 What-If analysis (sans déploiement)
  - 🔒 Security & best practices check
  - 💬 Commentaire automatique sur PR

### 🌍 Environnements supportés

| Env | Déclenchement | Protection | Approbation |
|-----|---------------|------------|-------------|
| **dev** | Auto (push main) | ❌ Aucune | ❌ Aucune |
| **staging** | Manuel | ✅ 1 reviewer | ⏱️ 5 min |
| **prod** | Manuel | ✅ 2 reviewers | ⏱️ 30 min |

### 📋 Setup Pipeline

1. **Configuration secrets** → Voir [`.github/SETUP-SECRETS.md`](.github/SETUP-SECRETS.md)
2. **Configuration environnements** → Voir [`.github/ENVIRONMENTS.md`](.github/ENVIRONMENTS.md)
3. **Test pipeline** → Push vers `main`

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

## � Structure

```
LogicApps/
├── 📁 infra/
│   ├── main.bicep              # Template Bicep principal
│   ├── main.dev.bicepparam     # Paramètres développement  
│   └── main.prod.bicepparam    # Paramètres production
├── monitoring-queries.md       # Requêtes KQL utiles
├── README.md                   # Cette documentation
└── .gitignore                  # Exclusions Git
```

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
#   P i p e l i n e   t e s t   1 0 / 0 2 / 2 0 2 5   1 1 : 2 0 : 0 5  
 