namespace :k8s do
  task upload_secrets: :environment do
    if Rails.env.production?
      config_path = Rails.root.join('config', 'credentials', 'production.yml.enc')
      key_path = Rails.root.join('config', 'credentials', 'production.key')
    else
      config_path = Rails.root.join('config', 'credentials.yml.enc')
      key_path = Rails.root.join('config', 'master.key')
    end
    encrypted = ActiveSupport::EncryptedConfiguration.new(
      config_path: config_path,
      key_path: key_path,
      env_key: "",
      raise_if_missing_key: StandardError.new("Missing encryption key!")
    )
    k8s_secrets = []
    (flatten_keys = lambda do |prefix, h, r|
      h.each do |k, v|
        key = [prefix, k.to_s].reject(&:blank?).join('_')
        if v.is_a?(Hash)
          flatten_keys.call(key, v, r)
        else
          r << { key => v }
        end
      end
    end).call('', encrypted.config, k8s_secrets)
    k8s_secrets = k8s_secrets.inject({}, :update)
    k8s_secrets['rails_production_key'] = File.read(key_path)
    k8s_secrets['rails_production_yml_enc'] = File.read(config_path)
    literals = k8s_secrets.map { |k, v| "--from-literal=#{k}=#{v}" }.join(" ")
    puts `kubectl create secret generic rok-production-credentials #{literals} --dry-run=client -o yaml | kubectl apply -f -`
  end
end
