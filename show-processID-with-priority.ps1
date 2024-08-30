function Get-ProcessMemoryUsage {
    param (
        [int]$ProcessId
    )

    $process = Get-Process -Id $ProcessId -ErrorAction SilentlyContinue
    if ($null -eq $process) {
        Write-Error "Process with ID $ProcessId not found."
        return
    }

    $memoryUsage = @{
        "ProcessId" = $process.Id
        "ProcessName" = $process.ProcessName
        "WorkingSet" = $process.WorkingSet64
        "PrivateMemorySize" = $process.PrivateMemorySize64
        "VirtualMemorySize" = $process.VirtualMemorySize64
    }

    return $memoryUsage
}

function Get-ProcessPriority {
    param (
        [int]$ProcessId
    )

    $process = Get-Process -Id $ProcessId -ErrorAction SilentlyContinue
    if ($null -eq $process) {
        Write-Error "Process with ID $ProcessId not found."
        return
    }

    $priority = @{
        "ProcessId" = $process.Id
        "ProcessName" = $process.ProcessName
        "BasePriority" = $process.BasePriority
        "PriorityClass" = $process.PriorityClass
    }

    return $priority
}

function Get-ProcessInfo {
    param (
        [int]$ProcessId
    )

    $memoryUsage = Get-ProcessMemoryUsage -ProcessId $ProcessId
    $priority = Get-ProcessPriority -ProcessId $ProcessId

    if ($memoryUsage -and $priority) {
        $processInfo = @{
            "ProcessId" = $memoryUsage.ProcessId
            "ProcessName" = $memoryUsage.ProcessName
            "WorkingSet" = $memoryUsage.WorkingSet
            "PrivateMemorySize" = $memoryUsage.PrivateMemorySize
            "VirtualMemorySize" = $memoryUsage.VirtualMemorySize
            "BasePriority" = $priority.BasePriority
            "PriorityClass" = $priority.PriorityClass
        }

        return $processInfo
    }
}

$hns_processId = Get-WmiObject Win32_Process | Where-Object { $_.CommandLine -like "*svchost*" -and $_.CommandLine -like "*hns*" } | Select-Object -ExpandProperty ProcessId

Get-ProcessInfo -ProcessId $hns_processId | Format-List
