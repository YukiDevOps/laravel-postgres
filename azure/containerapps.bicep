param sites_laravel_psql_sample_name string = 'laravel-psql-sample'
param registries_azcry_name string = 'azcry'
param containerapps_containerapps_test_name string = 'containerapps-test'
param serverfarms_ASP_rglaravelapp_8b80_name string = 'ASP-rglaravelapp-8b80'
param containerapps_containerapp_laravel_name string = 'containerapp-laravel'
param flexibleServers_postgres_lara_name string = 'postgres-lara'
param storageAccounts_laravelpostgresappfiles_name string = 'laravelpostgresappfiles'
param workspaces_workspacerglaravelapp8de9_name string = 'workspacerglaravelapp8de9'
param managedEnvironments_managedEnvironment_rglaravelapp_9dfd_name string = 'managedEnvironment-rglaravelapp-9dfd'

resource managedEnvironments_managedEnvironment_rglaravelapp_9dfd_name_resource 'Microsoft.App/managedEnvironments@2022-11-01-preview' = {
  name: managedEnvironments_managedEnvironment_rglaravelapp_9dfd_name
  location: 'Japan East'
  properties: {
    appLogsConfiguration: {
      destination: 'log-analytics'
      logAnalyticsConfiguration: {
        customerId: '20d31d81-2b06-4336-9eb5-c3094eacdc0a'
      }
    }
    zoneRedundant: false
    kedaConfiguration: {}
    daprConfiguration: {}
    customDomainConfiguration: {}
  }
}

resource containerapps_containerapp_laravel_name_resource 'Microsoft.App/containerapps@2022-11-01-preview' = {
  name: containerapps_containerapp_laravel_name
  location: 'Japan East'
  identity: {
    type: 'None'
  }
  properties: {
    managedEnvironmentId: managedEnvironments_managedEnvironment_rglaravelapp_9dfd_name_resource.id
    environmentId: managedEnvironments_managedEnvironment_rglaravelapp_9dfd_name_resource.id
    configuration: {
      secrets: [
        {
          name: 'app-key'
        }
        {
          name: 'db-connection'
        }
        {
          name: 'db-database'
        }
        {
          name: 'db-host'
        }
        {
          name: 'db-password'
        }
        {
          name: 'db-username'
        }
        {
          name: 'reg-pswd-5e905634-980b'
        }
      ]
      activeRevisionsMode: 'Single'
      ingress: {
        external: true
        targetPort: 80
        exposedPort: 0
        transport: 'Auto'
        traffic: [
          {
            weight: 100
            latestRevision: true
          }
        ]
        allowInsecure: false
      }
      registries: [
        {
          server: 'azcry.azurecr.io'
          username: 'azcry'
          passwordSecretRef: 'reg-pswd-5e905634-980b'
        }
      ]
    }
    template: {
      containers: [
        {
          image: 'azcry.azurecr.io/laravel-nginx:latest'
          name: 'laravel-nginx'
          resources: {
            cpu: '0.25'
            memory: '0.5Gi'
          }
          probes: []
          volumeMounts: [
            {
              volumeName: 'php-socket'
              mountPath: '/var/run/php-fpm'
            }
          ]
        }
        {
          image: 'azcry.azurecr.io/laravel-app:latest'
          name: 'laravel-app'
          env: [
            {
              name: 'APP_ENV'
              value: 'development'
            }
            {
              name: 'APP_DEBUG'
              value: 'true'
            }
            {
              name: 'APP_KEY'
              secretRef: 'app-key'
            }
            {
              name: 'APP_URL'
              value: 'laravel-psql-sample.azurewebsites.net'
            }
            {
              name: 'DB_CONNECTION'
              secretRef: 'db-connection'
            }
            {
              name: 'DB_HOST'
              secretRef: 'db-host'
            }
            {
              name: 'DB_DATABASE'
              secretRef: 'db-host'
            }
            {
              name: 'DB_USERNAME'
              secretRef: 'db-username'
            }
            {
              name: 'DB_PASSWORD'
              secretRef: 'db-password'
            }
          ]
          resources: {
            cpu: '0.25'
            memory: '0.5Gi'
          }
          probes: []
          volumeMounts: [
            {
              volumeName: 'php-socket'
              mountPath: '/var/run/php-fpm'
            }
          ]
        }
      ]
      scale: {
        minReplicas: 0
        maxReplicas: 10
      }
      volumes: [
        {
          name: 'laravel-files'
          storageType: 'AzureFile'
          storageName: 'laravel-files'
        }
        {
          name: 'php-socket'
          storageType: 'EmptyDir'
        }
      ]
    }
  }
}