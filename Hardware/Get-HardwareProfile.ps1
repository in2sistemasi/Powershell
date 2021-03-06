Function Get-HardwareProfile {
    <#   

    .SYNOPSIS   
        Queries computer/s or remote computer/s for hardware profile. 
    .DESCRIPTION 
        Queries computer/s or remote computer/s for hardware profile. 
    .PARAMETER server 
        Name of server to check. 
    .PARAMETER credential 
        Allows the use of alternate credentials, if required. 
    .NOTES   
        Name: Get-HardwareProfile.ps1 
        Author: Boe Prox 
        DateCreated: 05Aug2010  
              
    .LINK   
        http://boeprox.wordpress.com/ 
    .EXAMPLE   
        Get-HardwareProfile -computer 'test' 
    .EXAMPLE   
        Get-HardwareProfile -computer (GC host.txt) 
    .EXAMPLE   
        'server' | Get-HardwareProfile 
               
    #>  
    [cmdletbinding( 
        SupportsShouldProcess = $True, 
        DefaultParameterSetName = 'computer', 
        ConfirmImpact = 'low' 
    )] 
    param( 
        [Parameter( 
            Mandatory = $False, 
            ParameterSetName = 'computer', 
            ValueFromPipeline = $True)] 
            [array]$computer,  
        [Parameter( 
            Mandatory = $False, 
            ParameterSetName = '')] 
            [switch]$credential          
    ) 
    Begin { 
        $ErrorActionPreference = 'stop' 
        If ($credential) { 
            $cred = Get-Credential 
            }        
        $report = @() 
        } 
    Process {     
        ForEach ($c in $Computer) { 
            $tempreport = New-Object PSObject   
            Try { 
                If ($credential) { 
                    $ChassisType = (Get-WMIobject -computer $c -Class Win32_SystemEnclosure -credential $cred).ChassisTypes 
                    } 
                Else {     
                    $ChassisType = (Get-WMIobject -computer $c -Class Win32_SystemEnclosure).ChassisTypes 
                    } 
                switch ($ChassisType) { 
                        1 {$ChassisType = "Other"} 
                        2 {$ChassisType = "Unknown"} 
                        3 {$ChassisType = "Desktop"} 
                        4 {$ChassisType = "Low Profile Desktop"} 
                        5 {$ChassisType = "Pizza Box"} 
                        6 {$ChassisType = "Mini Tower"} 
                        7 {$ChassisType = "Tower"} 
                        8 {$ChassisType = "Portable"} 
                        9 {$ChassisType = "Laptop"} 
                        10 {$ChassisType = "Notebook"} 
                        11 {$ChassisType = "Handheld"} 
                        12 {$ChassisType = "Docking Station"} 
                        13 {$ChassisType = "All-in-One"} 
                        14 {$ChassisType = "Sub-Notebook"} 
                        15 {$ChassisType = "Space Saving"} 
                        16 {$ChassisType = "Lunch Box"} 
                        17 {$ChassisType = "Main System Chassis"} 
                        18 {$ChassisType = "Expansion Chassis"} 
                        19 {$ChassisType = "Sub-Chassis"} 
                        20 {$ChassisType = "Bus Expansion Chassis"} 
                        21 {$ChassisType = "Peripheral Chassis"} 
                        22 {$ChassisType = "Storage Chassis"} 
                        23 {$ChassisType = "Rack Mount Chassis"} 
                        24 {$ChassisType = "Sealed- PC"} 
                        default {$ChassisType = "Unknown"} 
                    }          
                $tempreport | Add-Member NoteProperty Computer $c 
                $tempreport | Add-Member NoteProperty HWProfile $chassisType 
                } 
            Catch {   
                $tempreport | Add-Member NoteProperty Computer $c 
                $tempreport | Add-Member NoteProperty HWProfile "Unavailable" 
                } 
            $report += $tempreport             
            }                                       
        }     
    End { 
        $report  
        }        
}