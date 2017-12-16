module SetupConfiguration
  def self.extended(object)
    object.instance_exec do
      let(:configure) do
        GetAddress.configure do |config|
          config.api_key      = "MY_API_KEY"
          config.format_array = true
          config.sort         = false
        end
      end
      let(:config) do
        configure
        GetAddress.config
      end
    end
  end
end
