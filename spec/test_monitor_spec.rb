RSpec.describe 'AzureAcrQuotaMetrics' do
  context "" do
    it "Parses the JSON data to produce acr quota metrics, excluding classic instances" do
      metrics = %x(ruby spec/helper.rb)

      expected = [
        'sensu.my-docker-registry.used 12377246975',
        'sensu.my-docker-registry.remaining 94996935425',
        'sensu.my-premium-docker-registry.used 12377246975',
        'sensu.my-premium-docker-registry.remaining 94996935425',
      ].sort!

      expect(metrics.lines.count).to equal(expected.count)

      metrics.split(/\n+/).sort!.each_with_index do |line, index|
        expect(line).to start_with(expected[index])
      end
    end
  end
end
