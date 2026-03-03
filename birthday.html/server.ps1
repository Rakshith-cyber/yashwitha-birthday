$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add('http://0.0.0.0:8888/')
$listener.Start()

# Get local IP address
$ipAddress = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.InterfaceAlias -notmatch "Loopback" -and $_.IPAddress -notmatch "^169\." } | Select-Object -First 1).IPAddress

Write-Host "========================================="
Write-Host "Birthday Website Server"
Write-Host "========================================="
Write-Host "Local access:   http://localhost:8888"
Write-Host "Network access: http://$ipAddress:8888"
Write-Host "========================================="
Write-Host "Press Ctrl+C to stop"

while ($listener.IsListening) {
    $context = $listener.GetContext()
    $response = $context.Response
    $path = $context.Request.Url.LocalPath
    
    if ($path -eq '/') { $path = '/index.html' }
    
    $fullPath = Join-Path 'c:\Users\Bahat\OneDrive\Desktop' $path.TrimStart('/')
    
    if (Test-Path $fullPath -and -not (Test-Path $fullPath -PathType Container)) {
        $content = [System.IO.File]::ReadAllBytes($fullPath)
        
        $ext = [System.IO.Path]::GetExtension($fullPath).ToLower()
        switch ($ext) {
            '.html' { $response.ContentType = 'text/html' }
            '.jpg' { $response.ContentType = 'image/jpeg' }
            '.jpeg' { $response.ContentType = 'image/jpeg' }
            '.png' { $response.ContentType = 'image/png' }
            '.gif' { $response.ContentType = 'image/gif' }
            '.webp' { $response.ContentType = 'image/webp' }
            '.mp3' { $response.ContentType = 'audio/mpeg' }
            '.css' { $response.ContentType = 'text/css' }
            '.js' { $response.ContentType = 'application/javascript' }
        }
        
        $response.ContentLength64 = $content.Length
        $response.OutputStream.Write($content, 0, $content.Length)
    } else {
        $response.StatusCode = 404
    }
    
    $response.Close()
}
