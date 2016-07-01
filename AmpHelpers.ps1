function _NewWebSession($cookiesValue){
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
    $session
}
function Set-AmpCookies($cookiesValue){
    $global:_amp_session = _NewWebSession $cookiesValue
}


function Get-AmpUser{
    Invoke-RestMethod `
            -Method Get `
            -Uri "https://publish.windowsazure.com/user" `
            -Headers @{
                "Accept"= "application/json, text/javascript, */*; q=0.01"
            } `
            -WebSession $global:_amp_session
}
function Get-AmpPublisher{
    param(
        [Parameter(Position=0)]
        [string]
        $PublisherName
    )    
    $user = Get-AmpUser
    $publishers = $user.AccessiblePublishers
    if ([string]::IsNullOrEmpty($PublisherName)){
        $publishers
    } else {
        $publishers  | ?{ $_.Namespace -eq $PublisherName} | select -First 1
    }
}
function Get-AmpOffer {
    param(
        [Parameter(Mandatory=$True, Position=0)]
        [string]
        $PublisherId
    )    
    $offerlist = Invoke-RestMethod `
            -Method Get `
            -Uri "https://publish.windowsazure.com/offers/list" `
            -Headers @{
                "Accept"= "application/json, text/javascript, */*; q=0.01"
            } `
            -WebSession $global:_amp_session
    $offerlist.Offers | ?{ $_.PublisherId -eq $PublisherId}
}
# function Get-AmpOffer($OfferId){
#     Invoke-RestMethod `
#             -Method Get `
#             -Uri "https://publish.windowsazure.com/offers/$OfferId" `
#             -Headers @{
#                 "Accept"= "application/json, text/javascript, */*; q=0.01"
#             } `
#             -WebSession $session
# }
function Get-AmpOfferServicePlan{
    param(
        [Parameter(Mandatory=$True, Position=0)]
        [string]
        $OfferId
    )
    Invoke-RestMethod `
            -Method Get `
            -Uri "https://publish.windowsazure.com/offers/$OfferId/servicePlans" `
            -Headers @{
                "Accept"= "application/json, text/javascript, */*; q=0.01"
            } `
            -WebSession $global:_amp_session
}
function Get-AmpOfferSupportAndLegal{
    param(
        [Parameter(Mandatory=$True, Position=0)]
        [string]
        $OfferId
    )
    Invoke-RestMethod `
            -Method Get `
            -Uri "https://publish.windowsazure.com/offers/$OfferId/supportandlegal" `
            -Headers @{
                "Accept"= "application/json, text/javascript, */*; q=0.01"
            } `
            -WebSession $global:_amp_session
}
function Get-AmpOfferMarketingMaterial{
    param(
        [Parameter(Mandatory=$True, Position=0)]
        [string]
        $OfferId,
        [Parameter(Mandatory=$True, Position=1)]
        [string]
        $Language
    )

    Invoke-RestMethod `
            -Method Get `
            -Uri "https://publish.windowsazure.com/offers/$OfferId/marketingmaterials/$Language" `
            -Headers @{
                "Accept"= "application/json, text/javascript, */*; q=0.01"
            } `
            -WebSession $global:_amp_session
}
function Get-AmpOfferPrice{
    param(
        [Parameter(Mandatory=$True, Position=0)]
        [string]
        $OfferId
    )
    Invoke-RestMethod `
            -Method Get `
            -Uri "https://publish.windowsazure.com/offers/$OfferId/prices" `
            -Headers @{
                "Accept"= "application/json, text/javascript, */*; q=0.01"
            } `
            -WebSession $global:_amp_session
}
function Get-AmpOfferCategory{
    param(
        [Parameter(Mandatory=$True, Position=0)]
        [string]
        $OfferId
    )
    Invoke-RestMethod `
            -Method Get `
            -Uri "https://publish.windowsazure.com/offers/$OfferId/categories" `
            -Headers @{
                "Accept"= "application/json, text/javascript, */*; q=0.01"
            } `
            -WebSession $global:_amp_session
}
function Get-AmpOfferPublishProgress{
    param(
        [Parameter(Mandatory=$True, Position=0)]
        $OfferId,
        [Parameter(Mandatory=$True,ParameterSetName="Staging")]
        [switch]$Staging,
        [Parameter(Mandatory=$True,ParameterSetName="Production")]
        [switch]$Production
    )
    if ($Staging){
        $target = "staging"
    }
    if ($Production){
        $target = "pendingapproval"
    }
    
    Invoke-RestMethod `
            -Method Get `
            -Uri "https://publish.windowsazure.com/offers/$OfferId/$target/progress" `
            -Headers @{
                "Accept"= "application/json, text/javascript, */*; q=0.01"
            } `
            -WebSession $session
}

function Get-AmpOfferHistory{
    param(
        [Parameter(Mandatory=$True, Position=0)]
        [string]
        $OfferId
    )
    Invoke-RestMethod `
            -Method Get `
            -Uri "https://publish.windowsazure.com/offers/$OfferId/history" `
            -Headers @{
                "Accept"= "application/json, text/javascript, */*; q=0.01"
            } `
            -WebSession $session
}

# $inputPublisherName = "brocade_communications"
# $inputOfferId = "brocade-virtual-traffic-manager"

# To get the cookiesValue, log into the publisher portal in the browser
# then open the F12 tools and inspect a request in the network history
# and grab the cookies :-)
# Set-AmpCookies "ai_user=foo; ai_session=blah; .AspNet.Cookies=longvaluehere"

# $publisher = Get-AmpPublisher -PublisherName $inputPublisherName
# $publisherId = $publisher.PublisherId 

# # OfferMarketingUrlIdentifier
# $offer = Get-AmpPublisherOffers -PublisherId $publisherId | ?{$_.OfferMarketingUrlIdentifier -eq $inputOfferId } | select -first 1
# $offerId = $offer.OfferDraftId


# # Get-AmpOffer -OfferId $offerId # e.g. see cultures, solution templates, preview/listed version, ...

# Get-AmpOfferServicePlans -OfferId $offerId | ft
# Get-AmpOfferSupportAndLegal -OfferId $offerId
# Get-AmpOfferMarketingMaterials -OfferId $offerId "en-US" # has Links property - test them all for 404s?

# # Get-AmpPrices -OfferId $offerId | ft -GroupBy RegionCode
# # outputs
# #RegionCode ServicePlanId                        ResourceId  Amount CurrencyCode
# #---------- -------------                        ----------  ------ ------------

# Get-AmpOfferPublishProgress -OfferId $offerId -staging
# Get-AmpOfferPublishProgress -OfferId $offerId -production

# Get-AmpOfferHistory -OfferId $offerId | ft




