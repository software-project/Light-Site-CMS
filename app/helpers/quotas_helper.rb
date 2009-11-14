module QuotasHelper
  def get_quotas
    quotas = Quota.find(:all, :conditions => ["language_id = ?", session[:language].id])
    quotas[rand(quotas.size)]
  end

end
