module ParamSetters
  extend ActiveSupport::Concern

  def set_common_options
    @sort = set_sort
    @order = set_order
    @page = set_page
    @per_page = set_per_page
    @paginate = set_paginate
    @search = set_search
    @filters = set_filters
  end

  private

  #####################################################
  ## Controller helper methods to be overwritten
  #####################################################
  def enable_id_order
    true
  end

  def translated_column
    'id' # This method should be overwritten
  end

  def apply_filters(obj)
    # This method should be overwritten if filters are to be used
    obj
  end
  #####################################################

  def sort_column
    params[:sort]
  end

  def set_sort
    translated_column
  end

  def set_order
    %w[ASC DESC].include?(params[:order].to_s.upcase) ? params[:order].to_s.upcase : 'ASC'
  end

  def set_page
    params[:page].to_i.zero? ? 1 : params[:page]
  end

  def set_per_page
    page_num = params.to_unsafe_h.to_snake_keys.symbolize_keys[:per_page].to_i
    (1..1000).cover?(page_num) ? page_num : 25
  end

  def set_paginate
    !%w[false 0].include?(params[:paginate].to_s.downcase)
  end

  def set_search
    params[:search].blank? ? nil : params[:search]
  end

  def set_filters
    return {} if params[:filters].blank?

    JSON.parse(params.to_unsafe_h.to_snake_keys['filters'].to_json, symbolize_names: true)
  end
end
