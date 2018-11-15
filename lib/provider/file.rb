require_relative 'base'
require 'json'

class FileClient < BaseClient
  def acr_list
    file_get_contents('spec/acr_list.json')
  end

  def acr_show_usage(acr_name, acr_resource_group)
    file_get_contents('spec/acr_show_usage.json')
  end

  private

  def file_get_contents(file_name)
    JSON.parse(File.open(file_name, 'r') { |file| file.read })
  end
end
