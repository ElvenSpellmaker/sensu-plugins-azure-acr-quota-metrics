class BaseClient
  @@quota_metrics_type = 'Size'.freeze

  def set_credentials(spn_id = nil, spn_secret = nil, tenant_id = nil)
    @spn_id = spn_id
    @spn_secret = spn_secret
    @tenant_id = tenant_id
  end

  def quota_metrics_type
    @@quota_metrics_type
  end

  def quota_metrics_felds
    @@quota_metrics_fields
  end

end
