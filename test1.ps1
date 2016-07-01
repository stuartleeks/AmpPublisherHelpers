# To get the cookiesValue, log into the publisher portal in the browser
# then open the F12 tools and inspect a request in the network history
# and grab the cookies :-)
$cookiesValue = ".AspNet.Cookies=VC2cJSWN9_xDNIa2rflsO8MIvCOkNg2oqRtQFuHUtlERbHRQzsNsHBAZbeZ6tiSCZxRELyTFsWatViRndazvhQpskNvr7VwxpuZ996bjraf_IFpX2iLJCGZZxy2MLNDdwJBOOSFA0L0IX8fe_a8tRQJwdbk_jhGy5mm2R7QGG-wRjg4lWK-Zuw8f3Wyl3F13LKcK7riP9D8oyBlhbQseISlt2KPcmKK61u91IWCBlFSCgVnTGSuREeVo4sBoXPAGH1QQBvpoumhOdUU0airLNanmeMmmQ7itXEKTywIANnJewT5ADRb59A83XafnCzDu-DCO7-oHoREdpSlurzDG7Lf4LkygHh4Ddo9KAoie1fp8P_t7XURF3KSvdB3mwkKXZe-9bPf1ui8dBSa7pBwtwWruJ00_rPTtmFZOlHmC9HNaBxvetzXVJq-ReB7JjuZY26P4-fF2-G_WsFAmDxTNEqcF4dGKirB4BpP2XJ_cX8yHRHBRk2WasSQ0pGzMIH2SVv_KpewTI2jkd2VOtvsYHYKRjf4lxSorZSg_5pCAxWnZUoyRkEqs7u7QbuUHN87Gsa0ioTH3kwIm9Wlgu_Y_DvrPoXb6CBuyI-ieliVrA7tiiIey7V3YpCvsO-NjidYww5CQr01t6rQzxfS4JsuqCT6lX2_iXY6moCQWlCY66o0oaere7O5LvK_Z0YzSmCxPdJlQYUELC-ZR00oh2fficTa3DRaX7loZ7cwQdtATtlVPAxNgbFWIplQnMlmIG7Qx25bM_6sdaFs_fIGzMxkv3a2uDqoWmYqvmtoi_l3oADS1OZqV49mfyk3vT0Ww7upA3TzSR8ajiuSUF7RhVTwZmmVwaYxpNA4PxbD1kIGJMlT_DbGOsjYUIdkQRLH6MMkHi_xy8Omr0dE5MLYRXZg0txK_dFW1odSOtT7fsUwIVw-3dPabx3pXJ71x_1-d9Q3NpVinZY2SgDxFhK_PXmehQZoJG9Fqq_vQpYadCn_Y0YeASIc8vGiJkACGgFXgb1AzBfUb2czgXz7WzLE6aflCclm20TeqN_UxjX6fzLjsC6RqRxJnxXFUMkGAYPEvlINMYMXq8bxG2AkYEAxNx4nrDbp7QwPRXY-N7hHkJo2kmPZYYPl-; ai_user=nQV/Y|2016-07-01T08:09:38.205Z; ai_session=FLWkE|1467360578328|1467360631617"


$session = New-Object Microsoft.PowerShell.Commands.WebRequestSession

$cookiesValue.Split(";") | %{
    $cookieValue = $_.Trim()
    $index = $cookieValue.IndexOf("=")
    $name=$cookieValue.Substring(0,$index)
    $value =$cookieValue.Substring($index+1)

    $cookie = New-Object System.Net.Cookie 
    $cookie.Name = $name
    $cookie.Value = $value
    $cookie.Domain = "publish.windowsazure.com"
    $session.Cookies.Add($cookie)
}

Invoke-RestMethod `
        -Method Get `
        -Uri "https://publish.windowsazure.com/offers/10bc6598-7a23-4bfd-89ac-4cfc168ff3f7/history" `
        -Headers @{
            "Accept"= "application/json, text/javascript, */*; q=0.01"
        } `
        -WebSession $session

