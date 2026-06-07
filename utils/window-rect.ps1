Add-Type @"
using System;
using System.Runtime.InteropServices;

public static class WindowRect {
   [StructLayout(LayoutKind.Sequential)]
   public struct RECT {
      public int Left;
      public int Top;
      public int Right;
      public int Bottom;
   }

   [DllImport("user32.dll")]
   public static extern IntPtr GetForegroundWindow();

   [DllImport("user32.dll")]
   public static extern bool GetWindowRect(IntPtr hWnd, out RECT rect);

   [DllImport("user32.dll")]
   public static extern uint GetWindowThreadProcessId(IntPtr hWnd, out uint processId);
}
"@

$hwnd = [WindowRect]::GetForegroundWindow()
if ($hwnd -eq [IntPtr]::Zero) {
   exit 1
}

$processId = 0
[void][WindowRect]::GetWindowThreadProcessId($hwnd, [ref]$processId)
$process = Get-Process -Id $processId -ErrorAction SilentlyContinue
if ($null -eq $process -or $process.ProcessName -notmatch '^wezterm') {
   exit 1
}

$rect = New-Object WindowRect+RECT
if (-not [WindowRect]::GetWindowRect($hwnd, [ref]$rect)) {
   exit 1
}

[pscustomobject]@{
   x = $rect.Left
   y = $rect.Top
} | ConvertTo-Json -Compress
