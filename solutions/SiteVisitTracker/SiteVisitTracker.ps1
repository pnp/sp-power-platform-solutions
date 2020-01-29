
param(
    [Parameter(Mandatory)]
    [String]$orgName,
	[Parameter(Mandatory)]
    [String]$adminUPN,
	[Parameter(Mandatory)]
    [String]$siteUrl
)

#Connect to Tenant site
write-host "1. Connecting to "https://$orgName.sharepoint.com"..." -Foreground "Green"
$userCredential = Get-Credential -UserName $adminUPN -Message "Type the password."
Connect-PnPOnline -Url https://$orgName.sharepoint.com -Credentials $userCredential
write-host "   Complete!" -Foreground "Green"
write-host `r

#Connect to site
write-host "2. Connecting to "$siteUrl"..." -Foreground "Green"
Connect-PnPOnline -Url $siteUrl -Credentials $userCredential
write-host "   Complete!" -Foreground "Green"
write-host `r


#Applying PnP Provisioning Template to target site
write-host "3. Applying template to "$siteUrl"..." -Foreground "Green"
Apply-PnPProvisioningTemplate -Path ("{0}\SiteTrackerListsPNP.xml"-f $PSScriptRoot)
#Update page title to none
$page1 = Set-PnPClientSidePage -Identity Home -HeaderType 0
write-host "   Complete!" -Foreground "Green"
write-host `r

#Applying mock data
write-host "4. Add mock data to "$siteUrl"..." -Foreground "Green"
#link list
write-host "import link list"
$link1 = Add-PnPListItem -List "QuickLink" -Values @{"Title"="Previous 30 days";"LinkedUrl"="$siteUrl/Lists/VisitLog/Previous30Days.aspx, View all site visits in the last 30 days"}
$link2 = Add-PnPListItem -List "QuickLink" -Values @{"Title"="Next 30 days";"LinkedUrl"="$siteUrl/Lists/VisitLog/Next30Days.aspx, View all upcoming site visits the next 30 days"}

#Location list
write-host "import location list"
$location1 = Add-PnPListItem -List "Locations" -Values @{"Title"="The Domain";"LocationName"="The Domain"}
$location2 = Add-PnPListItem -List "Locations" -Values @{"Title"="NorthPark Center";"LocationName"="NorthPark Center"}
$location3 = Add-PnPListItem -List "Locations" -Values @{"Title"="Baybrook Mall";"LocationName"="Baybrook Mall"}
$location4 = Add-PnPListItem -List "Locations" -Values @{"Title"="Stonebriar Centre";"LocationName"="Stonebriar Centre"}
$location5 = Add-PnPListItem -List "Locations" -Values @{"Title"="North Star Mall";"LocationName"="North Star Mall"}
$location6 = Add-PnPListItem -List "Locations" -Values @{"Title"="The Shops at La Cantera";"LocationName"="The Shops at La Cantera"}
$location7 = Add-PnPListItem -List "Locations" -Values @{"Title"="The Woodlands Mall";"LocationName"="The Woodlands Mall"}
#Onsite contacts list
write-host "import Onsite contacts list"
$contact1 = Add-PnPListItem -List "Onsite contacts" -Values @{"Title"="CEO"; "ContactName"="Susan Barny"; Location = $location6.id}
$contact2 = Add-PnPListItem -List "Onsite contacts" -Values @{"Title"="Event Director"; "ContactName"="Ed Smith"; Location = $location6.id}
$contact3 = Add-PnPListItem -List "Onsite contacts" -Values @{"Title"="Head Chef"; "ContactName"="Baybrook Mall"; Location = $location7.id}
$contact4 = Add-PnPListItem -List "Onsite contacts" -Values @{"Title"="Event Director"; "ContactName"="Stonebriar Centrey"; Location = $location7.id}

write-host "import images"
$file1 = Add-PnPFile -Path .\images\CLO17_clothingStore_003.jpg -Folder "PhotoLib" 
$file2 = Add-PnPFile -Path .\images\MSC18_bespokeClothierChicago_007.jpg -Folder "PhotoLib"
$file3 = Add-PnPFile -Path .\images\MST19_Retail_SMB_001.jpg -Folder "PhotoLib"
$file4 = Add-PnPFile -Path .\images\SUR18_Holiday_Contextual_2455_RGB.jpg -Folder "PhotoLib"
$file5 = Add-PnPFile -Path .\images\WCO18_retail_045.jpg -Folder "PhotoLib"

#Visit Photos
write-host "import visit photos"
$photo1 = Add-PnPListItem -List "VisitPhotos" -Values @{"Title"="CLO17_clothingStore_003"; "Photo" = "$($file1.ServerRelativeUrl), CLO17_clothingStore_003.jpg"}
$photo2 = Add-PnPListItem -List "VisitPhotos" -Values @{"Title"="MSC18_bespokeClothierChicago_007"; "Photo" = "$($file2.ServerRelativeUrl), MSC18_bespokeClothierChicago_007.jpg"}
$photo3 = Add-PnPListItem -List "VisitPhotos" -Values @{"Title"="MST19_Retail_SMB_001"; "Photo" = "$($file3.ServerRelativeUrl), MST19_Retail_SMB_001.jpg"}
$photo4 = Add-PnPListItem -List "VisitPhotos" -Values @{"Title"="SUR18_Holiday_Contextual_2455_RGB"; "Photo" = "$($file3.ServerRelativeUrl), SUR18_Holiday_Contextual_2455_RGB.jpg"}
$photo5 = Add-PnPListItem -List "VisitPhotos" -Values @{"Title"="WCO18_retail_045"; "Photo" = "$($file4.ServerRelativeUrl), WCO18_retail_045.jpg"}

#VisitLog list
write-host "import visit log"
$now = (Get-Date).Date
$visitLog1 = Add-PnPListItem -List "VisitLog" -Values @{"ScheduledDate"=$now.AddDays(-20) ;"VisitDate"=$now.AddDays(-20) ;"Photos"=$file1.Name ;"Location"= $location1.id; "Site_x0020_Contact"=$contact1.id; "Completed"=1; "Planned"=1;"Follow_x0020_Up_x0020_Action"=2;"Notes"="Devices not properly displayed"}
$visitLog2 = Add-PnPListItem -List "VisitLog" -Values @{"ScheduledDate"=$now.AddDays(-15) ;"VisitDate"=$now.AddDays(-15) ;"Photos"=$file2.Name ;"Location"= $location2.id; "Site_x0020_Contact"=$contact2.id; "Completed"=1; "Planned"=1;"Follow_x0020_Up_x0020_Action"=1;"Notes"="Perfect quantity of devices, displays were on-brand"}
$visitLog3 = Add-PnPListItem -List "VisitLog" -Values @{"ScheduledDate"=$now.AddDays(-10) ;"VisitDate"=$now.AddDays(-10) ;"Photos"=$file3.Name ;"Location"= $location3.id; "Site_x0020_Contact"=$contact3.id; "Completed"=1; "Planned"=1;"Follow_x0020_Up_x0020_Action"=3;"Notes"="Was not able to meet with all parties needed"}
$visitLog4 = Add-PnPListItem -List "VisitLog" -Values @{"ScheduledDate"=$now.AddDays(-2) ;"VisitDate"=$now.AddDays(-2) ;"Photos"=$file4.Name ;"Location"= $location7.id; "Site_x0020_Contact"=$contact4.id; "Completed"=1; "Planned"=1;"Follow_x0020_Up_x0020_Action"=1;"Notes"="Displays were on-brand, no need for follow up."}
$visitLog5 = Add-PnPListItem -List "VisitLog" -Values @{"ScheduledDate"=$now.AddDays(2) ;"VisitDate"=$now.AddDays(2) ;"Photos"=$file5.Name ;"Location"= $location5.id; "Site_x0020_Contact"=$contact1.id; "Completed"=0; "Planned"=1;"Follow_x0020_Up_x0020_Action"=2;"Notes"="Devices not properly displayed"}
$visitLog6 = Add-PnPListItem -List "VisitLog" -Values @{"ScheduledDate"=$now.AddDays(3) ;"VisitDate"=$now.AddDays(3) ;"Location"= $location6.id; "Site_x0020_Contact"=$contact2.id; "Completed"=0; "Planned"=1;"Follow_x0020_Up_x0020_Action"=1;"Notes"="Perfect quantity of devices, displays were on-brand"}
$visitLog7 = Add-PnPListItem -List "VisitLog" -Values @{"ScheduledDate"=$now.AddDays(5) ;"VisitDate"=$now.AddDays(5) ;"Location"= $location2.id; "Site_x0020_Contact"=$contact3.id; "Completed"=0; "Planned"=1;"Follow_x0020_Up_x0020_Action"=3;"Notes"="Was not able to meet with all parties needed"}
$visitLog8 = Add-PnPListItem -List "VisitLog" -Values @{"ScheduledDate"=$now.AddDays(10) ;"VisitDate"=$now.AddDays(10) ;"Location"= $location3.id; "Site_x0020_Contact"=$contact4.id; "Completed"=0; "Planned"=1;"Follow_x0020_Up_x0020_Action"=1;"Notes"="Displays were on-brand, no need for follow up."}
$visitLog9 = Add-PnPListItem -List "VisitLog" -Values @{"ScheduledDate"=$now.AddDays(15) ;"VisitDate"=$now.AddDays(15) ;"Location"= $location4.id; "Site_x0020_Contact"=$contact1.id; "Completed"=0; "Planned"=1;"Follow_x0020_Up_x0020_Action"=2;"Notes"="Devices not properly displayed"}
$visitLog10 = Add-PnPListItem -List "VisitLog" -Values @{"ScheduledDate"=$now.AddDays(20) ;"VisitDate"=$now.AddDays(20) ;"Location"= $location7.id; "Site_x0020_Contact"=$contact2.id; "Completed"=0; "Planned"=1;"Follow_x0020_Up_x0020_Action"=1;"Notes"="Perfect quantity of devices, displays were on-brand"}

write-host "   Complete!" -Foreground "Green"

Read-Host -Prompt "Press Enter to exit"

