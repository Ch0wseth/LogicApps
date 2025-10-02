# 🔐 Configuration des Secrets GitHub

Pour que le pipeline GitHub Actions fonctionne, vous devez configurer les secrets suivants dans votre repository GitHub.

## Secrets obligatoires

### 1. Configuration Azure OIDC (Recommandé - Plus sécurisé)

```bash
# Dans votre repository GitHub → Settings → Secrets and variables → Actions

AZURE_CLIENT_ID=<votre-service-principal-client-id>
AZURE_TENANT_ID=<votre-tenant-azure-id>
AZURE_SUBSCRIPTION_ID=<votre-subscription-azure-id>
```

### 2. Configuration des Environnements GitHub

Créez les environnements suivants dans GitHub → Settings → Environments :
- `dev` (protection optionnelle)
- `staging` (protection recommandée)  
- `prod` (protection obligatoire + approbation manuelle)

## 🚀 Setup rapide OIDC

### Étape 1 : Créer un Service Principal Azure

```powershell
# Connexion à Azure
Connect-AzAccount

# Variables
$subscriptionId = "votre-subscription-id"
$resourceGroupName = "rg-logicapp-dev"  # ou votre RG principal
$appName = "sp-github-logicapp-cicd"

# Créer le Service Principal
$sp = New-AzADServicePrincipal -DisplayName $appName

# Assigner les permissions (Contributor sur la subscription ou RG)
New-AzRoleAssignment -ObjectId $sp.Id -RoleDefinitionName "Contributor" -Scope "/subscriptions/$subscriptionId"

# Afficher les informations nécessaires
Write-Host "AZURE_CLIENT_ID: $($sp.AppId)"
Write-Host "AZURE_TENANT_ID: $(Get-AzContext).Tenant.Id"
Write-Host "AZURE_SUBSCRIPTION_ID: $subscriptionId"
```

### Étape 2 : Configurer OIDC Federation

```powershell
# Créer la fédération OIDC pour GitHub Actions
$githubOrg = "votre-github-username"
$githubRepo = "LogicApps"

# Fédération pour la branche main
$federationMain = @{
    name = "github-main"
    issuer = "https://token.actions.githubusercontent.com"
    subject = "repo:$githubOrg/$githubRepo:ref:refs/heads/main"
    audiences = @("api://AzureADTokenExchange")
}

New-AzADAppFederatedCredential -ApplicationId $sp.AppId @federationMain

# Fédération pour les Pull Requests (optionnel)
$federationPR = @{
    name = "github-pr"
    issuer = "https://token.actions.githubusercontent.com"  
    subject = "repo:$githubOrg/$githubRepo:pull_request"
    audiences = @("api://AzureADTokenExchange")
}

New-AzADAppFederatedCredential -ApplicationId $sp.AppId @federationPR
```

### Étape 3 : Configuration GitHub Secrets

1. Allez dans votre repository GitHub
2. Settings → Secrets and variables → Actions  
3. Ajoutez les secrets :
   - `AZURE_CLIENT_ID` = App ID du Service Principal
   - `AZURE_TENANT_ID` = Tenant ID de votre Azure AD
   - `AZURE_SUBSCRIPTION_ID` = ID de votre subscription Azure

## 🔄 Alternative : Configuration avec Client Secret (Moins sécurisé)

Si vous préférez utiliser un client secret :

```powershell
# Créer un secret pour le Service Principal
$secret = New-AzADAppCredential -ApplicationId $sp.AppId -DisplayName "GitHub-Actions-Secret"

Write-Host "AZURE_CLIENT_SECRET: $($secret.SecretText)"
```

Puis ajoutez le secret `AZURE_CLIENT_SECRET` dans GitHub et modifiez le workflow pour utiliser `azure/login@v2` avec `creds` au lieu d'OIDC.

## 🏷️ Environments GitHub (Optionnel mais recommandé)

### Configuration des environnements protégés :

1. **dev** : Déploiement automatique
2. **staging** : Approbation d'un reviewer  
3. **prod** : Approbation de 2 reviewers + délai de protection

```yaml
# Dans Settings → Environments → [nom-environnement]
# Protection rules :
- Required reviewers: 1-6 personnes
- Wait timer: 0-43200 minutes
- Deployment branches: Selected branches (main, release/*)
```

## 🔍 Vérification du Setup

Test rapide pour vérifier que tout fonctionne :

```bash
# Cloner votre repository
git clone https://github.com/votre-username/LogicApps.git
cd LogicApps

# Faire un petit changement pour déclencher le pipeline
echo "# Pipeline test" >> README.md
git add README.md
git commit -m "test: trigger GitHub Actions pipeline"
git push origin main
```

Le pipeline devrait se déclencher automatiquement et vous verrez les résultats dans l'onglet "Actions" de votre repository GitHub.

## 📊 Monitoring du Pipeline

Une fois configuré, le pipeline vous donnera :
- ✅ Validation Bicep avant déploiement
- 🔍 What-If analysis des changements
- 🚀 Déploiement automatique
- 🧪 Tests post-déploiement  
- 📊 Résumé dans GitHub Summary
- 🌐 URL de test de la Logic App

**Le pipeline est maintenant prêt à automatiser vos déploiements !** 🎉