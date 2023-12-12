output "mssql_fqdn" {
  value = module.mssql.fully_qualified_domain_name
}

output "vm_public_ip" {
  value = module.vm.public_ip
}
