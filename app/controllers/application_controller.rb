class ApplicationController < ActionController::Base
  # before_action :check_activity_timeout
  # protect_from_forgery with: :null_session,
  # if: Proc.new {|c| c.request.format =~ %r{application/json}}
  protect_from_forgery with: :exception,   
  # protect_from_forgery with: :null_session,
  if: Proc.new { |c| c.request.format =~ %r{application/json} }
  rescue_from ActionController::RoutingError, with: :render_404
  private
    
  # def check_activity_timeout
  #   if session['last_activity_time'] && session['last_activity_time'] < 5.minutes.ago
  #     session.delete('sess') # Logout otomatis jika pengguna tidak aktif selama 5 menit
  #     flash[:notice] = "Anda telah logout otomatis karena tidak aktif selama 5 menit."
  #     redirect_to '/login' and return
  #   else
  #     # Perbarui waktu aktivitas terakhir setiap kali pengguna melakukan aksi
  #     session['last_activity_time'] = Time.now
  #   end
  # end

  def cek_login
    if session['sess'].blank?
        
        redirect_to '/login'
        flash[:notice] = "Anda harus masuk terlebih dahulu."
        
    end

  #     render json: "/login"
  #     return
  end

  

  # def render_404
  #   respond_to do |format|
  #     format.html { render file: "#{Rails.root}/public/404.html", status: :not_found, layout: false }
  #     format.any { head :not_found }
  #   end
  # end
end
