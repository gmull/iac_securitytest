@description('Name of the Virtual Machine')
param vmName string

@description('Admin username for the VM')
param adminUsername string

@description('Admin password for the VM')
@secure()
param adminPassword string

@description('Location for all resources')
param location string = resourceGroup().location

@description('Size of the Virtual Machine')
param vmSize string = 'Standard_D2s_v3'

@description('Operating System Image')
param osImage object = {
  publisher: 'Canonical'
  offer: 'UbuntuServer'
  sku: '18.04-LTS'
  version: 'latest'
}

@description('Virtual Network name')
param vnetName string = '${vmName}-vnet'

@description('Subnet name')
param subnetName string = 'default'

@description('Public IP name')
param publicIpName string = '${vmName}-pip'

@description('Network Security Group name')
param nsgName string = '${vmName}-nsg'

@description('Network Interface name')
param nicName string = '${vmName}-nic'

@description('Disk size in GB')
param osDiskSizeGB int = 30

// Create a Virtual Network
resource vnet 'Microsoft.Network/virtualNetworks@2021-08-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefix: '10.0.0.0/24'
        }
      }
    ]
  }
}

// Create a Public IP Address
resource publicIp 'Microsoft.Network/publicIPAddresses@2021-08-01' = {
  name: publicIpName
  location: location
  properties: {
    publicIPAllocationMethod: 'Dynamic'
  }
}

// Create a Network Security Group
resource nsg 'Microsoft.Network/networkSecurityGroups@2021-08-01' = {
  name: nsgName
  location: location
  properties: {
    securityRules: [
      {
        name: 'AllowRDP'
        properties: {
          priority: 1000
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '3389'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}

// Create a Network Interface
resource nic 'Microsoft.Network/networkInterfaces@2021-08-01' = {
  name: nicName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: vnet.properties.subnets[0].id
          }
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIp.id
          }
        }
      }
    ]
    networkSecurityGroup: {
      id: nsg.id
    }
  }
}

// Create a Virtual Machine
resource vm 'Microsoft.Compute/virtualMachines@2021-11-01' = {
  name: vmName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    storageProfile: {
      osDisk: {
        createOption: 'FromImage'
        diskSizeGB: osDiskSizeGB
      }
      imageReference: osImage
    }
    osProfile: {
      computerName: vmName
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
        }
      ]
    }
  }
}
