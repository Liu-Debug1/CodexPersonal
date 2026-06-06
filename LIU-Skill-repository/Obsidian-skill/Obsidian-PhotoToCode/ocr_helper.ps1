param(
    [Parameter(Mandatory = $true)]
    [string]$ImagePath,
    [string]$ApiKey = "K87021967688957"
)

$ErrorActionPreference = "Stop"

# Resolve full path
$fullPath = Resolve-Path $ImagePath -ErrorAction SilentlyContinue
if (-not $fullPath) {
    Write-Error "File not found: $ImagePath"
    exit 1
}

# Read and encode image
$bytes = [System.IO.File]::ReadAllBytes($fullPath.Path)
$b64 = [Convert]::ToBase64String($bytes)
$dataUri = "data:image/png;base64,$b64"

# Try Windows Built-in OCR first (offline, fast)
$ocrText = $null
try {
    Add-Type -AssemblyName System.Runtime.WindowsRuntime -ErrorAction Stop

    [Windows.Storage.StorageFile, Windows.Storage, ContentType = WindowsRuntime] | Out-Null
    [Windows.Graphics.Imaging.BitmapDecoder, Windows.Graphics.Imaging, ContentType = WindowsRuntime] | Out-Null
    [Windows.Media.Ocr.OcrEngine, Windows.Media.Ocr, ContentType = WindowsRuntime] | Out-Null
    [Windows.Globalization.Language, Windows.Globalization, ContentType = WindowsRuntime] | Out-Null

    $op0 = [Windows.Storage.StorageFile]::GetFileFromPathAsync($fullPath.Path)
    $awaiter0 = [System.WindowsRuntimeSystemExtensions]::GetAwaiter($op0)
    while (!$awaiter0.IsCompleted) { Start-Sleep -Milliseconds 50 }
    $file = $awaiter0.GetResult()

    $op1 = $file.OpenReadAsync()
    $awaiter1 = [System.WindowsRuntimeSystemExtensions]::GetAwaiter($op1)
    while (!$awaiter1.IsCompleted) { Start-Sleep -Milliseconds 50 }
    $stream = $awaiter1.GetResult()

    $op2 = [Windows.Graphics.Imaging.BitmapDecoder]::CreateAsync($stream)
    $awaiter2 = [System.WindowsRuntimeSystemExtensions]::GetAwaiter($op2)
    while (!$awaiter2.IsCompleted) { Start-Sleep -Milliseconds 50 }
    $decoder = $awaiter2.GetResult()

    $op3 = $decoder.GetSoftwareBitmapAsync()
    $awaiter3 = [System.WindowsRuntimeSystemExtensions]::GetAwaiter($op3)
    while (!$awaiter3.IsCompleted) { Start-Sleep -Milliseconds 50 }
    $softwareBitmap = $awaiter3.GetResult()

    foreach ($lang in @("zh-CN", "zh-Hans-CN", "en")) {
        $langObj = [Windows.Globalization.Language]::new($lang)
        $engine = [Windows.Media.Ocr.OcrEngine]::TryCreateFromLanguage($langObj)
        if ($engine) {
            $op4 = $engine.RecognizeAsync($softwareBitmap)
            $awaiter4 = [System.WindowsRuntimeSystemExtensions]::GetAwaiter($op4)
            while (!$awaiter4.IsCompleted) { Start-Sleep -Milliseconds 50 }
            $result = $awaiter4.GetResult()
            $ocrText = $result.Text.Trim()
            $stream.Dispose()
            break
        }
    }
    $stream.Dispose()
} catch {
    # Windows OCR failed, fall through to web API
}

if ($ocrText) {
    $output = @{ source = "windows_ocr"; lang = $lang; text = $ocrText }
    ConvertTo-Json $output -Compress
    exit 0
}

# Fallback: OCR.space API (requires network)
$headers = @{ "apikey" = $ApiKey }
$body = @{
    base64Image = $dataUri
    language    = "eng"
    isOverlayRequired = "false"
    OCREngine   = "2"
}

try {
    $response = Invoke-RestMethod -Uri "https://api.ocr.space/parse/image" -Method Post -Headers $headers -Body $body -TimeoutSec 30
    if (-not $response.IsErroredOnProcessing -and $response.OCRExitCode -eq 1) {
        $text = $response.ParsedResults[0].ParsedText.Trim()
        $output = @{ source = "ocr_space"; lang = "eng"; text = $text }
        ConvertTo-Json $output -Compress
        exit 0
    } else {
        Write-Error "OCR API error: $($response.ErrorMessage)"
        exit 1
    }
} catch {
    Write-Error "OCR API request failed: $_"
    exit 1
}
