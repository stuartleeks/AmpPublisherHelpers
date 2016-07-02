# AmpPublisherHelpers

Utility functions for querying the publisher portal, e.g. to make it easier to inspect the metadata

WARNING ** These are unofficial, unsupported, not recommended!!!!!! Use at your own risk!! **

## Running

1. import the functions
```posh
. ./AmpPublisherHelpers.ps1
```

1. Sign into the publisher portal and load the F12 tools. Grab the cookies for one of the requests and then run `Set-AmpCookies`, e.g. 
```posh
Set-AmpCookies "ai_user=some value; ai_session=Some other value; .AspNet.Cookies=some really really long value"
```

1. Check that the connection has worked
```posh
    Get-AmpUser
```


** Note: you will have to repeat the `Set-AmpCookies` step each time the cookie expires **


## examples

### Get Publisher
Get the publishers that you have access to
```posh
Get-AmpPublisher
```

Get the publishers that you have access to, filtered by publisher name matching `bro*`

```posh
Get-AmpPublisher bro*
```

### Get Offers

Get all offers
```posh
Get-AmpOffer
```

Get offers where the offer identifier matches `bro*`, and then get the categories for ecah offer outputting the result as JSON
```posh
Get-AmpOffer -OfferMarketingUrlIdentifier bro*  | %{ [PSCustomObject]@{"Title"=$_.Title;"Categories"=Get-AmpOfferCategory -OfferId $_.OfferDraftId }} | ConvertTo-Json
```

Get the offers where the offer identifier matches `bro*virt*`, and then get marketing, support details etc. The results are written to the TestOutput folder with a subfolder per offer.

```posh
Get-AmpOffer -OfferMarketingUrlIdentifier bro*virt*| %{
    $offer = $_
    $folder = "./TestOutput\$($offer.OfferMarketingUrlIdentifier)"
    if (-not (Test-Path $folder)) { New-Item $folder -Type Directory }
 
    $marketing = Get-AmpOfferMarketingMaterial $offer.OfferDraftId -Language en-us

    $marketing.PlanDescriptions | out-file "$folder\PlanDescriptions.txt" -Force
    $marketing.HtmlDescription | out-file "$folder\HtmlDescription.txt" -Force
    $marketing.Summary | out-file "$folder\Summary.txt" -Force
    $marketing.LongSummary | out-file "$folder\LongSummary.txt" -Force
    $marketing.TermsOfUse | out-file "$folder\TermsOfUse.txt" -Force
    $marketing.Logos | ft | out-file "$folder\Logos.txt" -Force
    $marketing.Links | ft | out-file "$folder\Links.txt" -Force


    Get-AmpOfferSupportAndLegal $offer.OfferDraftId | Out-File "$folder\SupportAndLegal.txt"

    Get-AmpOfferCategory $offer.OfferDraftId | Out-File "$folder\Categories.txt"
}
```