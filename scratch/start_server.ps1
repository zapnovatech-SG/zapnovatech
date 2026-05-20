$port = 8080
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:$port/")
try {
    $listener.Start()
    Write-Host "Server successfully started on http://localhost:$port/"
    
    # Process loop
    while ($listener.IsListening) {
        $context = $listener.GetContext()
        $request = $context.Request
        $response = $context.Response
        
        $urlPath = $request.Url.LocalPath
        if ($urlPath -eq "/") { $urlPath = "/index.html" }
        
        # Decode URL path and build local path
        $decodedPath = [System.Web.HttpUtility]::UrlDecode($urlPath)
        $filePath = Join-Path "g:\Shared drives\Webpage Design" $decodedPath.TrimStart('/')
        
        if (Test-Path $filePath -PathType Leaf) {
            $bytes = [System.IO.File]::ReadAllBytes($filePath)
            
            # Simple content-type mapping
            $ext = [System.IO.Path]::GetExtension($filePath).ToLower()
            $contentType = "text/plain"
            if ($ext -eq ".html") { $contentType = "text/html" }
            elseif ($ext -eq ".css") { $contentType = "text/css" }
            elseif ($ext -eq ".js") { $contentType = "application/javascript" }
            elseif ($ext -eq ".png") { $contentType = "image/png" }
            elseif ($ext -eq ".jpg" -or $ext -eq ".jpeg") { $contentType = "image/jpeg" }
            elseif ($ext -eq ".svg") { $contentType = "image/svg+xml" }
            
            $response.ContentType = $contentType
            $response.ContentLength64 = $bytes.Length
            $response.OutputStream.Write($bytes, 0, $bytes.Length)
        } else {
            $response.StatusCode = 404
            $errBytes = [System.Text.Encoding]::UTF8.GetBytes("File Not Found: $filePath")
            $response.OutputStream.Write($errBytes, 0, $errBytes.Length)
        }
        $response.Close()
    }
} catch {
    Write-Error $_
} finally {
    if ($listener) { $listener.Stop() }
}
