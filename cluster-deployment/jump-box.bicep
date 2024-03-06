@secure()
param LOCATION string
param JUMP_BOX_CONFIG object
param NETWORK_CONFIG object

resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' existing = {
  name: JUMP_BOX_CONFIG.ADMIN_PASSWORD_AKV_NAME
  scope: resourceGroup(JUMP_BOX_CONFIG.ADMIN_PASSWORD_AKV_RG_NAME)
}

module jumpBoxSubnet 'modules/jump-box-subnet.bicep' = {
  name: NETWORK_CONFIG.JUMP_BOX_SUBNET_NAME
  scope: resourceGroup(NETWORK_CONFIG.HUB_VNET_RG_NAME)
  params: {
    hubVirtualNetworkName: NETWORK_CONFIG.HUB_VNET_NAME
    location: LOCATION
  }
}

resource networkInterface 'Microsoft.Network/networkInterfaces@2021-05-01' = {
  name: JUMP_BOX_CONFIG.VM_NAME
  location: LOCATION
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: jumpBoxSubnet.outputs.jumbBoxSubnetId
          }
          privateIPAllocationMethod: 'Dynamic'
        }
      }
    ]
    networkSecurityGroup: {
      id: jumpBoxSubnet.outputs.virtualMachineNSGID
    }
  }
}

module jumpBoxVM 'modules/jumb-box-vm.bicep' = {
  name: JUMP_BOX_CONFIG.VM_NAME
  scope: resourceGroup()
  params: {
    ADMIN_PASSWORD: keyVault.getSecret(JUMP_BOX_CONFIG.ADMIN_PASSWORD_SECRET_NAME)
    ADMIN_USER_NAME: JUMP_BOX_CONFIG.ADMIN_USER_NAME
    IMAGE_PUBLISHER: JUMP_BOX_CONFIG.IMAGE_PUBLISHER
    IMMAGE_OFFER: JUMP_BOX_CONFIG.IMMAGE_OFFER
    LOCATION: LOCATION
    NIC_ID: networkInterface.id
    OS_VERSION: JUMP_BOX_CONFIG.OS_VERSION
    VM_NAME: JUMP_BOX_CONFIG.VM_NAME
  }
}
