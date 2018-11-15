#! /usr/bin/env ruby

require 'json'
require 'parallel'
require 'sensu-plugin/metric/cli'
require 'time'

class AzureAcrQuotaMetrics < Sensu::Plugin::Metric::CLI::Graphite
  option :schema,
         description: 'Metric naming scheme, text to prepend to metric',
         short: '-s SCHEME',
         long: '--scheme SCHEME',
         default: 'sensu'

  option :spn_id,
         description: 'The SPN ID with read access to the subscription',
         short: '-i',
         long: '--spn-id <SPN ID>',
         default: nil

  option :spn_secret,
         description: 'The SPN secret for the SPN ID',
         short: '-p',
         long: '--spn-secret <SPN Secret>',
         default: nil

  option :tenant_id,
         description: 'The Tenant ID for the SPN ID',
         short: '-t',
         long: '--tenant-id <Tenant ID>',
         default: nil

  @@time_format = '%Y-%m-%dT%H:%M:%SZ'
  @@classic_sku = 'Classic'

  def initialize(argv = ARGV, metrics_client = 'az')
    super argv

    dir = __FILE__ === '(eval)' ? '.' : "#{__dir__}/../"
    require "#{dir}/lib/provider/#{metrics_client}.rb"
    metrics_upper = metrics_client.capitalize
    @metrics_client = Object.const_get("#{metrics_upper}Client").new
  end

  def run
    @metrics_client.set_credentials(
      config[:spn_id],
      config[:spn_secret],
      config[:tenant_id],
  )

    time = Time.now.utc

    container_registries = @metrics_client.acr_list

    Parallel.map(container_registries, in_threads: 5) { |acr|
      # Classic ACR doesn't have a quota as it's 'unmanaged' (it's as large as
      # the storage account is).
      next if acr['sku']['tier'] == @@classic_sku

      process_acr(acr, time)
    }

    ok
  end

private

  def process_acr(acr, time)
    acr_name = acr['name']
    acr_resource_group = acr['resourceGroup']

    usage_metrics = @metrics_client.acr_show_usage(acr_name, acr_resource_group)

    usage_metrics['value'].each { |metric_dimension|
      next if metric_dimension['name'] != @metrics_client.quota_metrics_type

      current_quota = metric_dimension['currentValue']
      remaining_quota = metric_dimension['limit'] - current_quota

      output [config[:schema], acr_name, 'used'].join('.'), current_quota, time.to_i
      output [config[:schema], acr_name, 'remaining'].join('.'), remaining_quota, time.to_i

      break
    }
  end
end
