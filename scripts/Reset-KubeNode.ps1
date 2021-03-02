$ErrorActionPreference = "Continue"

function Remove-SymLinks {
    Get-ChildItem -Force -ErrorAction Stop @Args | Where-Object { if($_.Attributes -match "ReparsePoint"){$_.Delete()} }
}

Write-Host "Running kubeadm reset"
kubeadm.exe reset -f

sc.exe delete kubelet
sc.exe delete rancher-wins

Remove-SymLinks -Path  /var -Recurse

rm -r -fo /var
rm -r -fo /opt
rm -r -fo /etc
rm -r -fo /usr 

remove-NetFirewallRule  -DisplayName 'kubelet'
