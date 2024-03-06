param ADMIN_USER_NAME string
@secure()
param ADMIN_PASSWORD string
param IMMAGE_OFFER string
param IMAGE_PUBLISHER string
param LOCATION string
param NIC_ID string
param OS_VERSION string
param VM_NAME string

resource virtualMachine 'Microsoft.Compute/virtualMachines@2021-11-01' = {
  name: VM_NAME
  location: LOCATION
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_D2s_v3'
    }
    storageProfile: {
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'Standard_LRS'
        }
      }
      imageReference: {
        publisher: IMAGE_PUBLISHER
        offer: IMMAGE_OFFER
        sku: OS_VERSION
        version: 'latest'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: NIC_ID
        }
      ]
    }
    osProfile: {
      computerName: 'jump-box'
      adminUsername: ADMIN_USER_NAME
      adminPassword: ADMIN_PASSWORD
    }
  }
}
