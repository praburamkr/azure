# GitHub Actions for Azure

This Action for [Azure](https://azure.microsoft.com/en-us/) enables arbitrary actions for interacting with Azure services via [the `az` command-line client](https://docs.microsoft.com/en-us/cli/azure/).

## Usage

The workflow below mimics [this Web App for Containers tutorial](https://docs.microsoft.com/en-us/azure/app-service/containers/tutorial-custom-docker-image), deploying an _existing_ Docker image to Azure [Web App for Containers](https://docs.microsoft.com/en-us/azure/app-service/containers/app-service-linux-intro). In addition to an existing Docker image, it assumes the pre-existence of:

1. An Azure service principal ([more info](https://docs.microsoft.com/en-us/cli/azure/create-an-azure-service-principal-azure-cli?view=azure-cli-latest))
1. An Azure resource group, created with `az group create --name $RESOURCE_GROUP --location $LOCATION`
1. An Azure app service plan, created with `az appservice plan create --name $APP_SERVICE_PLAN --resource-group $RESOURCE_GROUP --sku B1 --is-linux`

```hcl
workflow "Deploy to Azure Web App for Containers" {
  on = "push"
  resolves = ["Deploy Webapp"]
}

action "Deploy Webapp" {
  uses = "actions/azure@master"
  args = "webapp create --resource-group $RESOURCE_GROUP --plan $APP_SERVICE_PLAN --name $WEBAPP_NAME --deployment-container-image-name $CONTAINER_IMAGE_NAME"
  secrets = ["AZURE_SERVICE_APP_ID", "AZURE_SERVICE_PASSWORD", "AZURE_SERVICE_TENANT"]
  env = {
    APP_SERVICE_PLAN = "myAppServicePlan"
    CONTAINER_IMAGE_NAME = "owner/repo:tag"
    RESOURCE_GROUP = "myLinuxResourceGroup"
    WEBAPP_NAME = "myWebApp"
  }
}
```

### Secrets

- `AZURE_SERVICE_APP_ID` - **Required** The `appId` of your service principal ([more info](https://docs.microsoft.com/en-us/cli/azure/create-an-azure-service-principal-azure-cli?view=azure-cli-latest#sign-in-using-the-service-principal))
- `AZURE_SERVICE_TENANT` – **Required** The `tenant` of your service principal ([more info](https://docs.microsoft.com/en-us/cli/azure/create-an-azure-service-principal-azure-cli?view=azure-cli-latest#sign-in-using-the-service-principal))
- `AZURE_SERVICE_PASSWORD` - **Optional** The `password` of your service principal, required for _password_-based authentication ([more info](https://docs.microsoft.com/en-us/cli/azure/create-an-azure-service-principal-azure-cli?view=azure-cli-latest#sign-in-using-the-service-principal))
- `AZURE_SERVICE_PEM` – **Optional** The PEM public string for the certificate of your service principal, required for _certificate_-based authentication ([more info](https://docs.microsoft.com/en-us/cli/azure/create-an-azure-service-principal-azure-cli?view=azure-cli-latest#sign-in-using-the-service-principal))

### Environment variables

- `AZ_OUTPUT_FORMAT` - **Optional** The `az` cli output format, defaults to JSON ([more info](https://docs.microsoft.com/en-us/cli/azure/format-output-azure-cli?view=azure-cli-latest))

## License

The Dockerfile and associated scripts and documentation in this project are released under the [MIT License](LICENSE).

Container images built with this project include third party materials. See [THIRD_PARTY_NOTICE.md](THIRD_PARTY_NOTICE.md) for details.
