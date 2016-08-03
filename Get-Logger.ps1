<#
.SYNOPSIS
 Return Logger Object

.PARAMETER Delimiter
  Delimiter for Logformat

.PARAMETER Logfile
  Logfile path

.PARAMETER Encoding
  file encoding

.PARAMETER NoDisplay
  Log message is no display

.EXAMPLE
  # Example: Output display only

  # Get object
  $logger = Get-Logger

  # Information message on display
  $logger.info.Invoke("Message")

  # Warning message on display
  $logger.warn.Invoke("Message")

  # Error message on display
  $logger.error.Invoke("Message")

.EXAMPLE
  # Example: Output display and logfile

  # Set logfile
  $logger = Get-Logger -Logfile "C:\hoge\hoge.log"

  # Output display and logfile
  $logger.info.Invoke("Message")

.EXAMPLE
  # Example: Output logfile only

  # Set logfile and NoDisplay Switch
  $logger = Get-Logger -Logfile "C:\hoge\hoge.log" -NoDisplay

  # Output logfile only
  $logger.info.Invoke("Message")

#>
function Global:Get-Logger{
    Param(
        [CmdletBinding()]
        [Parameter()]
        [String]$Delimiter = " ",
        [Parameter()]
        [String]$Logfile,
        [Parameter()]
        [String]$Encoding = "Default",
        [Parameter()]
        [Switch]$NoDisplay
    )
    if ($Logfile -And !(Test-Path -LiteralPath (Split-Path $Logfile -parent) -PathType container)) {
        New-Item $Logfile -type file -Force
    }
    $logger = @{}
    $logger.Set_Item('info', (Put-Log -Delimiter $Delimiter -Logfile $logfile -Encoding $Encoding -NoDisplay $NoDisplay -Info))
    $logger.Set_Item('warn', (Put-Log -Delimiter $Delimiter -Logfile $logfile -Encoding $Encoding -NoDisplay $NoDisplay -Warn))
    $logger.Set_Item('error', (Put-Log -Delimiter $Delimiter -Logfile $logfile -Encoding $Encoding -NoDisplay $NoDisplay -Err))
    return $logger
}

function Global:Put-Log
{
    Param(
        [CmdletBinding()]
        [Parameter()]
        [String]$Delimiter = " ",
        [Parameter()]
        [String]$Logfile,
        [Parameter()]
        [String]$Encoding,
        [Parameter()]
        [bool]$NoDisplay,
        [Parameter()]
        [Switch]$Info,
        [Parameter()]
        [Switch]$Warn,
        [Parameter()]
        [Switch]$Err
    )
    return {
        param([String]$msg = "")

        # Initialize variables
        $logparam = @("White", "INFO")
        if ($Warn)  { $logparam = @("Yellow", "WARN") }
        if ($Err) { $logparam = @("Red", "ERROR") }
        $txt = "[$(Get-Date -Format "yyyy/MM/dd HH:mm:ss")]${Delimiter}{0}${Delimiter}{1}" -f $logparam[1], $msg

        # Output Display
        if(!$NoDisplay) {
            Write-Host -ForegroundColor $logparam[0] $txt
        }
        # Output logfile
        if($Logfile) {
            Write-Output $txt | Out-File -FilePath $Logfile -Append -Encoding $Encoding
        }
    }.GetNewClosure()
}
