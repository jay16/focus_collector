module HomeHelper
  def chk_params(tea_id)
    params[:tea] && params[:tea].to_i == tea_id ? 1 : 0
  end
end
