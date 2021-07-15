module "tfplan-functions" {
    source = "../common-functions/tfplan-functions/tfplan-functions.sentinel"
}

module "tfstate-functions" {
    source = "../common-functions/tfstate-functions/tfstate-functions.sentinel"
}

module "tfconfig-functions" {
    source = "../common-functions/tfconfig-functions/tfconfig-functions.sentinel"
}

module "tfrun-functions" {
    source = "../common-functions/tfrun-functions/tfrun-functions.sentinel"
}
    
module "azure-functions" {
    source = "../azure-functions/azure-functions.sentinel"
}

policy "enforce-mandatory-tags" {
    source = "./enforce-mandatory-tags.sentinel"
    enforcement_level = "soft-mandatory"
}

policy "restrict-vm-publisher" {
    source = "./restrict-vm-publisher.sentinel"
    enforcement_level = "soft-mandatory"
}

policy "restrict-vm-size" {
    source = "./restrict-vm-size.sentinel"
    enforcement_level = "soft-mandatory"
}

policy "allowed-providers" {
    source = "./allowed-providers.sentinel"
    enforcement_level = "soft-mandatory"
}

policy "limit-proposed-monthly-cost" {
    source = "./limit-proposed-monthly-cost.sentinel"
    enforcement_level = "advisory"
}
