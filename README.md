#  Azure Bastion VM Hardening Lab

##  Overview

Hands-on lab to harden a Windows Server VM in Azure using Azure Bastion, NSGs, BitLocker, and least-privilege access. 
Goal: secure remote access, reduce exposure, and verify hardening using real outputs and Azure exports.

---

##  Environment Setup

| Component          | Value                                    |
| ------------------ | ---------------------------------------- |
| **Resource Group** | RG-Lab1                                  |
| **Region**         | West US                                  |
| **VM**             | WinLab1 (Windows Server 2022 Datacenter) |
| **VNet**           | VNet-Lab1 (10.0.0.0/24)                  |
| **Bastion Subnet** | 10.0.1.0/26                              |
| **Access**         | Azure Bastion (Basic tier, 2 instances)  |

---

## Step 1 — Firewall Hardening

Restricted inbound RDP to only allow connections from the **Bastion subnet (10.0.1.0/26)**.

**Action**

* Windows Defender Firewall → Advanced Settings → Inbound Rules → RDP (3389)
* Remote IPs = `10.0.1.0/26`
* Local IP = Any

[Firewall Rule](./Screenshots/firewall-rule-bastion.PNG).
*Inbound rule restricted to Bastion subnet*

---

## Step 2 — User Account Segregation

Created a **standard user** `TestUser` for non-admin operations.
`LabAdmin` is the only administrator.

```powershell
net localgroup Administrators
```

[User Roles Verification](./Screenshots/user-roles-verification.PNG).
*Output showing only LabAdmin in Administrators group*

---

## Step 3 — UAC Privilege Enforcement

Logged in via Bastion as `TestUser` and attempted to open PowerShell as Administrator.
Attempting administrative actions triggered a UAC prompt, confirming that the standard account cannot elevate privileges.

[UAC Prompt](./Screenshots/uac-prompt.PNG)
*Standard account blocked from elevation*

> Bastion note: use `TestUser`, not `.\TestUser`, when signing in.

---

## Step 4 — System Hardening

* Turned on **BitLocker** for OS drive
* Installed all Windows Updates
* Ran a full Microsoft Defender scan (clean)

[BitLocker Status](./Screenshots/bitlocker-status.PNG)


[Update History](./Screenshots/update-history.PNG)


[Defender Scan](./Screenshots/defender-scan.PNG)



---

## Step 5 — Verification Script

Quick PowerShell health check to confirm CPU load, OS info, key services, and network connectivity.

```powershell
Get-CimInstance Win32_Processor | Measure-Object -Property LoadPercentage -Average
Get-CimInstance Win32_OperatingSystem
Get-Service Winmgmt, wuauserv, Dnscache, Spooler
Test-Connection 8.8.8.8 -Count 2
Resolve-DnsName www.microsoft.com
```

[Health Check Output 1](./Screenshots/healthcheck-output_1.PNG)


[Health Check Output 2](./Screenshots/healthcheck-output_2.PNG)

Artifacts stored in:

```
/scripts/healthcheck.ps1
/outputs/healthcheck.txt
```

---

## Repo Structure

```
Azure-Bastion-Hardening/

├── /screenshots/
│   ├── bitlocker-status.png
│   ├── defender-scan.png 
│   ├── firewall-rule-bastion.png  
│   ├── healthcheck-output_1.png       
│   ├── healthcheck-output_2.png    
│   ├── uac-prompt.png
│   ├── update-history.png
│   └── user-roles-verification.png
├── /azure-export/
│   ├── bastion.json 
│   ├── nsg-template.json
│   └── vm-template.json
├── /config/
│   ├── nsg-rules.txt
│   └── vnet-info.txt
│
├── /outputs/
│   └── healthcheck.txt
├── /scripts/
│   └── healthcheck.ps1
└── README.md
```

---

## Azure CLI Exports

**1. NSG Rules**  
All NSG rules for the lab VM are exported in [`nsg-rules.txt`](./config/nsg-rules.txt).  

**2. Bastion Configuration**  
Bastion details exported from Azure are available in [`bastion.json`](./azure-export/bastion.json).  

**3. VM Template**  
VM configuration details are saved in [`vm-template.json`](./azure-export/vm-template.json).  

**4. VNet Info**  
VNet Info details are saved in [`vnet-info.txt`](./config/vnet-info.txt). 

**5. NSG Template**  
NSG Template details are saved in [`nsg-template.json`](./azure-export/nsg-template.json). 

[View all exported Azure JSON files](./azure-export/)




---

## Results

* RDP limited to Bastion subnet
* Standard user cannot elevate
* BitLocker enabled
* NSG rules verified
* System patched and clean

**Outcome:** Hardened, access-controlled Azure VM ready for cloud-security and DevOps demonstrations.

---

## Notes

* Bastion doesn’t support `.\username` syntax for local logins.
* Always shut down the VM when idle to preserve free-tier credits.
* Export ARM templates after each build for version control.

---

**Author:** *Johnson Olumide*


**LinkedIn:** *www.linkedin.com/in/olumide-johnson-027a96151*
