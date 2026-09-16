# Windows Server Enterprise Infrastructure
# Active Directory account lockout policy

Set-ADDefaultDomainPasswordPolicy `
    -Identity "fred.castillo" `
    -LockoutThreshold 3 `
    -LockoutDuration "00:30:00" `
    -LockoutObservationWindow "00:30:00"

Write-Host "Account lockout policy configured." -ForegroundColor Green
