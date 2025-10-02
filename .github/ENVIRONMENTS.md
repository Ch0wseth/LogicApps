# 🌍 Configuration des Environnements GitHub

Ce fichier décrit comment configurer les environnements GitHub pour le pipeline de déploiement.

## Environnements recommandés

### 🔧 DEV Environment
- **Purpose**: Développement et tests
- **Auto-deploy**: ✅ Oui (sur push main)
- **Protection**: Aucune
- **Secrets**: Partagés depuis Organization/Repository

```yaml
name: dev
deployment_branches:
  - main
  - develop
protection_rules: []
```

### 🧪 STAGING Environment  
- **Purpose**: Tests d'intégration et validation
- **Auto-deploy**: ❌ Manuel uniquement
- **Protection**: 1 reviewer requis
- **Secrets**: Spécifiques staging

```yaml
name: staging
deployment_branches:
  - main
  - release/*
protection_rules:
  - type: required_reviewers
    required_reviewers: 1
  - type: wait_timer
    wait_timer: 5  # 5 minutes de délai
```

### 🏭 PROD Environment
- **Purpose**: Production
- **Auto-deploy**: ❌ Manuel avec approbation
- **Protection**: 2 reviewers + délai
- **Secrets**: Spécifiques production

```yaml
name: prod
deployment_branches:
  - main
protection_rules:
  - type: required_reviewers
    required_reviewers: 2
  - type: wait_timer  
    wait_timer: 30  # 30 minutes de délai
  - type: deployment_branches
    custom_branch_policies: true
```

## 🚀 Setup via GitHub CLI

```bash
# Installer GitHub CLI si nécessaire
winget install GitHub.cli

# Se connecter
gh auth login

# Créer les environnements
gh api repos/:owner/:repo/environments/dev --method PUT
gh api repos/:owner/:repo/environments/staging --method PUT  
gh api repos/:owner/:repo/environments/prod --method PUT

# Configurer les protections STAGING
gh api repos/:owner/:repo/environments/staging --method PUT --input - <<EOF
{
  "deployment_branches": {
    "protected_branches": true,
    "custom_branch_policies": false
  },
  "protection_rules": [
    {
      "type": "required_reviewers",
      "reviewers": [
        {"type": "User", "id": 123456}  
      ]
    },
    {
      "type": "wait_timer", 
      "wait_timer": 5
    }
  ]
}
EOF

# Configurer les protections PROD
gh api repos/:owner/:repo/environments/prod --method PUT --input - <<EOF
{
  "deployment_branches": {
    "protected_branches": true,
    "custom_branch_policies": false  
  },
  "protection_rules": [
    {
      "type": "required_reviewers",
      "reviewers": [
        {"type": "User", "id": 123456},
        {"type": "User", "id": 789012}
      ]
    },
    {
      "type": "wait_timer",
      "wait_timer": 30
    }
  ]
}
EOF
```

## 🔐 Secrets par Environnement

### Secrets communs (Repository level)
```
AZURE_CLIENT_ID=xxx
AZURE_TENANT_ID=xxx  
AZURE_SUBSCRIPTION_ID=xxx
```

### Secrets spécifiques DEV
```
# Optionnel - hérite des secrets repository
```

### Secrets spécifiques STAGING
```
AZURE_SUBSCRIPTION_ID=staging-subscription-id  # Si différent
NOTIFICATION_EMAIL=staging-team@company.com
```

### Secrets spécifiques PROD
```
AZURE_SUBSCRIPTION_ID=prod-subscription-id     # Si différent
NOTIFICATION_EMAIL=prod-alerts@company.com
AZURE_CLIENT_ID=prod-specific-sp               # SP dédié prod
```

## 📋 Checklist Setup Complet

### ✅ GitHub Repository
- [ ] Repository créé et configuré
- [ ] Secrets AZURE_* ajoutés  
- [ ] Environments dev/staging/prod créés
- [ ] Protection rules configurées
- [ ] Branch protection sur `main` activée

### ✅ Azure Configuration
- [ ] Service Principal créé
- [ ] OIDC Federation configurée
- [ ] Permissions Contributor assignées
- [ ] Subscriptions dev/staging/prod configurées

### ✅ Pipeline Tests
- [ ] Push test vers `main` réussi
- [ ] Pull Request avec validation réussie
- [ ] Déploiement manuel testé
- [ ] Logic App testée post-déploiement

## 🎯 Workflow de développement

### Pour les développeurs

```bash
# 1. Créer une branche feature
git checkout -b feature/my-change
git push -u origin feature/my-change

# 2. Créer une Pull Request
# → Déclenche validation automatique

# 3. Merge vers main après approbation  
# → Déclenche déploiement automatique vers DEV

# 4. Promouvoir vers staging/prod via dispatch manuel
# GitHub Actions → Deploy Infrastructure → Run workflow
```

### Pour les releases

```bash
# 1. Tag de release
git tag -a v1.0.0 -m "Release v1.0.0"
git push origin v1.0.0

# 2. Déploiement manuel vers PROD
# GitHub Actions → Deploy Infrastructure → Run workflow → Environment: prod
```

**🎉 Configuration terminée ! Votre pipeline CI/CD est maintenant prêt !**