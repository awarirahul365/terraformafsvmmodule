virtual_machines={
    "azpoe-afs-vm" = {
        vnetname = "azpoe-afs-vnet"
        vnetcidr = ["10.0.0.0/16"]
        subnetname = "azpoe-afs-subnet"
        subnetcidr = ["10.0.1.0/24"]
        publicip = "azpoe-afs-pip"
        zonespip = [ "1" ]
        nsgname = "azpoe-afs-nsg"
        nicname = "azpoe-afs-nic"
        zonesvm = "1"
        filestoragename = "azpoeafsterraform"
        fsname = "vol-install-azpoe"
        roledefinition = "Storage File Data SMB Share Contributor"
        enable_role_assignment = true
        principal_id = "d2178c8a-1af0-4e5b-97ff-2815b15ddee0"
    }
}