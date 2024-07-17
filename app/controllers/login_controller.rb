class LoginController < ApplicationController
    before_action :login, only: [:login]
    def index
        @recaptcha_site_key = ENV['RECAPTCHA_SITE_KEY']
        # render plain: "reCAPTCHA Site Key: #{@recaptcha_site_key}"
        # @Recaptha = ENV['Recaptha']
        if session['sess'].present?
            response.headers['Cache-Control'] = 'no-store, no-cache, must-revalidate, max-age=0'
            response.headers['Pragma'] = 'no-cache' 
            response.headers['Expires'] = 'Mon, 01 Jan 1990 00:00:00 GMT'
            redirect_to '/master/dashboard'
        end
    end
    def login
        recaptcha_site_key = ENV['RECAPTCHA_SITE_KEY']
        # render plain: "reCAPTCHA Site Key2: #{recaptcha_site_key}"
        data = {
            email: params['email'],
            password: params['password']
        }

        # @Recaptha = ENV['Recaptha']
        # render json: data 
        # return
        url = "/login"
        @ceklogin = LoginHelper.req_post(url,data)
        
        if @ceklogin['status']
            my_sess = {
                id: @ceklogin['content']['id'],
                nama: @ceklogin['content']['nama'],
                email: @ceklogin['content']['email'],
                password: @ceklogin['content']['password'],
                role: @ceklogin['content']['user_role']
            }
            session['sess'] = my_sess
            flash[:success] = "anda berhasil Login"
            
            redirect_to "/master/dashboard"
            response.headers['Cache-Control'] = 'no-store, no-cache, must-revalidate, max-age=0'
            response.headers['Pragma'] = 'no-cache' 
            response.headers['Expires'] = 'Mon, 01 Jan 1990 00:00:00 GMT'
            
        else
            flash[:notice] = "Password atau username salah."
            redirect_to "/login"
            # render json: @ceklogin
        end
        

        # render json: @ceklogin
        
    end

    # def signup
    #     data = {
    #         email: params["email"],
    #         nama: params["nama"],
    #         password: params["password"],
    #         status: "1",
    #         user_role_id: "64e85e65abf2c224600f736d"
    #     }
    #     url= "/tambahuser"
    #     @signup = LoginHelper.req_post(url,data)
    #     if @signup['status']
    #         redirect_to "/login"
    #     else
    #         redirect_to "/login"
    #     end
    # end
    
    def signup
        data = {
            email: params["email"],
            nama: params["nama"],
            password: params["password"],
            status: "1",
            user_role_id: "64e85e65abf2c224600f736d"
        }
        url= "/tambahuser"
        @signup = LoginHelper.req_post(url,data)
        if @signup['status']
            flash[:success] = '✓ Akun Berhasil dibuat'
            redirect_to "/login"
        else
            flash[:error] = 'Email telah digunakan !'
            redirect_to "/login"
        end
    end

    def logout
        reset_session
        redirect_to "/login"
    end

    
end