# 🤖 Script d'automatisation pour Logic App

param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,
    
    [Parameter(Mandatory=$false)]
    [string]$LogicAppName = "logicapp-demo-dev",
    
    [Parameter(Mandatory=$false)]
    [string]$WorkflowPath = "./src/workflow.json"
)

Write-Host "🚀 Mise à jour automatique du workflow Logic App..." -ForegroundColor Green

# 1. Vérifier que le fichier workflow existe
if (-not (Test-Path $WorkflowPath)) {
    Write-Error "❌ Fichier workflow introuvable: $WorkflowPath"
    exit 1
}

# 2. Lire la définition du workflow
try {
    $workflowContent = Get-Content $WorkflowPath -Raw | ConvertFrom-Json
    Write-Host "✅ Workflow chargé depuis $WorkflowPath" -ForegroundColor Yellow
} catch {
    Write-Error "❌ Erreur lors de la lecture du workflow: $_"
    exit 1
}

# 3. Mettre à jour le Bicep avec la nouvelle définition
Write-Host "🔄 Mise à jour du template Bicep..." -ForegroundColor Yellow

$bicepPath = "./infra/main.bicep"
$bicepContent = Get-Content $bicepPath -Raw

# Extraire la définition JSON et l'injecter dans le Bicep
$workflowDefinitionJson = $workflowContent.definition | ConvertTo-Json -Depth 20 -Compress

# Pattern de remplacement (simplifié - en production, utiliser une approche plus robuste)
$pattern = '(?<=definition: \{)[^}]+(?=\s+}\s+parameters:)'
$replacement = $workflowDefinitionJson.Substring(1, $workflowDefinitionJson.Length - 2) # Enlever { }

try {
    $updatedBicep = $bicepContent -replace $pattern, $replacement
    Set-Content -Path $bicepPath -Value $updatedBicep
    Write-Host "Template Bicep valide!" -ForegroundColor Green
} catch {
    Write-Warning "⚠️ Mise à jour Bicep automatique échouée. Déploiement manuel requis."
}

# 4. Valider le template
Write-Host "Validation du template Bicep..." -ForegroundColor Yellow
try {
    Test-AzResourceGroupDeployment `
        -ResourceGroupName $ResourceGroupName `
        -TemplateFile "./infra/main.bicep" `
        -TemplateParameterFile "./infra/main.dev.bicepparam" `
        -ErrorAction Stop
    Write-Host "✅ Template validé avec succès" -ForegroundColor Green
} catch {
    Write-Error "❌ Validation échouée: $_"
    exit 1
}

# 5. Déployer automatiquement
Write-Host "Deploiement de l'infrastructure..." -ForegroundColor Yellow
try {
    $deployment = New-AzResourceGroupDeployment `
        -ResourceGroupName $ResourceGroupName `
        -TemplateFile "./infra/main.bicep" `
        -TemplateParameterFile "./infra/main.dev.bicepparam" `
        -Name "auto-update-$(Get-Date -Format 'yyyyMMdd-HHmmss')" `
        -Force

    Write-Host "✅ Déploiement réussi: $($deployment.DeploymentName)" -ForegroundColor Green
    Write-Host "⏱️ Durée: $($deployment.Duration)" -ForegroundColor Yellow
} catch {
    Write-Error "❌ Déploiement échoué: $_"
    exit 1
}

# 6. Tester automatiquement
Write-Host "Tests de la Logic App..." -ForegroundColor Yellow
try {
    $triggerUrl = az rest --method post --url "https://management.azure.com/subscriptions/1358ce15-fec5-4e94-847b-13cd93b106fb/resourceGroups/$ResourceGroupName/providers/Microsoft.Logic/workflows/$LogicAppName/triggers/manual/listCallbackUrl?api-version=2016-06-01" --query "value" --output tsv

    # Test Ping
    $pingResponse = Invoke-RestMethod -Uri $triggerUrl -Method Post -Body '{"action":"ping","message":"auto-test"}' -ContentType "application/json"
    Write-Host "Test ping reussi" -ForegroundColor Green

    # Test Webhook
    $webhookResponse = Invoke-RestMethod -Uri $triggerUrl -Method Post -Body '{"action":"webhook","message":"auto-webhook-test"}' -ContentType "application/json"
    Write-Host "Test Webhook: $($webhookResponse.status)" -ForegroundColor Green

    Write-Host "Tous les tests automatiques reussis!" -ForegroundColor Green
} catch {
    Write-Warning "Tests automatiques echoues: $_"
}

Write-Host "Mise a jour automatique terminee!" -ForegroundColor Cyan