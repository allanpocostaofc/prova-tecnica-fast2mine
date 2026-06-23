$envs = @("QA1", "QA2", "QA3")
$results = @()

foreach ($env in $envs) {
    $envLower = $env.ToLower()
    $varFile  = "resources/variables/${envLower}_vars.py"

    foreach ($suite in @("web", "mobile")) {
        $outDir = "results/${suite}-${env}"
        Write-Host "`n==> Executando $suite / $env ..."

        robot `
            --variable ENV:$env `
            --variablefile $varFile `
            --outputdir $outDir `
            --name "${suite}_${env}" `
            "tests/$suite/"

        $results += [PSCustomObject]@{
            Suite  = $suite
            Env    = $env
            Status = if ($LASTEXITCODE -eq 0) { "OK" } else { "FALHOU" }
        }
    }
}

Write-Host "`n===== RESUMO ====="
$results | Format-Table -AutoSize
