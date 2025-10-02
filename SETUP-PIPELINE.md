# Setup Guide - GitHub Actions Pipeline

## 1. Créer le Service Principal

```bash
# Connecte-toi à ta nouvelle subscription
az login
az account set --subscription "ta-nouvelle-subscription-id"

# Crée le Service Principal
az ad sp create-for-rbac --name "sp-logicapp-github" \
  --role "Contributor" \
  --scopes "/subscriptions/ta-nouvelle-subscription-id" \
  --sdk-auth
```

**⚠️ IMPORTANT:** Copie tout le JSON retourné !

## 2. Créer les Resource Groups

```bash
# Resource Group Dev
az group create --name "rg-logicapp-dev" --location "West Europe"

# Resource Group Prod  
az group create --name "rg-logicapp-prod" --location "West Europe"
```

## 3. Configuration GitHub Secrets

Va dans **GitHub Settings > Secrets and variables > Actions** et ajoute :

### Secrets requis :
- `AZURE_CREDENTIALS` : Le JSON complet du Service Principal
- `AZURE_SUBSCRIPTION_ID` : L'ID de ta nouvelle subscription

### Variables d'environnement (optionnel) :
- `AZURE_RESOURCEGROUP_DEV` : rg-logicapp-dev
- `AZURE_RESOURCEGROUP_PROD` : rg-logicapp-prod

## 4. Environnements GitHub (Optionnel)

Pour plus de sécurité, crée des environnements dans **Settings > Environments** :
- `development` 
- `production` (avec protection rules)

## 5. Test du Pipeline

Une fois configuré :

```bash
# Push sur develop → déploie en DEV
git checkout -b develop
git push origin develop

# Push sur main → déploie en DEV puis PROD
git checkout main
git merge develop
git push origin main
```

## 6. Structure des branches

- `main` → Production
- `develop` → Development  
- `feature/*` → Pull Requests (validation seulement)

## Commandes de debug

Si ça marche pas :

```bash
# Teste la connexion Service Principal
az login --service-principal \
  --username "APP-ID" \
  --password "PASSWORD" \
  --tenant "TENANT-ID"

# Liste les resource groups
az group list --output table
```