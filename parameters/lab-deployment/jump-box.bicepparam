using '../../cluster-deployment/jump-box.bicep'

param LOCATION = 'eastus'

param JUMP_BOX_CONFIG = {
  ADMIN_USER_NAME:              'azureadmin'
  VM_NAME:                      'aks-jump-box'
  IMAGE_PUBLISHER:              'MicrosoftWindowsServer'
  IMMAGE_OFFER:                 'WindowsServer'
  OS_VERSION:                   '2019-Datacenter'
  ADMIN_PASSWORD_AKV_NAME:      'aks-certificates'
  ADMIN_PASSWORD_SECRET_NAME:   'jump-box-admin-password'
  ADMIN_PASSWORD_AKV_RG_NAME:   'aks-shared-resources'
}

param NETWORK_CONFIG = {
  JUMP_BOX_SUBNET_NAME:       'jump-box'
  HUB_VNET_NAME:              'aks-hub-network'
  HUB_VNET_RG_NAME:           'aks-hub-network'
}
