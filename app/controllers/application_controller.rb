class ApplicationController < ActionController::Base
  protect_from_forgery
  layout :set_layout
  around_filter :pry_rescue if Rails.env == 'development'

  def pry_rescue
    Pry::rescue{ yield }
  end

  def pjax?
  	return true if request.headers['X-PJAX']
  end

	private

	def set_layout
		if request.headers['X-PJAX']
		  false
		else
		  "application"
		end
	end

end
