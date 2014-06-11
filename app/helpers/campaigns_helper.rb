module CampaignsHelper
  def is_active(tea)
    params[:tea] && params[:tea].to_i == tea.id
  end
end
