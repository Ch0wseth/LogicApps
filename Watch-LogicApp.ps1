# 🔄 Surveillance automatique et redéploiement

param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,
    
    [Parameter(Mandatory=$false)]
    [string]$WorkflowPath = "./src/workflow.json",
    
    [Parameter(Mandatory=$false)]
    [int]$IntervalSeconds = 30
)

Write-Host "👀 Surveillance automatique activée..." -ForegroundColor Cyan
Write-Host "📁 Fichier surveillé: $WorkflowPath" -ForegroundColor Yellow
Write-Host "⏱️ Intervalle: $IntervalSeconds secondes" -ForegroundColor Yellow
Write-Host "⏹️ Ctrl+C pour arrêter" -ForegroundColor Gray

$lastWriteTime = (Get-Item $WorkflowPath).LastWriteTime

while ($true) {
    Start-Sleep -Seconds $IntervalSeconds
    
    $currentWriteTime = (Get-Item $WorkflowPath).LastWriteTime
    
    if ($currentWriteTime -gt $lastWriteTime) {
        Write-Host "`n🔔 Changement détecté à $(Get-Date -Format 'HH:mm:ss')!" -ForegroundColor Green
        Write-Host "🚀 Déclenchement du redéploiement automatique..." -ForegroundColor Yellow
        
        try {
            & "./Update-LogicApp.ps1" -ResourceGroupName $ResourceGroupName -WorkflowPath $WorkflowPath
            Write-Host "✅ Redéploiement automatique réussi!" -ForegroundColor Green
        } catch {
            Write-Error "❌ Redéploiement automatique échoué: $_"
        }
        
        $lastWriteTime = $currentWriteTime
        Write-Host "👀 Reprise de la surveillance..." -ForegroundColor Cyan
    } else {
        Write-Host "." -NoNewline -ForegroundColor Gray
    }
}