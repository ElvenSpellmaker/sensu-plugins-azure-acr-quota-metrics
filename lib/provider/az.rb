require_relative 'base'
require 'json'

class AzClient < BaseClient
  def acr_list
    az('acr list')
  end

  def acr_show_usage(acr_name, acr_resource_group)
    az("acr show-usage -g #{acr_resource_group} -n #{acr_name}")
  end

private

  def az(command)
    az_output = %x(#{__dir__}/az.bash -c "#{command}" -i "#{@spn_id}" -p "#{@spn_secret}" -t "#{@tenant_id}")
    JSON.parse(az_output)
  end
end
