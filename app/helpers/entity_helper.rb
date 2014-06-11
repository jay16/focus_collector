module EntityHelper

  def chk_params(transaction_id)
    params[:transaction] && params[:transaction] == transaction_id ? 1 : 0
  end
end
