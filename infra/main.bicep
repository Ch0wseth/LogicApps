// Template Bicep pour déployer une Logic App avec monitoring complet
// Ce template suit les meilleures pratiques Azure et Bicep

targetScope = 'resourceGroup'

@description('Nom de la Logic App')
param logicAppName string

@description('Localisation des ressources')
param location string = resourceGroup().location

@description('Nom de l\'environnement (dev, test, prod)')
@allowed(['dev', 'test', 'prod'])
param environment string = 'dev'

@description('Tags pour toutes les ressources')
param tags object = {
  Environment: environment
  Project: 'LogicApps'
  DeployedBy: 'Bicep'
}



@description('Période de rétention des logs en jours')
@minValue(30)
@maxValue(730)
param logRetentionDays int = 90

// Variables pour la nomenclature des ressources
var logAnalyticsWorkspaceName = 'law-${logicAppName}-${environment}'
var applicationInsightsName = 'ai-${logicAppName}-${environment}'
var actionGroupName = 'ag-${logicAppName}-${environment}'
var metricAlertName = 'alert-${logicAppName}-failures-${environment}'

// Log Analytics Workspace pour le monitoring centralisé
resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: logAnalyticsWorkspaceName
  location: location
  tags: tags
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: logRetentionDays
    features: {
      enableLogAccessUsingOnlyResourcePermissions: true
    }
  }
}

// Application Insights pour le monitoring détaillé
resource applicationInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: applicationInsightsName
  location: location
  tags: tags
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: logAnalyticsWorkspace.id
    IngestionMode: 'LogAnalytics'
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
  }
}

// Action Group pour les notifications d'alertes
resource actionGroup 'Microsoft.Insights/actionGroups@2023-01-01' = {
  name: actionGroupName
  location: 'Global'
  tags: tags
  properties: {
    groupShortName: 'LogicApp'
    enabled: true
    emailReceivers: [
      {
        name: 'EmailAlert'
        emailAddress: 'admin@company.com' // À personnaliser
        useCommonAlertSchema: true
      }
    ]
  }
}

// Logic App principale
resource logicApp 'Microsoft.Logic/workflows@2019-05-01' = {
  name: logicAppName
  location: location
  tags: tags
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    state: 'Enabled'
    definition: {
      '$schema': 'https://schema.management.azure.com/providers/Microsoft.Logic/schemas/2016-06-01/workflowdefinition.json#'
      contentVersion: '1.0.0.0'
      parameters: {}
      triggers: {
        manual: {
          type: 'Request'
          kind: 'Http'
          inputs: {
            schema: {
              type: 'object'
              properties: {
                message: {
                  type: 'string'
                }
              }
            }
          }
        }
      }
      actions: {
        Response: {
          type: 'Response'
          kind: 'Http'
          inputs: {
            statusCode: 200
            body: {
              message: 'Hello from Logic App!'
              timestamp: '@utcNow()'
              inputMessage: '@triggerBody()?[\'message\']'
            }
          }
        }
      }
      outputs: {}
    }
    parameters: {}
  }
}

// Configuration des paramètres de diagnostic pour la Logic App
resource logicAppDiagnostics 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'diag-${logicAppName}'
  scope: logicApp
  properties: {
    workspaceId: logAnalyticsWorkspace.id
    logs: [
      {
        category: 'WorkflowRuntime'
        enabled: true
      }
    ]
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
      }
    ]
  }
}

// Alerte métrique pour les échecs de Logic App
resource failureAlert 'Microsoft.Insights/metricAlerts@2018-03-01' = {
  name: metricAlertName
  location: 'Global'
  tags: tags
  properties: {
    description: 'Alerte en cas d\'échec de la Logic App'
    severity: 2
    enabled: true
    scopes: [
      logicApp.id
    ]
    evaluationFrequency: 'PT5M'
    windowSize: 'PT15M'
    criteria: {
      'odata.type': 'Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria'
      allOf: [
        {
          name: 'FailedRuns'
          metricName: 'RunsFailed'
          operator: 'GreaterThan'
          threshold: 0
          timeAggregation: 'Total'
          criterionType: 'StaticThresholdCriterion'
        }
      ]
    }
    actions: [
      {
        actionGroupId: actionGroup.id
      }
    ]
  }
}

// Workbook personnalisé pour le monitoring avancé
resource monitoringWorkbook 'Microsoft.Insights/workbooks@2022-04-01' = {
  name: guid(resourceGroup().id, logicAppName, 'workbook')
  location: location
  tags: tags
  kind: 'shared'
  properties: {
    displayName: 'Logic App ${logicAppName} - Monitoring Dashboard'
    serializedData: '{"version":"Notebook/1.0","items":[{"type":1,"content":{"json":"# Logic App ${logicAppName} - Monitoring Dashboard\\n\\nCe tableau de bord présente les métriques et logs de votre Logic App."}}],"isLocked":false,"fallbackResourceIds":["${logAnalyticsWorkspace.id}"]}'
    category: 'workbook'
    sourceId: logAnalyticsWorkspace.id
  }
}

// Outputs utiles
@description('ID de la Logic App créée')
output logicAppId string = logicApp.id

@description('Nom de la Logic App pour récupérer l\'URL')
output logicAppName string = logicApp.name

@description('Identité managée (Principal ID) de la Logic App')
output logicAppPrincipalId string = logicApp.identity.principalId

@description('ID du workspace Log Analytics')
output logAnalyticsWorkspaceId string = logAnalyticsWorkspace.id

@description('Clé d\'instrumentation Application Insights')
output applicationInsightsInstrumentationKey string = applicationInsights.properties.InstrumentationKey

@description('ID de connexion Application Insights')
output applicationInsightsConnectionString string = applicationInsights.properties.ConnectionString

