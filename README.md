mypss
======

My Powershell Scripts


Usage
=====

Get-Logger
----------------------

```ps1
# Example: Output display only

# Get object
$logger = Get-Logger

# Information message on display
$logger.info.Invoke("Message")

# Warning message on display
$logger.warn.Invoke("Message")

# Error message on display
$logger.error.Invoke("Message")
```

```ps1
# Example: Output display and logfile

# Set logfile
$logger = Get-Logger -Logfile "C:\hoge\hoge.log"

# Output display and logfile
$logger.info.Invoke("Message")
```

```ps1
# Example: Output logfile only

# Set logfile and NoDisplay Switch
$logger = Get-Logger -Logfile "C:\hoge\hoge.log" -NoDisplay

# Output logfile only
$logger.info.Invoke("Message")
```
