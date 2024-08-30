# Windows Nodepool Note

### Q: 如何新增 Windows nodepool 至 AKS?

https://learn.microsoft.com/en-us/cli/azure/aks/nodepool?view=azure-cli-latest#az-aks-nodepool-add

```bash
az aks nodepool add \
    --resource-group rg-aks-japaneast \
    --cluster-name aks-pichuang-japaneast \
    --aks-custom-headers owner=pichuang \
    --os-type Windows \
    --os-sku Windows2022 \
    --vm-set-type VirtualMachineScaleSets \
    --priority Spot \
    --node-vm-size Standard_D32ads_v5 \
    --name npw23 \
    --node-count 1
```

### Q: 如何登入指定 AKS 節點中的 Windows Node?

```bash
apiVersion: v1
kind: Pod
metadata:
  labels:
    pod: hpc
  name: hpc
spec:
  securityContext:
    windowsOptions:
      hostProcess: true
      runAsUserName: "NT AUTHORITY\\SYSTEM"
  hostNetwork: true
  containers:
    - name: hpc
      image: mcr.microsoft.com/windows/servercore:ltsc2022 # Use servercore:1809 for WS2019
      command:
        - powershell.exe
        - -Command
        - "Start-Sleep 2147483"
      imagePullPolicy: IfNotPresent
  nodeSelector:
    kubernetes.io/os: windows
    kubernetes.io/hostname: aksnpw22000000
  tolerations:
    - effect: NoSchedule
      key: node.kubernetes.io/unschedulable
      operator: Exists
    - effect: NoSchedule
      key: node.kubernetes.io/network-unavailable
      operator: Exists
    - effect: NoExecute
      key: node.kubernetes.io/unreachable
      operator: Exists
    - key: "kubernetes.azure.com/scalesetpriority"
      operator: "Equal"
      value: "spot"
      effect: "NoSchedule"
EOF

kubectl exec -it [HPC-POD-NAME] -- powershell
```

Output:
```
Windows PowerShell
Copyright (C) Microsoft Corporation. All rights reserved.

Install the latest PowerShell for new features and improvements! https://aka.ms/PSWindows

PS C:\> Get-ComputerInfo


WindowsBuildLabEx                                       : 20348.859.amd64fre.fe_release_svc_prod2.22070
                                                          7-1832
WindowsCurrentVersion                                   : 6.3
WindowsEditionId                                        : ServerDatacenter
WindowsInstallationType                                 : Server Core
WindowsInstallDateFromRegistry                          : 8/28/2024 8:39:50 AM
WindowsProductId                                        : 00454-60000-00001-AA054
WindowsProductName                                      : Windows Server 2022 Datacenter
WindowsRegisteredOrganization                           :
WindowsRegisteredOwner                                  :
WindowsSystemRoot                                       : C:\Windows
WindowsVersion                                          : 2009
OSDisplayVersion                                        : 21H2
BiosCharacteristics                                     : {4, 7, 9, 11...}
BiosBIOSVersion                                         : {VRTUAL - 12001807, Intel(R) Xeon(R) CPU
                                                          E5-2673 v4 @ 2.30GHz, Intel(R) Xeon(R) CPU
                                                          E5-2673 v4 @ 2.30GHz, BIOS Date: 12/07/18
                                                          15:46:29  Ver: 09.00.08...}
BiosBuildNumber                                         :
BiosCaption                                             : Intel(R) Xeon(R) CPU E5-2673 v4 @ 2.30GHz
BiosCodeSet                                             :
BiosCurrentLanguage                                     : enUS
BiosDescription                                         : Intel(R) Xeon(R) CPU E5-2673 v4 @ 2.30GHz
BiosEmbeddedControllerMajorVersion                      :
BiosEmbeddedControllerMinorVersion                      :
BiosFirmwareType                                        : Bios
BiosIdentificationCode                                  :
BiosInstallableLanguages                                : 1
BiosInstallDate                                         :
BiosLanguageEdition                                     :
BiosListOfLanguages                                     : {enUS}
BiosManufacturer                                        : American Megatrends Inc.
BiosName                                                : Intel(R) Xeon(R) CPU E5-2673 v4 @ 2.30GHz
BiosOtherTargetOS                                       :
BiosPrimaryBIOS                                         : True
BiosReleaseDate                                         : 12/7/2018 12:00:00 AM
BiosSeralNumber                                         : 0000-0004-6682-3874-3636-8866-16
BiosSMBIOSBIOSVersion                                   : 090008
BiosSMBIOSMajorVersion                                  : 2
BiosSMBIOSMinorVersion                                  : 3
BiosSMBIOSPresent                                       : True
BiosSoftwareElementState                                : Running
BiosStatus                                              : OK
BiosSystemBiosMajorVersion                              :
BiosSystemBiosMinorVersion                              :
BiosTargetOperatingSystem                               : 0
BiosVersion                                             : VRTUAL - 12001807
CsAdminPasswordStatus                                   : Unknown
CsAutomaticManagedPagefile                              : False
CsAutomaticResetBootOption                              : True
CsAutomaticResetCapability                              : True
CsBootOptionOnLimit                                     : 0
CsBootOptionOnWatchDog                                  : 0
CsBootROMSupported                                      : True
CsBootStatus                                            : {0, 0, 0, 0...}
CsBootupState                                           : Normal boot
CsCaption                                               : aksnpw22000000
CsChassisBootupState                                    : Safe
CsChassisSKUNumber                                      :
CsCurrentTimeZone                                       : 0
CsDaylightInEffect                                      :
CsDescription                                           : AT/AT COMPATIBLE
CsDNSHostName                                           : aksnpw22000000
CsDomain                                                : WORKGROUP
CsDomainRole                                            : StandaloneServer
CsEnableDaylightSavingsTime                             : True
CsFrontPanelResetStatus                                 : Unknown
CsHypervisorPresent                                     : True
CsInfraredSupported                                     : False
CsInitialLoadInfo                                       :
CsInstallDate                                           :
CsKeyboardPasswordStatus                                : Unknown
CsLastLoadInfo                                          :
CsManufacturer                                          : Microsoft Corporation
CsModel                                                 : Virtual Machine
CsName                                                  : aksnpw22000000
CsNetworkAdapters                                       : {Ethernet 2, Ethernet 3, vEthernet (Ethernet
                                                          2)}
CsNetworkServerModeEnabled                              : True
CsNumberOfLogicalProcessors                             : 2
CsNumberOfProcessors                                    : 1
CsProcessors                                            : {Intel(R) Xeon(R) CPU E5-2673 v4 @ 2.30GHz}
CsOEMStringArray                                        : {[MS_VM_CERT/SHA1/9b80ca0d5dd061ec9da4e494f4c
                                                          3fd1196270c22],
                                                          00000000000000000000000000000000, To be
                                                          filed by MSFT}
CsPartOfDomain                                          : False
CsPauseAfterReset                                       : 3932100000
CsPCSystemType                                          : Desktop
CsPCSystemTypeEx                                        : Desktop
CsPowerManagementCapabilities                           :
CsPowerManagementSupported                              :
CsPowerOnPasswordStatus                                 : Unknown
CsPowerState                                            : Unknown
CsPowerSupplyState                                      : Safe
CsPrimaryOwnerContact                                   :
CsPrimaryOwnerName                                      :
CsResetCapability                                       : Other
CsResetCount                                            : -1
CsResetLimit                                            : -1
CsRoles                                                 : {LM_Workstation, LM_Server, NT, Server_NT}
CsStatus                                                : OK
CsSupportContactDescription                             :
CsSystemFamily                                          :
CsSystemSKUNumber                                       :
CsSystemType                                            : x64-based PC
CsThermalState                                          : Other
CsTotalPhysicalMemory                                   : 8589463552
CsPhyicallyInstalledMemory                              : 8388608
CsUserName                                              :
CsWakeUpType                                            : PowerSwitch
CsWorkgroup                                             : WORKGROUP
OsName                                                  : Microsoft Windows Server 2022 Datacenter
OsType                                                  : WINNT
OsOperatingSystemSKU                                    : DatacenterServerEdition
OsVersion                                               : 10.0.20348
OsCSDVersion                                            :
OsBuildNumber                                           : 20348
OsHotFixes                                              : {KB5041948, KB5041160, KB5041590}
OsBootDevice                                            : \Device\HarddiskVolume1
OsSystemDevice                                          : \Device\HarddiskVolume2
OsSystemDirectory                                       : C:\Windows\system32
OsSystemDrive                                           : C:
OsWindowsDirectory                                      : C:\Windows
OsCountryCode                                           : 1
OsCurrentTimeZone                                       : 0
OsLocaleID                                              : 0409
OsLocale                                                : en-US
OsLocalDateTime                                         : 8/28/2024 9:18:47 AM
OsLastBootUpTime                                        : 8/28/2024 8:40:03 AM
OsUptime                                                : 00:38:43.9935292
OsBuildType                                             : Multiprocessor Free
OsCodeSet                                               : 1252
OsDataExecutionPreventionAvailable                      : True
OsDataExecutionPrevention32BitApplications              : True
OsDataExecutionPreventionDrivers                        : True
OsDataExecutionPreventionSupportPolicy                  : OptOut
OsDebug                                                 : False
OsDistributed                                           : False
OsEncryptionLevel                                       : 256
OsForegroundApplicationBoost                            : Maximum
OsTotalVisibleMemorySize                                : 8388148
OsFreePhysicalMemory                                    : 4510808
OsTotalVirtualMemorySize                                : 10354228
OsFreeVirtualMemory                                     : 6519120
OsInUseVirtualMemory                                    : 3835108
OsTotalSwapSpaceSize                                    :
OsSizeStoredInPagingFiles                               : 1966080
OsFreeSpaceInPagingFiles                                : 1883040
OsPagingFiles                                           : {D:\pagefile.sys}
OsHardwareAbstractionLayer                              : 10.0.20348.2031
OsInstallDate                                           : 8/28/2024 8:39:50 AM
OsManufacturer                                          : Microsoft Corporation
OsMaxNumberOfProcesses                                  : 4294967295
OsMaxProcessMemorySize                                  : 137438953344
OsMuiLanguages                                          : {en-US}
OsNumberOfLicensedUsers                                 : 0
OsNumberOfProcesses                                     : 279
OsNumberOfUsers                                         : 0
OsOrganization                                          :
OsArchitecture                                          : 64-bit
OsLanguage                                              : en-US
OsProductSuites                                         : {TerminalServices, DatacenterEdition,
                                                          TerminalServicesSingleSession}
OsOtherTypeDescription                                  :
OsPAEEnabled                                            :
OsPortableOperatingSystem                               : False
OsPrimary                                               : True
OsProductType                                           : Server
OsRegisteredUser                                        :
OsSerialNumber                                          : 00454-60000-00001-AA054
OsServicePackMajorVersion                               : 0
OsServicePackMinorVersion                               : 0
OsStatus                                                : OK
OsSuites                                                : {TerminalServices, DatacenterEdition,
                                                          TerminalServicesSingleSession}
OsServerLevel                                           : ServerCore
KeyboardLayout                                          : en-US
TimeZone                                                : (UTC) Coordinated Universal Time
LogonServer                                             :
PowerPlatformRole                                       : Desktop
HyperVisorPresent                                       : True
HyperVRequirementDataExecutionPreventionAvailable       :
HyperVRequirementSecondLevelAddressTranslation          :
HyperVRequirementVirtualizationFirmwareEnabled          :
HyperVRequirementVMMonitorModeExtensions                :
DeviceGuardSmartStatus                                  : Off
DeviceGuardRequiredSecurityProperties                   : {0}
DeviceGuardAvailableSecurityProperties                  : {BaseVirtualizationSupport}
DeviceGuardSecurityServicesConfigured                   : {0}
DeviceGuardSecurityServicesRunning                      : {0}
DeviceGuardCodeIntegrityPolicyEnforcementStatus         :
DeviceGuardUserModeCodeIntegrityPolicyEnforcementStatus :
```

### Q: 如何獲得記憶體資訊?

```powershell
PS C:\> Get-WmiObject -Class Win32_PhysicalMemory | Select-Object Capacity, Manufacturer, Speed

   Capacity Manufacturer Speed
   -------- ------------ -----
 1073741824 Microsoft
34358689792 Microsoft
34358689792 Microsoft
34358689792 Microsoft
33289142272 Microsoft
```

### Q: 從 kubernetes 看到的 windows 資訊?

```bash
$ kubectl describe node aksnpw22000000
Name:               aksnpw22000000
Roles:              agent
Labels:             agentpool=npw22
                    beta.kubernetes.io/arch=amd64
                    beta.kubernetes.io/os=windows
                    kubernetes.azure.com/agentpool=npw22
                    kubernetes.azure.com/cluster=MC_rg-aks-japaneast
                    kubernetes.azure.com/consolidated-additional-properties=34f5d97c-6525-11ef-949f-9294afc7e214
                    kubernetes.azure.com/kubelet-identity-client-id=34dfc523-c0a5-4d73-8f1a-e2b8f8f5f4cb
                    kubernetes.azure.com/mode=user
                    kubernetes.azure.com/node-image-version=AKSWindows-2022-containerd-20348.2655.240814
                    kubernetes.azure.com/nodepool-type=VirtualMachineScaleSets
                    kubernetes.azure.com/os-sku=Windows2022
                    kubernetes.azure.com/role=agent
                    kubernetes.azure.com/scalesetpriority=spot
                    kubernetes.io/arch=amd64
                    kubernetes.io/hostname=aksnpw22000000
                    kubernetes.io/os=windows
                    kubernetes.io/role=agent
                    node-role.kubernetes.io/agent=
                    node.kubernetes.io/instance-type=Standard_D32ads_v5
                    node.kubernetes.io/windows-build=10.0.20348
                    topology.disk.csi.azure.com/zone=
                    topology.kubernetes.io/region=japaneast
                    topology.kubernetes.io/zone=0
Annotations:        csi.volume.kubernetes.io/nodeid: {"disk.csi.azure.com":"aksnpw22000000","file.csi.azure.com":"aksnpw22000000"}
                    node.alpha.kubernetes.io/ttl: 0
                    volumes.kubernetes.io/controller-managed-attach-detach: true
CreationTimestamp:  Wed, 28 Aug 2024 18:08:33 +0800
Taints:             kubernetes.azure.com/scalesetpriority=spot:NoSchedule
Unschedulable:      false
Lease:
  HolderIdentity:  aksnpw22000000
  AcquireTime:     <unset>
  RenewTime:       Wed, 28 Aug 2024 18:15:22 +0800
Conditions:
  Type             Status  LastHeartbeatTime                 LastTransitionTime                Reason                       Message
  ----             ------  -----------------                 ------------------                ------                       -------
  MemoryPressure   False   Wed, 28 Aug 2024 18:10:36 +0800   Wed, 28 Aug 2024 18:08:33 +0800   KubeletHasSufficientMemory   kubelet has sufficient memory available
  DiskPressure     False   Wed, 28 Aug 2024 18:10:36 +0800   Wed, 28 Aug 2024 18:08:33 +0800   KubeletHasNoDiskPressure     kubelet has no disk pressure
  PIDPressure      False   Wed, 28 Aug 2024 18:10:36 +0800   Wed, 28 Aug 2024 18:08:33 +0800   KubeletHasSufficientPID      kubelet has sufficient PID available
  Ready            True    Wed, 28 Aug 2024 18:10:36 +0800   Wed, 28 Aug 2024 18:08:34 +0800   KubeletReady                 kubelet is posting ready status
Addresses:
  InternalIP:  10.224.0.253
  Hostname:    aksnpw22000000
Capacity:
  cpu:                32
  ephemeral-storage:  133703676Ki
  memory:             134217268Ki
  pods:               30
Allocatable:
  cpu:                31580m
  ephemeral-storage:  133703676Ki
  memory:             122348084Ki
  pods:               30
System Info:
  Machine ID:                 aksnpw22000000
  System UUID:                E10DA59B-9E4D-4DBD-8249-2F515222A6B1
  Boot ID:                    8
  Kernel Version:             10.0.20348.2655
  OS Image:                   Windows Server 2022 Datacenter
  Operating System:           windows
  Architecture:               amd64
  Container Runtime Version:  containerd://1.7.17+azure
  Kubelet Version:            v1.28.12
  Kube-Proxy Version:         v1.28.12
ProviderID:                   azure:///subscriptions/85e0e9ba-41ad-4854-88b5-645d7815fc5c/resourceGroups/mc_rg-aks-japaneast/providers/Microsoft.Compute/virtualMachineScaleSets/aksnpw22/virtualMachines/0
Non-terminated Pods:          (6 in total)
  Namespace                   Name                                CPU Requests  CPU Limits  Memory Requests  Memory Limits  Age
  ---------                   ----                                ------------  ----------  ---------------  -------------  ---
  default                     hpc                                 0 (0%)        0 (0%)      0 (0%)           0 (0%)         5m12s
  kube-system                 ama-logs-windows-2thb4              200m (0%)     2400m (7%)  250Mi (0%)       2448Mi (2%)    6m57s
  kube-system                 ama-metrics-win-node-vbctn          600m (1%)     500m (1%)   1124Mi (0%)      1524Mi (1%)    6m57s
  kube-system                 cloud-node-manager-windows-tmzqx    50m (0%)      0 (0%)      50Mi (0%)        512Mi (0%)     6m57s
  kube-system                 csi-azuredisk-node-win-blxgn        40m (0%)      0 (0%)      40Mi (0%)        150Mi (0%)     6m57s
  kube-system                 csi-azurefile-node-win-2xh65        40m (0%)      0 (0%)      40Mi (0%)        150Mi (0%)     6m57s
Allocated resources:
  (Total limits may be over 100 percent, i.e., overcommitted.)
  Resource           Requests     Limits
  --------           --------     ------
  cpu                930m (2%)    2900m (9%)
  memory             1504Mi (1%)  4784Mi (4%)
  ephemeral-storage  0 (0%)       0 (0%)
Events:
  Type     Reason                   Age                    From             Message
  ----     ------                   ----                   ----             -------
  Normal   Starting                 23m                    kube-proxy
  Normal   Starting                 6m49s                  kube-proxy
  Normal   Starting                 23m                    kubelet          Starting kubelet.
  Normal   NodeHasSufficientMemory  23m (x3 over 23m)      kubelet          Node aksnpw22000000 status is now: NodeHasSufficientPID
  Warning  Rebooted                 23m (x2 over 23m)      kubelet          Node aksnpw22000000 has been rebooted, boot id: 10
  Normal   NodeReady                23m (x2 over 23m)      kubelet          Node aksnpw22000000 status is now: NodeReady
  Normal   Starting                 6m57s                  kubelet          Starting kubelet.
  Normal   NodeHasSufficientMemory  6m57s (x2 over 6m57s)  kubelet          Node aksnpw22000000 status is now: NodeHasSufficientPID
  Normal   NodeReady                6m56s                  kubelet          Node aksnpw22000000 status is now: NodeReady
  Normal   RegisteredNode           6m55s                  node-controller  Node aksnpw22000000 event: Registered Node aksnpw22000000 in Controller```


### Q: 如何獲得 Process 資訊?

```dotnetcli
PS C:\k> Get-Process | Sort-Object CPU -Descending

Handles  NPM(K)    PM(K)      WS(K)     CPU(s)     Id  SI ProcessName
-------  ------    -----      -----     ------     --  -- -----------
    934     206   321700     261124     215.11   2604   0 MsMpEng
    975      47    50820      66644     188.70   2168   0 containerd
    407      29    54236      82620      51.27    952   0 kubelet
   1329      92    46244      69640      50.02   4632   8 svchost
  11455       0       44        148      44.17      4   0 System
    827      35    12380      30908      17.42  10392  10 svchost
    826      35    12080      30544      17.36   9312   9 svchost
    837      56    79316     102744       8.53   7344   6 powershell
    826      51    73744      96000       8.52   4816   8 powershell
    556      36    45896      63072       7.39   5780   0 WindowsAzureGuestAgent
    687      40    60376      76184       6.09  12280   8 powershell
    621      39    59392      73040       6.05   2000   6 powershell
    899      41    62888      79700       5.84   5412   0 WaAppAgent
    809      30     9844      27992       5.75   9056   6 svchost
    529      25    15800      32284       5.42   2292   0 svchost
    248      14    12620      21304       4.92  10680   8 TiWorker
    635      18     3976       9340       4.56    996   0 svchost
   1223      32   109564     124068       4.41   6500   0 powershell
    509      12     3928       7988       4.22    760   0 services
    434      25     5744      18640       4.08   2072   8 svchost
    215      19    27148      39644       3.97   6692   0 kube-proxy
    515      23    13732      29568       3.89   2760   6 svchost
    417      17     8500      16136       3.81   4168   8 svchost
    455      35     7516      18800       3.64   2868   0 svchost
    436      17    11732      22324       3.59   1148   0 svchost
    490     103    26196      33628       3.17   2968   6 fluent-bit
    527      24    14376      31564       3.14   9480   8 svchost
    376      15     1952       6608       3.13   6984   8 csrss
    166      18    36124      52296       2.98   2012   8 otelcollector
    342      15    16340      20544       2.97   1460   0 svchost
    957      21     5176      14868       2.77    772   0 lsass
    528     153    27504      34648       2.72   6204   8 fluent-bit
    234      15     9640      10636       2.64   3928   0 svchost
    538      23    13552      30092       2.61   9808   9 svchost
    506      23    13256      29916       2.55  11084  10 svchost
    419      18    11944      24604       2.44   8276   5 svchost
    214      14    17608      17720       2.48   4084   0 containerd-shim-runhcs-v1
    362      15    39624      58196       2.39  11764   8 telegraf
    316      17     3892      12564       2.22   1704   0 svchost
    119      10    23048      32368       2.09   8520   5 cloud-node-manager
    863      22     4868      15524       2.03   8760   8 lsass
    178      11     6648      13380       1.97  11608  10 WmiPrvSE
    211      12    19544      19324       1.95   4016   0 containerd-shim-runhcs-v1
    825      21     4672      14092       1.86   8768   6 lsass
    209      12    19676      19472       1.77   3892   0 containerd-shim-runhcs-v1
    161      16    19988      25260       1.77   9912   9 addon-token-adapter-win
    206      11     2440       6064       1.69   8644   6 services
    646      31    80076      88240       1.61   5560   0 powershell
    224      11     2460       7380       1.61    572   8 services
    213      13     4684      10928       1.61   4216   0 NisSrv
    427      23     9600      20632       1.56   4904   0 taskhostw
    363      18     5956      20904       1.52  11652   8 MoUsoCoreWorker
    583      31    79760      89672       1.50   5632   0 powershell
    156      13    20564      31800       1.44   6840   0 azurefileplugin
    147      14    20472      30212       1.33   6660   0 azurediskplugin
    151      16    19976      25136       1.31  10640  10 addon-token-adapter-win
     90       6     1288       5056       1.31   8316   8 CExecSvc
    332      23     8908      21780       1.27  11508   8 MetricsExtension.Native
    221      14    18092      18008       1.23   3400   0 containerd-shim-runhcs-v1
    574      35    13872      33724       1.22  12096   6 MonAgentCore
    256      13     3352      13268       1.14   1364   0 vmcompute
    403      31     6432      14368       1.13   1932   0 svchost
    779      21     4020      14148       1.03   4936   9 lsass
    227      15     4596      13480       1.02     80   8 WmiPrvSE
    614      36     5988      18780       0.98   8268   6 svchost
    221      14    18272      17808       0.94   5084   0 containerd-shim-runhcs-v1
    626      36     6100      20280       0.92   3852   8 svchost
     83       7     1216       5448       0.97   5672   0 conhost
    783      21     3960      14112       0.91   9636  10 lsass
    569      35    13596      33452       0.91  11716   8 MonAgentCore
    186      12    17324      16808       0.83   3976   0 containerd-shim-runhcs-v1
    274      15     2616       7864       0.80   1836   0 svchost
    402      16     7204      13608       0.80   9192   6 svchost
     52       4     1116       1708       0.78   8112   0 smss
    390      24     8120      23808       0.73   3656   6 MonAgentManager
    599      24     1988       5268       0.72    552   0 csrss
    205      11     2208       7112       0.70   9604  10 services
    708      17     3232      13096       0.69   6112   5 lsass
    144      10     1660       6028       0.69    464   0 svchost
     89       6     1176       3936       0.67   9128   6 CExecSvc
    247      14     5528      14136       0.66   9548   6 AzureProfilerExtension
    247      14     5680      14184       0.59   9904   8 AzureProfilerExtension
    281      13    16296      15832       0.59   5132   0 azure-vnet-telemetry
    388      24     8256      24440       0.58  10204   8 MonAgentManager
    390      16     8644      16340       0.55   9884   9 svchost
      0     101    35520     136160       0.55    104   0 Registry
    428      15     2688       8968       0.52   2040   8 svchost
    378      16     8276      16032       0.50  10720  10 svchost
    202      11     2136       7044       0.50   6780   9 services
    358      26     3484      13084       0.48   2276   0 svchost
    494      16     2284      10028       0.47   6556   4 lsass
    133      13    18740      15828       0.47   7132   0 csi-node-driver-registrar
    600      34     5836      20268       0.47  10892  10 svchost
    668      23    39944      35132       0.45   1260   0 vmms
    322      14     2156       5544       0.44   8320   6 csrss
    227      13     5292      12440       0.44   9464   6 AzurePerfCollectorExtension
    118      11    18260      14260       0.44   7140   0 csi-node-driver-registrar
    229      13     5456      12452       0.44  10172   8 AzurePerfCollectorExtension
    608      34     5884      20220       0.42  10092   9 svchost
    486      24    57384      59240       0.42   4328   0 powershell
    136      11     2224       7920       0.42   6460   6 MonAgentHost
    494      15     2244       9984       0.41   6540   2 lsass
    129       9     3168       8064       0.41   5076   6 svchost
    129       8     3148       9572       0.38  11120  10 svchost
    366      13     2556       8928       0.38   2212   0 svchost
    289      12     3108       8808       0.36    888   0 svchost
    244      10     2392      10756       0.36   4732   5 svchost
    129       8     3132       9564       0.36   9812   8 svchost
    129       8     1364       4800       0.36    808   0 svchost
    389      15     2396       7856       0.36   8972   6 svchost
    163      10     6540      13332       0.34   5008   0 conhost
    494      15     2248       9980       0.33   6548   3 lsass
    466      26     4220      13704       0.33   8228   5 svchost
    221      10     1988       6728       0.33   1824   0 svchost
    278      20     8288      15156       0.33   3920   0 svchost
    361      15     2676       9796       0.31   2856   0 svchost
    336      13     2648       9800       0.31   8952   6 svchost
     57       3     1064       1260       0.30    404   0 smss
    129       9     1952       8524       0.30  11464   8 MonAgentHost
    365      14     3764      10844       0.30   2100   0 svchost
    146      10     6528      13376       0.28   5684   0 conhost
    129       8     3128       9564       0.28   7212   9 svchost
    131      16     3076       6272       0.28   1512   0 svchost
    347      14     2872      11372       0.28   7852   8 svchost
    130       9     3036       9040       0.28   2504   0 svchost
    250      13     1916       6464       0.27   9424  10 csrss
    209      12     2464       7680       0.27    696   1 winlogon
    174       9     1572       6084       0.27   6776   5 services
    324      23     3320      10164       0.27   7452   3 svchost
    161       9     1492       5760       0.27   6504   3 services
    146      10     6528      13380       0.25   5652   0 conhost
    380      12     2408       8704       0.25   3816  10 svchost
    244      12     1848       6404       0.25   5792   9 csrss
    237      10     2332      10484       0.25   6968   4 svchost
    161       9     1480       5748       0.23   6520   2 services
    162      13    20532      11044       0.23   3548   0 csi-proxy
    326      23     3304      10140       0.22   7396   2 svchost
    370      12     2368       8672       0.22   8556   9 svchost
    330      13     2588      10884       0.20   5536   9 svchost
    238      10     2308      10472       0.20   6164   3 svchost
    186      15     3316       9800       0.20   5572   8 svchost
    227      15     2032       7632       0.20   1896   0 svchost
    150      11     1444       5372       0.20   8592   6 wininit
     52       4     1068       1696       0.20   8324   0 smss
    200      12     1784       4704       0.20    632   1 csrss
    161       9     1484       5736       0.20   6512   4 services
    182      15     3168       8404       0.19   9100   6 svchost
    237      14     2656      10724       0.19   3832   6 msdtc
    157      11     6792      14704       0.19   1280   1 conhost
    204      11     2608       8948       0.19   2716   0 svchost
    289      12     4872      10756       0.17   7316   4 svchost
    289      12     4832      10732       0.16   7332   2 svchost
    166       9     1652       6392       0.16   2360   0 svchost
     81       6      928       3772       0.16   5204   8 PING
    131       8     2012       6724       0.16   2688   0 nssm
    150      11     1348       7388       0.16   4968   8 wininit
    165      10     2752       9960       0.16   4656   0 WmiPrvSE
    152      10     2264       7940       0.16  11548   8 TrustedInstaller
    107       8     1472       4584       0.16   3144   6 MonAgentLauncher
    238      10     2316      10480       0.16   6172   2 svchost
    227      14     2672      12296       0.16   1188   0 svchost
    237      13     2628      10708       0.14   7932   8 msdtc
    512      18     4064      11236       0.14    508   0 svchost
    323      25     3224      10072       0.14   7460   4 svchost
    209      13     1740       6628       0.13   2580   0 svchost
    172      10     1724       7444       0.13   7444   6 notepad
    275      16     2944      13124       0.13   1140   1 LogonUI
    336      13     5496      12152       0.13   4020   5 svchost
    140       9     1472       8024       0.13   2332   0 svchost
    146      10     6528      13332       0.13   2780   0 conhost
    150      11     1340       7384       0.13   9520  10 wininit
    131       8     2016       6776       0.13   2020   0 nssm
    272      14     2148       7892       0.11    460   0 svchost
    116       8     1312       4620       0.11   1080   0 svchost
    175      12     2540       9212       0.11  10476  10 svchost
    289      12     5016      10848       0.09   7352   3 svchost
    237      13     2568      10660       0.09   5408  10 msdtc
    177      13     2696       9216       0.09   9488   9 svchost
    330      13     2588      10892       0.09  10192  10 svchost
     50       3      508       1648       0.09   8060   0 smss
     52       4     1076       1700       0.09   3428   0 smss
    150      11     1340       7380       0.09   8720   9 wininit
    237      13     2572      10664       0.09   6644   9 msdtc
    208       8     1580       7304       0.09   7004   4 svchost
    208       8     1568       7284       0.08   6052   2 svchost
    208       8     1644       7352       0.08   7012   3 svchost
    163       7     1468       5688       0.08   6852   4 svchost
    163       7     1464       5700       0.08   6844   3 svchost
    178      11     1724       6972       0.08   1668   0 svchost
     50       3      512       1632       0.08    972   0 smss
    201      10     2120       7740       0.08   2552   0 svchost
    140       9     1616       5488       0.08   1644   6 svchost
     52       4     1068       1696       0.08   9332   0 smss
     95       8      896       4640       0.06   6316   2 wininit
     82       6     2340       4448       0.06   6472   0 cmd
     96       6     1284       4956       0.06   5568   3 svchost
    158      10     1624       7384       0.06   1720   0 svchost
    136       9     1312       5268       0.06   1332   0 svchost
     39       6     1328       3152       0.06    912   1 fontdrvhost
     86       7     2744       6936       0.06  10248   8 conhost
     93       6      924       2644       0.06   8140   5 csrss
     50       3      516       1628       0.06   4152   0 smss
    161      10     1608       6804       0.06   3584   0 svchost
     95       8      908       4640       0.05   6988   5 wininit
     83       6      988       4812       0.05  10568  10 CExecSvc
    171       8     1576       6100       0.05   4040   5 svchost
     95       8      896       4632       0.05   6312   3 wininit
    237      13     1612       7424       0.05   3512   5 svchost
    139       9     1532       5592       0.05   2564   0 svchost
     39       6      808       3228       0.05   2880   9 fontdrvhost
    105       8     1180       4216       0.05   2452   0 svchost
    101       7     1584       5600       0.05   1040   5 svchost
    150      11     1328       5300       0.05    624   0 wininit
    236      13     3064      11012       0.05   4532   0 msdtc
     86       6     1040       4964       0.05   9584   9 CExecSvc
    167      13     1608       7536       0.05   5544   0 svchost
    118       8     1336       5908       0.05   5692   0 svchost
    108       8     1148       4276       0.05   1348   0 svchost
    125      11     1900       7628       0.05    660   0 sshd
     91       8     2812       5772       0.03   5460   6 conhost
     74       6      844       4544       0.03  11032   8 AggregatorHost
    143       9     1500       6436       0.03   2284   0 svchost
    134       9     1500       6020       0.03   2424   0 svchost
    117       8     1224       6324       0.03   9412   8 svchost
     86       7     2728       6928       0.03   3520   8 conhost
     74       6      848       4544       0.03  10952   9 AggregatorHost
     80       5     2264       4168       0.03  11940   0 cmd
     39       6      820       2408       0.03   8888   6 fontdrvhost
     76       6      916       3104       0.03   3464   6 AggregatorHost
    142       9     1440       7160       0.03   5032   0 svchost
     50       3      512       1628       0.03   2352   0 smss
    157       9     1768       6836       0.03   1576   0 svchost
     43       4      456       2400       0.03   7796   4 pause
     92       6     1164       4912       0.03   6720   4 svchost
     78       5      840       4136       0.03   4404   2 CExecSvc
    162      10     1556       6148       0.03   1504   0 svchost
     75       6     1060       4092       0.03    556   0 WaSecAgentProv
     86       7     2788       5656       0.03   6240   6 conhost
    134       8     2056       6904       0.03   6012   0 nssm
     86       7     2748       6932       0.03  12208   8 conhost
     86       7     6180      10336       0.03   4696   0 conhost
    117       8     1216       6316       0.02  10964  10 svchost
    140       9     1552       7216       0.02  11140  10 svchost
     74       6      848       2940       0.02   3168   0 AggregatorHost
     90       6      800       2548       0.02   3880   3 csrss
     95       8      904       4640       0.02   6328   4 wininit
     82       6     2224       4328       0.02   7076   0 cmd
     74       6      844       4540       0.02  10244  10 AggregatorHost
    117       8     1200       4648       0.02   2268   0 svchost
     90       6      860       2576       0.02   5396   2 csrss
    112       8     1300       4512       0.02   1052   0 svchost
    117       8     1272       4708       0.02   8424   6 svchost
     78       5      840       4132       0.02   6220   4 CExecSvc
    100       6     1076       4868       0.02  10408   8 MonAgentLauncher
    125       8     1228       4768       0.02   1288   0 svchost
     92       6     1160       4912       0.02   6712   2 svchost
    125       8     1384       5420       0.02   1532   0 svchost
    163       7     1468       5696       0.02   6456   2 svchost
     86       7     6188      10324       0.02    616   0 conhost
    131       8     2012       6752       0.02   4788   0 nssm
    269      14     2576       8640       0.02   5900   0 svchost
    117       8     1220       6316       0.02   9428   9 svchost
     86       7     6176      10376       0.02   6700   0 conhost
    144       8     1336       4912       0.02   1468   0 svchost
     39       6     1200       2772       0.02    916   0 fontdrvhost
     39       6      800       3220       0.02   9844  10 fontdrvhost
     43       4      456       2400       0.00   7804   2 pause
     91       7     2740       6944       0.00  11916   8 conhost
     43       4      456       2400       0.00   7788   3 pause
     78       5      844       4136       0.00   5068   3 CExecSvc
     39       6      792       3180       0.00   4556   8 fontdrvhost
      0       0      172      47124       0.00     56   0 Secure System
     79       5     2276       4152       0.00   9952   0 cmd
     82       6     2232       4320       0.00   6408   0 cmd
     78       5      872       4232       0.00   5292   5 CExecSvc
     79       5     2188       4184       0.00   7084   0 cmd
     90       6      864       2576       0.00   3476   4 csrss
      0       0       60          8                 0   0 Idle
```

### Q: 如何知道 Process 的優先級?

```powershell
PS C:\k> $process = Get-Process -Name containerd
PS C:\k> $process | Select-Object Name, Id, PriorityClass

Name         Id PriorityClass
----         -- -------------
containerd 2168        Normal

PS C:\k> $process = Get-Process -Name kubelet
PS C:\k> $process | Select-Object Name, Id, PriorityClass

Name     Id PriorityClass
----     -- -------------
kubelet 952        Normal
```

### Q: 手動修改 Process 優先級, 重開機會不會更新數值?

調整完後重開機, 會發現數值沒有變化.

```powershell
$process = Get-Process -Name containerd
$process.PriorityClass = [System.Diagnostics.ProcessPriorityClass]::High
$process | Select-Object Name, Id, PriorityClass

$process = Get-Process -Name kubelet
$process.PriorityClass = [System.Diagnostics.ProcessPriorityClass]::High
$process | Select-Object Name, Id, PriorityClass

Restart-Computer
```

### Q: 列舉 Task

```powershell
PS C:\AzureData\windows> Get-ScheduledTask | Format-Table -Property TaskName, State, LastRunTime, NextRunTime

TaskName                                                State LastRunTime NextRunTime
--------                                                ----- ----------- -----------
aks-log-generator-task                                  Ready
k8s-restart-job                                         Ready
log-cleanup-task                                        Ready
.NET Framework NGEN v4.0.30319                          Ready
.NET Framework NGEN v4.0.30319 64                       Ready
.NET Framework NGEN v4.0.30319 64 Critical           Disabled
.NET Framework NGEN v4.0.30319 Critical              Disabled
AD RMS Rights Policy Template Management (Automated) Disabled
AD RMS Rights Policy Template Management (Manual)       Ready
EDP Policy Manager                                      Ready
PolicyConverter                                      Disabled
VerifiedPublisherCertStoreCheck                      Disabled
SystemTask                                              Ready
UserTask                                                Ready
UserTask-Roam                                           Ready
ProactiveScan                                           Ready
SyspartRepair                                           Ready
Consolidator                                            Ready
Data Integrity Check And Scan                           Ready
Data Integrity Scan                                     Ready
Data Integrity Scan for Crash Recovery                  Ready
ScheduledDefrag                                         Ready
Device                                                  Ready
Device User                                             Ready
MDMMaintenenceTask                                      Ready
ExploitGuard MDM policy Refresh                         Ready
ReconcileFeatures                                       Ready
UsageDataFlushing                                       Ready
UsageDataReporting                                      Ready
RefreshCache                                            Ready
LPRemove                                                Ready
GatherNetworkInfo                                       Ready
SDN Diagnostics Task                                 Disabled
Secure-Boot-Update                                      Ready
Sqm-Tasks                                               Ready
GAEvents                                              Running
RTEvents                                              Running
Server Manager Performance Monitor                   Disabled
Device Install Group Policy                             Ready
Device Install Reboot Required                          Ready
Sysprep Generalize Drivers                              Ready
RegIdleBackup                                           Ready
CleanupOldPerfLogs                                      Ready
StartComponentCleanup                                   Ready
CreateObjectTask                                        Ready
UpdateUserPictureTask                                   Ready
Collection                                           Disabled
Configuration                                           Ready
SvcRestartTask                                          Ready
SvcRestartTaskLogon                                  Disabled
SvcRestartTaskNetwork                                Disabled
SpaceAgentTask                                          Ready
SpaceManagerTask                                        Ready
MaintenanceTasks                                        Ready
Storage Tiers Management Initialization                 Ready
Storage Tiers Optimization                           Disabled
MsCtfMonitor                                            Ready
SynchronizeTime                                         Ready
SynchronizeTimeZone                                     Ready
Tpm-HASCertRetr                                         Ready
Tpm-Maintenance                                         Ready
Report policies                                         Ready
Schedule Maintenance Work                            Disabled
Schedule Scan                                           Ready
Schedule Scan Static Task                               Ready
Schedule Wake To Work                                Disabled
Schedule Work                                        Disabled
USO_UxBroker                                            Ready
UUS Failover Task                                       Ready
HiveUploadTask                                       Disabled
PerformRemediation                                   Disabled
ResolutionHost                                          Ready
Windows Defender Cache Maintenance                      Ready
Windows Defender Cleanup                                Ready
Windows Defender Scheduled Scan                         Ready
Windows Defender Verification                           Ready
QueueReporting                                          Ready
BfeOnServiceStartTypeChange                             Ready
Refresh Group Policy Cache                              Ready
Scheduled Start                                         Ready
CacheTask                                               Ready
```

### Q: 如何修改 pagefile 大小?

```dotnetcli
$pagefile Get-WmiObject -Query "Select * From Win32_PageFileSetting Where Name like '%pagefile.sys'"
$computersys = Get-WmiObject Win32_ComputerSystem -EnableAllPrivileges;
$computersys.AutomaticManagedPagefile = $False;
$computersys.Put();
$pagefile = Get-WmiObject -Query "Select * From Win32_PageFileSetting Where Name like '%pagefile.sys'";
$pagefile.InitialSize = 20480;
$pagefile.MaximumSize = 20480;
$pagefile.Put();
Get-WmiObject -Query "Select * From Win32_PageFileSetting Where Name like '%pagefile.sys'"
Restart-Computer
```

### Q: 如何獲取開機時間總長？

```dotnetcli
$os = Get-CimInstance -ClassName Win32_OperatingSystem
$uptime = (Get-Date) - $os.LastBootUpTime
Write-Output "系統已運行時間: $($uptime.Days) 天 $($uptime.Hours) 小時 $($uptime.Minutes) 分鐘 $($uptime.Seconds) 秒"
```

### Q: 列舉 PageFile 設置

```dotnetcli
$pageFileSettings = Get-WmiObject -Query "SELECT * FROM Win32_PageFileSetting"

foreach ($setting in $pageFileSettings) {
    Write-Output "Caption: $($setting.Caption)"
    Write-Output "Description: $($setting.Description)"
    Write-Output "Element: $($setting.Element)"
    Write-Output "InitialSize: $($setting.InitialSize)"
    Write-Output "MaximumSize: $($setting.MaximumSize)"
    Write-Output "Name: $($setting.Name)"
    Write-Output "SettingID: $($setting.SettingID)"
    Write-Output "-----------------------------"
}
```

### Q: 顯示 svchost process 中的 CommandLine 字串

```dotnetcli
Get-WmiObject Win32_Process | Where-Object { $_.CommandLine -like '*svchost*' } | Select-Object Name, ProcessId, CommandLine

PS C:\k\debug> Get-WmiObject Win32_Process | Where-Object { $_.CommandLine -like '*svchost*' } | Select-Object Name, ProcessId, CommandLine

Name        ProcessId CommandLine
----        --------- -----------
svchost.exe      1952 C:\Windows\system32\svchost.exe -k DcomLaunch -p
svchost.exe      1536 C:\Windows\system32\svchost.exe -k RPCSS -p
svchost.exe      1664 C:\Windows\system32\svchost.exe -k DcomLaunch -p -s LSM
svchost.exe      2064 C:\Windows\System32\svchost.exe -k termsvcs -s TermService
svchost.exe      2084 C:\Windows\system32\svchost.exe -k LocalSystemNetworkRestricted -p -s HvHost
svchost.exe      2104 C:\Windows\System32\svchost.exe -k LocalServiceNetworkRestricted -p -s lmhosts
svchost.exe      2112 C:\Windows\system32\svchost.exe -k ICService -p -s vmicheartbeat
svchost.exe      2132 C:\Windows\system32\svchost.exe -k LocalSystemNetworkRestricted -p -s vmickvpexchange
svchost.exe      2140 C:\Windows\system32\svchost.exe -k LocalSystemNetworkRestricted -p -s vmicshutdown
svchost.exe      2224 C:\Windows\system32\svchost.exe -k LocalServiceNetworkRestricted -p -s vmictimesync
svchost.exe      2540 C:\Windows\system32\svchost.exe -k netsvcs -p -s Winmgmt
svchost.exe      2616 C:\Windows\System32\svchost.exe -k LocalSystemNetworkRestricted -p -s UmRdpService
svchost.exe      2864 C:\Windows\System32\svchost.exe -k LocalServiceNetworkRestricted -p -s EventLog
svchost.exe      2872 C:\Windows\system32\svchost.exe -k netsvcs -s CertPropSvc
svchost.exe      2948 C:\Windows\system32\svchost.exe -k netsvcs -p -s gpsvc
svchost.exe      2956 C:\Windows\system32\svchost.exe -k netsvcs -p -s ProfSvc
svchost.exe      2968 C:\Windows\system32\svchost.exe -k LocalService -p -s EventSystem
svchost.exe      2976 C:\Windows\system32\svchost.exe -k LocalService -p -s nsi
svchost.exe      2336 C:\Windows\system32\svchost.exe -k netsvcs -p -s SENS
svchost.exe      2396 C:\Windows\system32\svchost.exe -k netsvcs -p -s Schedule
svchost.exe      2464 C:\Windows\system32\svchost.exe -k LocalServiceNetworkRestricted -p -s Dhcp
svchost.exe      2468 C:\Windows\system32\svchost.exe -k NetworkService -p -s Dnscache
svchost.exe      2656 C:\Windows\System32\svchost.exe -k NetworkService -p -s LanmanWorkstation
svchost.exe      3076 C:\Windows\system32\svchost.exe -k LocalServiceNoNetworkFirewall -p
svchost.exe      3228 C:\Windows\System32\svchost.exe -k netsvcs -p -s SessionEnv
svchost.exe      3288 C:\Windows\system32\svchost.exe -k LocalServiceNetworkRestricted -p -s TimeBrokerSvc
svchost.exe      3452 C:\Windows\system32\svchost.exe -k LocalServiceNoNetwork -p
svchost.exe      3460 C:\Windows\system32\svchost.exe -k NetworkService -p -s CryptSvc
svchost.exe      3468 C:\Windows\system32\svchost.exe -k appmodel -p -s StateRepository
svchost.exe      3476 C:\Windows\system32\svchost.exe -k LocalServiceNetworkRestricted -p -s WinHttpAutoProxySvc
svchost.exe      3500 C:\Windows\system32\svchost.exe -k netsvcs -p -s IKEEXT
svchost.exe      3544 C:\Windows\system32\svchost.exe -k netsvcs -p -s UserManager
svchost.exe      3536 C:\Windows\System32\svchost.exe -k netsvcs -p -s sacsvr
svchost.exe      3556 C:\Windows\System32\svchost.exe -k utcsvc -p
svchost.exe      3564 C:\Windows\System32\svchost.exe -k NetworkService -p -s NlaSvc
svchost.exe      3572 C:\Windows\system32\svchost.exe -k LocalSystemNetworkRestricted -p -s SysMain
svchost.exe      3596 C:\Windows\system32\svchost.exe -k LocalService -s W32Time
svchost.exe      3828 C:\Windows\system32\svchost.exe -k NetworkServiceNetworkRestricted -p -s PolicyAgent
svchost.exe      4000 C:\Windows\System32\svchost.exe -k NetSvcs -p -s iphlpsvc
svchost.exe      3220 C:\Windows\System32\svchost.exe -k NetworkService -p -s WinRM
svchost.exe      4120 C:\Windows\System32\svchost.exe -k smbsvcs -s LanmanServer
svchost.exe      4248 C:\Windows\System32\svchost.exe -k LocalService -p -s netprofm
svchost.exe      4524 C:\Windows\system32\svchost.exe -k NetSvcs -p -s hns
svchost.exe      4712 C:\Windows\system32\svchost.exe -k NetSvcs -s nvagent
svchost.exe      4824 C:\Windows\System32\svchost.exe -k netsvcs -p -s SharedAccess
svchost.exe      5988 C:\Windows\System32\svchost.exe -k LocalServiceNoNetwork -p -s pla
svchost.exe      8248 C:\Windows\system32\svchost.exe -k DcomLaunch -p
svchost.exe      8256 C:\Windows\system32\svchost.exe -k DcomLaunch -p
svchost.exe      8324 C:\Windows\system32\svchost.exe -k RPCSS -p
svchost.exe      8316 C:\Windows\system32\svchost.exe -k RPCSS -p
svchost.exe      8532 C:\Windows\system32\svchost.exe -k netsvcs -p
svchost.exe      8540 C:\Windows\system32\svchost.exe -k netsvcs -p
svchost.exe      8616 C:\Windows\system32\svchost.exe -k LocalService -p
svchost.exe      8632 C:\Windows\system32\svchost.exe -k LocalService -p
svchost.exe      8868 C:\Windows\system32\svchost.exe -k DcomLaunch -p
svchost.exe      8924 C:\Windows\System32\svchost.exe -k LocalServiceNetworkRestricted -p
svchost.exe      8916 C:\Windows\System32\svchost.exe -k LocalServiceNetworkRestricted -p
svchost.exe      8964 C:\Windows\system32\svchost.exe -k RPCSS -p
svchost.exe      9056 C:\Windows\system32\svchost.exe -k NetworkService -p
svchost.exe      9072 C:\Windows\system32\svchost.exe -k NetworkService -p
svchost.exe      9236 C:\Windows\system32\svchost.exe -k netsvcs -p
svchost.exe      9748 C:\Windows\system32\svchost.exe -k LocalService -p
svchost.exe     10076 C:\Windows\System32\svchost.exe -k LocalServiceNetworkRestricted -p
svchost.exe     10132 C:\Windows\system32\svchost.exe -k NetworkService -p
svchost.exe      9956 C:\Windows\system32\svchost.exe -k DcomLaunch -p
svchost.exe      9912 C:\Windows\system32\svchost.exe -k RPCSS -p
svchost.exe     10244 C:\Windows\system32\svchost.exe -k netsvcs -p
svchost.exe     10272 C:\Windows\system32\svchost.exe -k LocalService -p
svchost.exe     10360 C:\Windows\System32\svchost.exe -k LocalServiceNetworkRestricted -p
svchost.exe     10396 C:\Windows\system32\svchost.exe -k NetworkService -p
svchost.exe     10480 C:\Windows\System32\svchost.exe -k utcsvc -p
svchost.exe     11188 C:\Windows\system32\svchost.exe -k RPCSS -p
svchost.exe     11208 C:\Windows\system32\svchost.exe -k DcomLaunch -p
svchost.exe     10380 C:\Windows\system32\svchost.exe -k netsvcs -p
svchost.exe     10604 C:\Windows\system32\svchost.exe -k LocalService -p
svchost.exe     10796 C:\Windows\System32\svchost.exe -k LocalServiceNetworkRestricted -p
svchost.exe     11296 C:\Windows\system32\svchost.exe -k NetworkService -p
svchost.exe     11416 C:\Windows\system32\svchost.exe -k LocalServiceNoNetwork -p
svchost.exe     11444 C:\Windows\system32\svchost.exe -k appmodel -p
svchost.exe     11476 C:\Windows\System32\svchost.exe -k utcsvc -p
svchost.exe      5108 C:\Windows\system32\svchost.exe -k RPCSS -p
svchost.exe      1608 C:\Windows\system32\svchost.exe -k DcomLaunch -p
svchost.exe     12380 C:\Windows\system32\svchost.exe -k netsvcs -p
svchost.exe      7300 C:\Windows\system32\svchost.exe -k LocalService -p
svchost.exe      8288 C:\Windows\System32\svchost.exe -k LocalServiceNetworkRestricted -p
svchost.exe      8200 C:\Windows\system32\svchost.exe -k NetworkService -p
svchost.exe     11184 C:\Windows\System32\svchost.exe -k utcsvc -p
svchost.exe     10188 C:\Windows\system32\svchost.exe -k appmodel -p
svchost.exe      2272 C:\Windows\system32\svchost.exe -k RPCSS -p
svchost.exe      6356 C:\Windows\system32\svchost.exe -k DcomLaunch -p
svchost.exe      9020 C:\Windows\system32\svchost.exe -k DcomLaunch -p
svchost.exe      7500 C:\Windows\system32\svchost.exe -k RPCSS -p
svchost.exe      1676 C:\Windows\system32\svchost.exe -k LocalSystemNetworkRestricted -p
svchost.exe     12548 C:\Windows\system32\svchost.exe -k LocalServiceNoNetwork -p
svchost.exe     13012 C:\Windows\system32\svchost.exe -k netsvcs -p
svchost.exe     12860 C:\Windows\system32\svchost.exe -k netsvcs -p
svchost.exe     12084 C:\Windows\system32\svchost.exe -k LocalService -p
svchost.exe     11280 C:\Windows\system32\svchost.exe -k LocalService -p
svchost.exe      9772 C:\Windows\System32\svchost.exe -k LocalServiceNetworkRestricted -p
svchost.exe      8892 C:\Windows\System32\svchost.exe -k LocalServiceNetworkRestricted -p
svchost.exe      7732 C:\Windows\system32\svchost.exe -k NetworkService -p
svchost.exe     10292 C:\Windows\system32\svchost.exe -k NetworkService -p
svchost.exe     13364 C:\Windows\system32\svchost.exe -k LocalServiceNoNetwork -p
svchost.exe     13388 C:\Windows\System32\svchost.exe -k utcsvc -p
svchost.exe     13440 C:\Windows\system32\svchost.exe -k appmodel -p
svchost.exe     14228 C:\Windows\system32\svchost.exe -k LocalServiceNoNetwork -p
svchost.exe     14272 C:\Windows\system32\svchost.exe -k appmodel -p
svchost.exe     11272 C:\Windows\System32\svchost.exe -k utcsvc -p
svchost.exe     14692 C:\Windows\System32\svchost.exe -k LocalServiceNoNetwork -p -s DPS
svchost.exe     15352 C:\Windows\system32\svchost.exe -k LocalSystemNetworkRestricted -p -s UALSVC
svchost.exe     14040 C:\Windows\system32\svchost.exe -k netsvcs -p -s UsoSvc
svchost.exe     17012 C:\Windows\system32\svchost.exe -k DcomLaunch -p
svchost.exe     16632 C:\Windows\system32\svchost.exe -k RPCSS -p
svchost.exe      2216 C:\Windows\system32\svchost.exe -k netsvcs -p
svchost.exe     11092 C:\Windows\system32\svchost.exe -k LocalService -p
svchost.exe      8124 C:\Windows\System32\svchost.exe -k LocalServiceNetworkRestricted -p
svchost.exe      5628 C:\Windows\system32\svchost.exe -k NetworkService -p
svchost.exe     12544 C:\Windows\system32\svchost.exe -k DcomLaunch -p
svchost.exe     15988 C:\Windows\system32\svchost.exe -k RPCSS -p
svchost.exe      5912 C:\Windows\system32\svchost.exe -k netsvcs -p
svchost.exe      7328 C:\Windows\system32\svchost.exe -k LocalService -p
svchost.exe     11676 C:\Windows\System32\svchost.exe -k LocalServiceNetworkRestricted -p
svchost.exe      6852 C:\Windows\system32\svchost.exe -k NetworkService -p
svchost.exe      1780 C:\Windows\system32\svchost.exe -k DcomLaunch -p
svchost.exe     14560 C:\Windows\system32\svchost.exe -k RPCSS -p
svchost.exe      3348 C:\Windows\system32\svchost.exe -k netsvcs -p
svchost.exe     16816 C:\Windows\system32\svchost.exe -k LocalService -p
svchost.exe      7872 C:\Windows\System32\svchost.exe -k LocalServiceNetworkRestricted -p
svchost.exe     12680 C:\Windows\system32\svchost.exe -k NetworkService -p
```

### Q: 僅顯示 svchost 和 hns 中的 ProcessID

```dotnetcli
Get-WmiObject Win32_Process | Where-Object { $_.CommandLine -like "*svchost*" -and $_.CommandLine -like "*hns*" } | Select-Object -ExpandProperty ProcessId
```
