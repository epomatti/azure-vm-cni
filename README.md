# Azure VM CNI

Enabling containers to use Azure Virtual Network capabilities with [Azure CNI][1] and Azure Virtual Machines.

> 💡 The documentation implies that CNI is required for containers to use Virtual Network capabilities, however, after finishing this project I discovered that CNI was not required to use Service Endpoints from a Virtual Machine.

## Azure deploy

Set the `.auto.tfvars` file:

```sh
cp config/template.tfvars .auto.tfvars
```

Create the infrastructure:

```sh
terraform init
terraform apply -auto-approve
```

Confirm that `cloud-init` has complete successfully.

Connect via SSH to the virtual machine.

Run the command to star the app container:

```sh
sudo docker run -p 8080:8080 \
    -e  'MSSQL_HOSTNAME=sqls-cni.database.windows.net' \
    -e  'MSSQL_PORT=1433' \
    -e  'MSSQL_USERNAME=dbadmin' \
    -e  'MSSQL_PASSWORD=P4ssw0rd!2023' \
    epomatti/azure-vm-cni-app:arm64
```

Teste the database connection:

```sh
curl <vm-ipaddress>:8080/query
```

## Local development

Set the `.env` file.

Start the database:

```sh
docker run -p 1433:1433 -e ACCEPT_EULA=Y -e SA_PASSWORD=P@ssw0rd.123 mcr.microsoft.com/mssql/server:2022-latest
```

Run the application:

```sh
cd app

go run .
```

[1]: https://learn.microsoft.com/en-us/azure/virtual-network/container-networking-overview
