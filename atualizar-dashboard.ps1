param(
    [switch]$Push,
    [switch]$OpenFolder
)

$ErrorActionPreference = "Stop"

$Source = "C:\Users\Canella e Santos\Desktop\Dashboard_PV_Empreendimentos_Jan-Abr_2026.html"
$ProjectRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$DocsDir = Join-Path $ProjectRoot "docs"
$Target = Join-Path $DocsDir "index.html"

if (-not (Test-Path -LiteralPath $Source)) {
    throw "Arquivo original nao encontrado: $Source"
}

New-Item -ItemType Directory -Force -Path $DocsDir | Out-Null
Copy-Item -LiteralPath $Source -Destination $Target -Force
$Utf8NoBom = New-Object System.Text.UTF8Encoding($false)
$Html = [System.IO.File]::ReadAllText($Target, [System.Text.Encoding]::UTF8)
if ($Html -notmatch 'name=["'']robots["'']') {
    $Html = $Html -replace '<head>', "<head>`r`n    <meta name=`"robots`" content=`"noindex,nofollow`">"
    [System.IO.File]::WriteAllText($Target, $Html, $Utf8NoBom)
}
Write-Host "Dashboard atualizado em: $Target"

if ($Push) {
    if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
        throw "Git nao encontrado no PATH."
    }

    Push-Location $ProjectRoot
    try {
        if (-not (Test-Path -LiteralPath (Join-Path $ProjectRoot ".git"))) {
            git init | Out-Host
            git checkout -B main | Out-Host
        }

        git add docs/index.html docs/.nojekyll netlify.toml vercel.json README.md atualizar-dashboard.ps1 | Out-Host
        $Status = git status --porcelain

        if ($Status) {
            git commit -m "Atualizar dashboard" | Out-Host
        } else {
            Write-Host "Nenhuma mudanca para publicar."
        }

        $Remote = git remote
        if ($Remote -contains "origin") {
            $Branch = (git branch --show-current).Trim()
            if (-not $Branch) {
                $Branch = "main"
                git checkout -B main | Out-Host
            }
            git push -u origin $Branch | Out-Host
        } else {
            Write-Warning "Sem remote 'origin'. Adicione um repositorio Git remoto para publicar automaticamente."
        }
    } finally {
        Pop-Location
    }
}

if ($OpenFolder) {
    Invoke-Item $ProjectRoot
}
