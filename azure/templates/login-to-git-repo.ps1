$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f "minglu8", "Ol2123wy#")))
$data = @{
    grant_type = 'password'
    username   = "minglu8"
    password   = "Ol2123wy#"
}
# Perform the request to BB OAuth2.0
$tokens = Invoke-RestMethod -Uri github.com -Headers @{Authorization = ("Basic {0}" -f $base64AuthInfo) } -Method Get

Write-Output $tokens