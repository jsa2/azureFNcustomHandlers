#az login --use-device-code
#az account set --subscription 78020cde-0dd8-4ac6-a6d4-21bac00fb343
#Define starting variables
rnd=$RANDOM
fnName=fn-honeyPot-$rnd
rg=RG-FN-$rnd
location=westeurope
# You can ignore the warning "command substitution: ignored null byte in input"
storageAcc=storage$(shuf -zer -n10  {a..z})
# Your Public IP address
IPRestriction=82.181.97.241

# Create Resource Group (retention tag is just example, based on another service)
az group create -n $rg \
-l $location \
--tags="retention=30d"

# Create storageAcc Account 
saId=$(az storage account create -n $storageAcc  -g $rg --kind storageV2 -l $location -t Account --sku Standard_LRS  -o tsv --query "id")

saConstring=$(az storage account show-connection-string -g $rg  -n  $storageAcc -o tsv --query "connectionString")

## Create Function App
az functionapp create \
--functions-version 3 \
--consumption-plan-location $location \
--name $fnName \
--os-type linux \
--resource-group $rg \
--runtime node \
--storage-account $storageAcc
#
sleep 10

az functionapp config access-restriction add --name $fnName \
--resource-group $rg \
--ip-address $IPRestriction \
--priority 1

# Set to read-only, list variables here you want to be also part of cloud deployment
az functionapp config appsettings set \
--name $fnName \
--resource-group $rg \
--settings scope=$scope  WEBSITE_RUN_FROM_PACKAGE=1 

#Create ZIP package 
7z a -tzip deploy.zip . -r -mx0 -xr\!*.git -xr\!*.vscode 

# Force triggers by deployment and restarts
az functionapp deployment source config-zip -g $rg -n $fnName --src deploy.zip
sleep 5
az functionapp restart --name $fnName --resource-group $rg 
sleep 20

az functionapp function show -g $rg -n $fnName --function-name skeleton -o tsv --query invokeUrlTemplate

#
rm deploy.zip
