# To get the cookiesValue, log into the publisher portal in the browser
# then open the F12 tools and inspect a request in the network history
# and grab the cookies :-)
$cookiesValue = "ai_user=gOUpJ|2016-07-01T08:07:56.142Z; ai_session=nl0vB|1467367618148|1467368059469; .AspNet.Cookies=7aGM-K2w6XG2sfN9wzTbrgsor1PDgkBOtAmHLUpIFElZHI0kqEUEPx8Sx6iEc7VbYRq_bh5BvM8_xZqwKzQNCwHaY8gNIwPym5xRpU-jf3JWRrqhHQn6FNjgqUzkuqbrZVFuEkcTMRQKpYwdGtPKT9YGzlxYu-CbVP0h4VNn4XTRBGx5wRWgSCrvZ38L81QQstpwYMDgKLTo47PLTOD2menLbVlIGxd2auLs772uzli8ltBnYNefbcyJ-BAKd5NTiLC82cBGg-29wUobET2ecLodHGTy4gJi6_spH37XPUTkFwuMIg9NGQqn5WjOrYmK7gDEdADonobypo76lUXq2yQ9bAHl14Tfp-UkMK1IsXhnZz1A77lNFQB8EbUKmdhUKkPMIo93_19GdxW-or6UhtKP2xXy9rUqJTHqjG8qBDbLiSwKGeTqT_iRAy4C55rsoEvntOV84IQTPmBv4ICUFYy-kXPOxTm3dUmJmPqFhwxJPaayB_OZ2UvZHQ-nXbn1wiT7e4izMVInS1ZcAmxRa_L-y6t59YDRuBBZN0LY4IfUiz4d11pqkme7A9hx1lrqjOzM9FYSA2vKBgMDqblt_swSL9c4isBbWwguUQynQzThCoaRxlGgnJcY9daoMsqPcq4DfSMVm9ZL_cYsvEQK_Z47C1jNzW7avWpBMnfgs87ltBEb0mY-VeFvJe0e7JL4dpv7fVghdvVuKIUomopDYyyLAlaBLe5KRX0oNukPoZh2McFzJL3xRKrkJpdKhKH0TqGIj1aoJIDUyvhVYjQqpzhz9ngvscaOluYDsGbcTH84xkcOvLjsZ9dlAiiFP9IerXV9vW0Hi3HY-xHEDpN6DBqoDmNMFVMRA18lLrIS7nisHYbNP33jqZQCSYX9dWeRzyhsj6QfFCNe7SCfTiEJ7c0UqsbxmUAwfv3npjtMUBNOWedUc9zTBl5_zRL3dLSzxgR7GFg_BhIottFXEEr04TAdavJ8KeIWLIwUMVPisughxch9Dg-xjQHWHOg8WbizYKPCTkHbRs7XQy1F259NnaxboufojPAHEsXdBPyAhUiySmFxxaJmOwE1n_s0QNgoV3VHVfC-pF8HDMFSNO2kXE6qWSmuZ4fGHBFNrQAUvAV0bTBB"


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

$user = Invoke-RestMethod `
        -Method Get `
        -Uri "https://publish.windowsazure.com/user" `
        -Headers @{
            "Accept"= "application/json, text/javascript, */*; q=0.01"
        } `
        -WebSession $session
$user
$user.AccessiblePublishers | ft

$offerlist = Invoke-RestMethod `
        -Method Get `
        -Uri "https://publish.windowsazure.com/offers/list" `
        -Headers @{
            "Accept"= "application/json, text/javascript, */*; q=0.01"
        } `
        -WebSession $session



$offerlist.Offers | ft


# https://publish.windowsazure.com/checkselleraccountstatus/362a2ee8-015a-4b57-91fe-a51bf2ac5153 # Guid comes from $user.AccessiblePulishers[0].OwnerUserAccountId


# GUIDs are OfferDraftId from offerlist.Offers

# https://publish.windowsazure.com/offers/f131cc3c-5dcd-4e83-ad05-2f20af91604b/serviceplans
# https://publish.windowsazure.com/offers/c81b11c4-d526-4d98-8152-4769420e4b46/supportandlegal
# https://publish.windowsazure.com/offers/c81b11c4-d526-4d98-8152-4769420e4b46/marketingmaterials/en-US
# https://publish.windowsazure.com/offers/c81b11c4-d526-4d98-8152-4769420e4b46/prices
# https://publish.windowsazure.com/offers/c81b11c4-d526-4d98-8152-4769420e4b46/categories
# https://publish.windowsazure.com/offers/c81b11c4-d526-4d98-8152-4769420e4b46/staging/progress
# https://publish.windowsazure.com/offers/c81b11c4-d526-4d98-8152-4769420e4b46/pendingapproval/progress
# https://publish.windowsazure.com/offers/c81b11c4-d526-4d98-8152-4769420e4b46
# https://publish.windowsazure.com/offers/c81b11c4-d526-4d98-8152-4769420e4b46/history


# https://publish.windowsazure.com/virtualmachines/8d6e72d9-c02c-4600-9c56-228f66143df4/details


# https://publish.windowsazure.com/offers/fcbe00d1-9ece-43a8-b423-0f260e85ab70/topologies
