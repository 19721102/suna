Param()

$url = "http://127.0.0.1:8000/v1/health"
$deadline = (Get-Date).AddSeconds(60)

while ((Get-Date) -lt $deadline) {
    Write-Host ("Checking {0}..." -f $url)
    $headers = & curl.exe -sS -D - $url -o NUL 2>$null
    if ($headers -match "HTTP/1\.1 200") {
        Write-Host "OK"
        exit 0
    }
    Start-Sleep -Seconds 1
}

Write-Host "Health check failed. Dumping diagnostics..."
docker compose ps
docker logs --tail=200 suna-backend-1
exit 1
