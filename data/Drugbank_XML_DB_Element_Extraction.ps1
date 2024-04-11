# 
# $Path = "E:\5-Data Analytics Winter 2024\INFT3000 - Capstone\data\ShortVersion.xml"
$Path = "E:\5-Data Analytics Winter 2024\INFT3000 - Capstone\data\fullDatabase.xml"

# With this data, the were special characters, and 
###########################################################################################
# Main Drug Table
###########################################################################################
# Load document
$Xml = New-Object Xml
$Xml.Load($Path)

$output = @()

$XMLdata = $Xml.drugbank.drug

$output += '"drugId"|"drugName"|"drugDescription"|"drugIndication"|"drugPharmacodynamic"|"drugToxicity"'

foreach ($d in $XMLdata) {
    $drugId = $d.'drugbank-id'.InnerText
    $drugName = $d.name.Trim()
    $drugDescription = $d.'description'.Trim() -replace '"', '""' -replace '', '' -replace '', '' -replace '\r\n', '' -replace '^\s*$', ''
    $drugIndication = $d.indication.Trim() -replace '"', '""' -replace '', '' -replace '', '' -replace '\r\n', '' -replace '^\s*$', ''
    $drugPharma = $d.pharmacodynamics.Trim() -replace '"', '""' -replace '', '' -replace '', '' -replace '\r\n', '' -replace '^\s*$', ''
    $drugToxicity = $d.toxicity.Trim() -replace '"', '""' -replace '', '' -replace '', '' -replace '\r\n', '' -replace '^\s*$', ''

    $output += '"' + $drugId + '"|"' + $drugName + '"|"' + $drugDescription + '"|"' + $drugIndication + '"|"' + $drugPharma+ '"|"' + $drugToxicity + '"'
}

$output | Out-File -FilePath 'E:\5-Data Analytics Winter 2024\INFT3000 - Capstone\data\DrugTablev1.csv' -Encoding UTF8


###########################################################################################
# Drug Product Table
###########################################################################################
# Load document
$Xml = New-Object Xml
$Xml.Load($Path)

$output = @()

$XMLdata = $Xml.drugbank.drug

$output += '"drugId"|"drugGenericName"|"drugLabeller"|"drugDosageForm"|"drugStrength"|"drugRouteUsed"|"drugisOTC"|"drugisApproved"|"drugApprovalCountry"|"drugApprovalSource"'


foreach ($d in $XMLdata) {
    $drugId = $d.'drugbank-id'.InnerText
    Write-Host "Processing drugId: $drugId"
    
    foreach ($p in $d.products.product) {
        $drugGenericName = $p.name -replace '"', '""' -replace '', '' -replace '', '' -replace '\r\n', '' -replace '^\s*$', ''
        $drugLabeller = $p.labeller -replace '"', '""' -replace '', '' -replace '', '' -replace '\r\n', '' -replace '^\s*$', ''
        $drugDosageForm = $p.'dosage-form' -replace '"', '""' -replace '', '' -replace '', '' -replace '\r\n', '' -replace '^\s*$', ''
        $drugStrength = $p.strength -replace '"', '""' -replace '', '' -replace '', '' -replace '\r\n', '' -replace '^\s*$', ''
        $drugRoute = $p.route -replace '"', '""' -replace '', '' -replace '', '' -replace '\r\n', '' -replace '^\s*$', ''
        $drugOTC = $p.'over-the-counter' -replace '"', '""' -replace '', '' -replace '', '' -replace '\r\n', '' -replace '^\s*$', ''
        $drugApproved = $p.approved -replace '"', '""' -replace '', '' -replace '', '' -replace '\r\n', '' -replace '^\s*$', ''
        $drugCountry = $p.country -replace '"', '""' -replace '', '' -replace '', '' -replace '\r\n', '' -replace '^\s*$', ''
        $drugSource = $p.source -replace '"', '""' -replace '', '' -replace '', '' -replace '\r\n', '' -replace '^\s*$', ''

        $output += '"' + $drugId + '"|"' + $drugGenericName + '"|"' + $drugLabeller + '"|"' + $drugDosageForm + '"|"' + $drugStrength + '"|"' + $drugRoute + '"|"' + $drugOTC + '"|"' + $drugApproved + '"|"' + $drugCountry + '"|"' + $drugSource + '"'
        
    }
}

$output | Out-File -FilePath 'E:\5-Data Analytics Winter 2024\INFT3000 - Capstone\data\DrugProductTable.CSV' -Encoding UTF8

###########################################################################################
# Drug Price Table
###########################################################################################
# Load document
$Xml = New-Object Xml
$Xml.Load($Path)

$output = @()

$XMLdata = $Xml.drugbank.drug

$output += '"drugId"|"drugPriceDescription"|"drugPriceCost"|"drugPriceCurrency"|"drugPriceUnit"'

foreach ($d in $XMLdata) {
    $drugId = $d.'drugbank-id'.InnerText
    Write-Host "Processing drugId: $drugId"

    foreach ($pr in $d.prices.price) {
        $drugPriceDescription = $pr.description -replace '"', '""' -replace '\r\n', '' -replace '^\s*$', ''
        $drugPriceCost = $pr.cost.InnerText -replace '"', '""' -replace '\r\n', '' -replace '^\s*$', ''
        $drugPriceCurrency = $pr.cost.currency
        $drugPriceUnit = $pr.unit -replace '"', '""' -replace '\r\n', '' -replace '^\s*$', ''

        $output += '"' + $drugId + '"|"' + $drugPriceDescription + '"|"' + $drugPriceCost + '"|"' + $drugPriceCurrency + '"|"' + $drugPriceUnit + '"'
    }
}

$output | Out-File -FilePath 'E:\5-Data Analytics Winter 2024\INFT3000 - Capstone\data\DrugPriceTable.csv' -Encoding UTF8


###########################################################################################
# Drug Interaction Table <---- Designed Extraction to work in batches so it wouldn't have runtime error
###########################################################################################
# Load the XML file
$Xml = New-Object Xml
$Xml.Load($Path)

# Initialize output array
$output = @()

# Initialize a counter for drugbank-id elements processed
$count = 0

# Initialize a counter for batch numbers
$batchNumber = 1

$output += "drugId|interactionId|interactionName|interactionDescription"
# Process each drug element
foreach ($d in $Xml.drugbank.drug) {
    $drugId = $d.'drugbank-id'.InnerText

    # Check if drug-interactions element exists
    if ($d.'drug-interactions') {
        # Process drug-interaction elements
        foreach ($interaction in $d.'drug-interactions'.'drug-interaction') {
            $interactionId = $interaction.'drugbank-id'
            $interactionName = $interaction.'name'
            $interactionDescription = $interaction.'description' -replace '', '' -replace '', '' -replace '\r\n', '' -replace '^\s*$', ''

            # Join values with the pipe delimiter
            $output += "$drugId|$interactionId|$interactionName|$interactionDescription"
        }
    }

    # Increment the counter
    $count++

    # Write output every 150 drugbank-id elements
    if ($count % 150 -eq 0) {
        $batchFileName = "drugInteraction_Batch$batchNumber.csv"
        $output | Out-File -FilePath $batchFileName -Encoding UTF8
        Write-Host "Batch $batchNumber (Elements $($count-149) to $count) written to $batchFileName"
        $output = @()  # Clear the output array
        $batchNumber++
    }
}

# Write the remaining output to a CSV file
if ($output.Count -gt 0) {
    $remainingFileName = "drugInteraction_Remaining.csv"
    $output | Out-File -FilePath $remainingFileName -Encoding UTF8
    Write-Host "Remaining elements written to $remainingFileName"
}

###########################################################################################
# Food Interaction Table
###########################################################################################
$Xml = New-Object Xml
$Xml.Load($Path)

$output = @()

$XMLdata = $Xml.drugbank.drug

$output += '"drugId"|"foodInteractionDescription"'

foreach ($d in $XMLdata) {
    $drugId = $d.'drugbank-id'.InnerText
    Write-Host "Processing drugId: $drugId"

    foreach ($interaction in $d.'food-interactions') {
        $FoodDescription = $interaction.'food-interaction' -replace '&#13;', '' -replace '&#10;', '' -replace '\r\n', '' -replace '^\s*$', ''
        # Join values with the pipe delimiter
        $output += '"' + $drugId + '"|"' + $FoodDescription + '"' 
    }
}
$output | Out-File -FilePath 'E:\5-Data Analytics Winter 2024\INFT3000 - Capstone\data\FoodInteractionv1.csv' -Encoding UTF8
