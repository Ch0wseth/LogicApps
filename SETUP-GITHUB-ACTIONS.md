# 🚀 Guide Setup Pipeline GitHub Actions

## 📋 Prérequis
- ✅ Nouvelle subscription Azure avec droits Contributor
- ✅ Repo GitHub avec droits admin
- ✅ Azure CLI installé localement

---

## 🔧 1. Configuration Azure

### Étape 1: Se connecter à la nouvelle subscription
```bash
# Se connecter à Azure
az login

# Lister les subscriptions disponibles
az account list --output table

# Sélectionner ta nouvelle subscription
az account set --subscription "ID-DE-TA-NOUVELLE-SUBSCRIPTION"

# Vérifier
az account show
```

### Étape 2: Créer le Service Principal
```bash
# Créer le Service Principal avec les droits Contributor
az ad sp create-for-rbac --name "sp-logicapp-github-actions" \
  --role "Contributor" \
  --scopes "/subscriptions/ID-DE-TA-NOUVELLE-SUBSCRIPTION" \
  --sdk-auth

# ⚠️ IMPORTANT: Copie TOUT le JSON retourné !
```

**Exemple de sortie à copier :**
```json
{
  "clientId": "12345678-1234-1234-1234-123456789012",
  "clientSecret": "votre-secret-ici",
  "subscriptionId": "12345678-1234-1234-1234-123456789012", 
  "tenantId": "12345678-1234-1234-1234-123456789012",
  "activeDirectoryEndpointUrl": "https://login.microsoftonline.com",
  "resourceManagerEndpointUrl": "https://management.azure.com/",
  "activeDirectoryGraphResourceId": "https://graph.windows.net/",
  "sqlManagementEndpointUrl": "https://management.core.windows.net:8443/",
  "galleryEndpointUrl": "https://gallery.azure.com/",
  "managementEndpointUrl": "https://management.core.windows.net/"
}
```

---

## 🐙 2. Configuration GitHub

### Étape 1: Ajouter les Secrets
Va dans **GitHub → Settings → Secrets and variables → Actions**

Clique sur **"New repository secret"** et ajoute :

| Nom du Secret | Valeur |
|---------------|---------|
| `AZURE_CREDENTIALS` | Tout le JSON du Service Principal |
| `AZURE_SUBSCRIPTION_ID` | Juste l'ID de ta subscription |

### Étape 2: Créer les Environments (Optionnel mais recommandé)
Va dans **GitHub → Settings → Environments**

Crée 2 environnements :
- **`development`** (pas de protection)
- **`production`** (avec protection rules - require reviewers)

---

## 🧪 3. Test du Pipeline

### Test 1: Push sur develop (déploie DEV seulement)
```bash
git checkout -b develop
git add .
git commit -m "feat: add GitHub Actions pipeline"
git push origin develop
```

### Test 2: Push sur main (déploie DEV puis PROD)
```bash
git checkout main
git merge develop
git push origin main
```

### Test 3: Déclenchement manuel
Va dans **GitHub → Actions → Deploy Logic App Infrastructure → Run workflow**
- Choisis l'environnement (dev/prod)
- Clique "Run workflow"

---

## ✅ 4. Vérification

### Après déploiement réussi, tu auras :

#### 🏗️ Infrastructure Azure
- **Resource Groups :**
  - `rg-logicapp-dev` (West Europe)
  - `rg-logicapp-prod` (West Europe)

- **Logic Apps :**
  - `logicapp-webhook-dev`
  - `logicapp-webhook-prod`

- **Monitoring complet :**
  - Log Analytics Workspaces
  - Application Insights
  - Alertes automatiques
  - Workbooks

#### 🔗 URLs de test
Le pipeline affichera les URLs dans les logs :
```
🌐 Logic App Trigger URL: https://prod-xx.westeurope.logic.azure.com/...
```

#### 🧪 Test manuel
```bash
# Test de ta Logic App
curl -X POST "https://prod-xx.westeurope.logic.azure.com/..." \
  -H "Content-Type: application/json" \
  -d '{"message":"Test depuis mon PC!"}'
```

---

## 🐛 Troubleshooting

### Erreur "AADSTS53003" (Conditional Access)
❌ **Problème :** Politiques de sécurité d'entreprise
✅ **Solution :** Utilise une subscription personnelle ou demande à l'admin IT

### Erreur "Insufficient privileges"
❌ **Problème :** Service Principal sans droits
✅ **Solution :** Vérifie que tu es Owner/Contributor de la subscription

### Erreur "Resource group not found"
❌ **Problème :** Resource group pas créé
✅ **Solution :** Le pipeline crée automatiquement les RG

### Pipeline bloqué sur "Environment protection rules"
❌ **Problème :** Environment production protégé
✅ **Solution :** Approuve manuellement dans GitHub Actions

---

## 🚀 Prochaines étapes

1. **Configure Azure** (Service Principal)
2. **Configure GitHub** (Secrets)  
3. **Push ton code** (develop puis main)
4. **Regarde la magie opérer** ! ✨

**Temps estimé :** 10-15 minutes maximum ! 🕐