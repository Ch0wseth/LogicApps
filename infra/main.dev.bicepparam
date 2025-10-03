// Fichier de paramètres pour l'environnement de développement
using './main.bicep'

// Paramètres spécifiques à l'environnement de développement
param logicAppName = 'logicapp-webhook-dev'
param environment = 'dev'
param location = 'France Central'

// Configuration du monitoring
param logRetentionDays = 30

// Tags spécifiques à l'environnement
param tags = {
  Environment: 'dev'
  Project: 'LogicApps-Demo'
  Owner: 'DevTeam'
  CostCenter: 'IT-Development'
  DeployedBy: 'Bicep'
}
