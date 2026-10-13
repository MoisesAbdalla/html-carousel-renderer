Add-Type -AssemblyName System.Drawing
$chrome = if ($env:CHROME_PATH) { $env:CHROME_PATH } else { "C:\Program Files\Google\Chrome\Application\chrome.exe" }
$base   = $PSScriptRoot
$raw    = "$base\out\_raw"
New-Item -ItemType Directory -Force -Path $raw | Out-Null
New-Item -ItemType Directory -Force -Path "$base\out" | Out-Null

foreach ($n in 1..7) {
  $rawPath = "$raw\slide-$n.png"
  if (Test-Path $rawPath) { Remove-Item $rawPath -Force }
  $url = "file:///$($base -replace "\\","/")/slides.html?s=$n"
  & $chrome --headless --disable-gpu --hide-scrollbars --no-sandbox `
            --force-device-scale-factor=2 --window-size=1080,1350 `
            --virtual-time-budget=6000 --screenshot="$rawPath" $url | Out-Null

  if (-not (Test-Path $rawPath)) { Write-Output "slide $n : FALHOU"; continue }

  # reduz de 2160x2700 para 1080x1350 (antialiasing melhor que renderizar em 1x)
  $src = New-Object System.Drawing.Bitmap($rawPath)
  $dst = New-Object System.Drawing.Bitmap(1080, 1350)
  $g = [System.Drawing.Graphics]::FromImage($dst)
  $g.InterpolationMode  = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
  $g.PixelOffsetMode    = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
  $g.SmoothingMode      = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
  $g.DrawImage($src, 0, 0, 1080, 1350)
  $g.Dispose()
  $out = "$base\out\abdalla-tech-preventiva-$n.png"
  $dst.Save($out, [System.Drawing.Imaging.ImageFormat]::Png)
  Write-Output "slide $n : $($src.Width)x$($src.Height) -> 1080x1350"
  $src.Dispose(); $dst.Dispose()
}
