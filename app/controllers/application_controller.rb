class ApplicationController < ActionController::Base
  protect_from_forgery
  layout :set_layout

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
