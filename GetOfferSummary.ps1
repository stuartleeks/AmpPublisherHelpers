# To get the cookiesValue, log into the publisher portal in the browser
# then open the F12 tools and inspect a request in the network history
# and grab the cookies :-)
$cookiesValue = "ai_user=gOUpJ|2016-07-01T08:07:56.142Z; ai_session=nl0vB|1467367618148|1467372385640; .AspNet.Cookies=QpbOEsBZ5A70Udr7vumStJLWpxQq0-ON_oE5KuWKqn-5eh1kzFQZ-iDcjThCC3p_5WEpUZTTuxyimXzRQZP-YjguyQWi1zsSJAKnKvnV1BONX0dAO3zm8nk2vWVQbbcZZq6nDiqInGxUbPxiaNPUkNKnGkqQW_LzoftYCuIQV5JBRkv0K-5Y_Tx7NDwprSZQCkzpqe8rh7nAJqS8KzWCENF-TVMHZERNmZ0KT_wmPPHEmXYXbUzgGdTbPIc29uLaVopw1afMXWlXOgUjRbMb_0Pv1u9xJtWf5Cnu39CLR4gVAKXgmnxxQkQCIvflZPAqvkwLCVe1AzzBM6xniIrrErbKrtgEQNgS5VfIebckedhMtI5gyYwqAvGpQBPiiGAXMejSQ_D6dtjQ9o9lPo-DNZqkJARlkRSsmMo2mYKeLwwtuFkhuNhLpYEIWXujpdYFQWz9gCD-AgszK0EI1WckR3z67XssDgc6vstzFIqYHhCs2maLL3KkykqR3HU4iInxN-QmJO1Yznd55nKRMwPMpvj893_7uIeonCJ_6ITI_Ol0gJzZFCWVIzXGk1jw-uUtQVMWTGI23jwwtZlIZlSAd-tULULmaPrB42UavR9gerjWt_eVS9QF_aTyUGr2uw07mREiBpGT4xMVLJRUqJOpwlgbzJB5Qod_AVFYZnHyVNe7hqIkQXf4iVEXVPguJOMc00rMQc3RajpMtDk5IhQyQyHhjI-Pi8fQQGn6HD1H1_m_A-rE-kizCm3oPqrcbIokrGHqQuKrTxbJnkXvbcXo3VCANykcEEP4UNNOvfQnxe1rpznZTpFm4OaLR2Phc7nvrUTl4_b96QUsqitsJgJE_QdVYGJ3K7kEEoHALEtkaVOqagQ6HxhZqzPTi6G4dRCXSL3fBDFx2haWH0iGsaNzDn-j9qmJCoYuUM8OMMyW7UFG-HBVS-YI4-nEpMcmRBTiNbSsN-SqJFO_cNzBDOwEfq5yAZiDVL5x2s6eFusKwdV1i0mqbDwLMSUGuESzJAZNgezBoxVm1gi8xrHl0ocLA7TWSIBA7Uvbby2tWqpYuDp80NwUmXa3WLfv11Jrczv5MaA-z3LTyUJJ_Zb1rdcrx46aFu7URGao8s3tdpTzTt-apDoV8rSoLuW7QAEv1U5rJSuK9dPTbKiY4VGntkS1UiQ3BriMklDPm3BA7fgphkotFkZbGNWOPzr0OQy__YYUuHxskA"


$inputPublisherName = "brocade_communications"
$inputOfferId = "brocade-virtual-traffic-manager"

function GetWebSession(){
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
function Get-AmpPublisher($PublisherName){
    $user = Invoke-RestMethod `
            -Method Get `
            -Uri "https://publish.windowsazure.com/user" `
            -Headers @{
                "Accept"= "application/json, text/javascript, */*; q=0.01"
            } `
            -WebSession $session
    $publisher = $user.AccessiblePublishers | ?{ $_.Namespace -eq $PublisherName} | select -First 1
    $publisher
}
function Get-AmpPublisherOffers($PublisherId) {
    $offerlist = Invoke-RestMethod `
            -Method Get `
            -Uri "https://publish.windowsazure.com/offers/list" `
            -Headers @{
                "Accept"= "application/json, text/javascript, */*; q=0.01"
            } `
            -WebSession $session
    $offerlist.Offers | ?{ $_.PublisherId -eq $PublisherId}
}
function Get-AmpOfferServicePlans($OfferId){
    Invoke-RestMethod `
            -Method Get `
            -Uri "https://publish.windowsazure.com/offers/$OfferId/servicePlans" `
            -Headers @{
                "Accept"= "application/json, text/javascript, */*; q=0.01"
            } `
            -WebSession $session
}
function Get-AmpOfferSupportAndLegal($OfferId){
    Invoke-RestMethod `
            -Method Get `
            -Uri "https://publish.windowsazure.com/offers/$OfferId/supportandlegal" `
            -Headers @{
                "Accept"= "application/json, text/javascript, */*; q=0.01"
            } `
            -WebSession $session
}
function Get-AmpOfferMarketingMaterials($OfferId, $lang){
    Invoke-RestMethod `
            -Method Get `
            -Uri "https://publish.windowsazure.com/offers/$OfferId/marketingmaterials/$lang" `
            -Headers @{
                "Accept"= "application/json, text/javascript, */*; q=0.01"
            } `
            -WebSession $session
}
function Get-AmpOfferPrices($OfferId){
    Invoke-RestMethod `
            -Method Get `
            -Uri "https://publish.windowsazure.com/offers/$OfferId/prices" `
            -Headers @{
                "Accept"= "application/json, text/javascript, */*; q=0.01"
            } `
            -WebSession $session
}
function Get-AmpOfferCategories($OfferId){
    Invoke-RestMethod `
            -Method Get `
            -Uri "https://publish.windowsazure.com/offers/$OfferId/categories" `
            -Headers @{
                "Accept"= "application/json, text/javascript, */*; q=0.01"
            } `
            -WebSession $session
}
function Get-AmpOfferPublishProgress{
    param(
        [Parameter(Mandatory=$True)]
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
function Get-AmpOffer($OfferId){
    Invoke-RestMethod `
            -Method Get `
            -Uri "https://publish.windowsazure.com/offers/$OfferId" `
            -Headers @{
                "Accept"= "application/json, text/javascript, */*; q=0.01"
            } `
            -WebSession $session
}
function Get-AmpOfferHistory($OfferId){
    Invoke-RestMethod `
            -Method Get `
            -Uri "https://publish.windowsazure.com/offers/$OfferId/history" `
            -Headers @{
                "Accept"= "application/json, text/javascript, */*; q=0.01"
            } `
            -WebSession $session
}

$session = GetWebSession # set global session

$publisher = Get-AmpPublisher -publisherName $inputPublisherName
$publisherId = $publisher.PublisherId 

# OfferMarketingUrlIdentifier
$offer = Get-AmpPublisherOffers -publisherId $publisherId | ?{$_.OfferMarketingUrlIdentifier -eq $inputOfferId } | select -first 1
$offerId = $offer.OfferDraftId


# Get-AmpOffer -OfferId $offerId # e.g. see cultures, solution templates, preview/listed version, ...

Get-AmpOfferServicePlans -OfferId $offerId | ft
Get-AmpOfferSupportAndLegal -OfferId $offerId
Get-AmpOfferMarketingMaterials -OfferId $offerId "en-US" # has Links property - test them all for 404s?

# Get-AmpPrices -OfferId $offerId | ft -GroupBy RegionCode
# outputs
#RegionCode ServicePlanId                        ResourceId  Amount CurrencyCode
#---------- -------------                        ----------  ------ ------------

Get-AmpOfferPublishProgress -OfferId $offerId -staging
Get-AmpOfferPublishProgress -OfferId $offerId -production

Get-AmpOfferHistory -OfferId $offerId | ft




