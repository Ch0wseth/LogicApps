// Fichier de paramètres pour l'environnement de production
using './main.bicep'

// Paramètres spécifiques à l'environnement de production
param logicAppName = 'logicapp-webhook-prod'
param environment = 'prod'
param location = 'France Central'

// Configuration du monitoring
param logRetentionDays = 90

// Tags pour la production
param tags = {
  Environment: 'Production'
  Project: 'LogicApp-DevOps'
  Owner: 'DevOps-Team'
  CostCenter: 'IT-Production'
}

// Configuration pour la production (rétention plus longue)
// Le monitoring et les alertes sont déjà configurés dans le template Bicep