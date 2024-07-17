require 'csv'
class MasterController < ApplicationController
    before_action :cek_login
    before_action :require_admin, only: [:usersetting, :tambahalat, :reportdata]
    # before_action :check_activity_timeout
    before_action :set_no_cache, only: [:login]
    # before_action :authenticate_user! 
    # before_action :set_api_url
    layout "sidebarnw"

    def set_no_cache
        response.headers['Cache-Control'] = 'no-store, no-cache, must-revalidate, max-age=0'
        response.headers['Pragma'] = 'no-cache'
        response.headers['Expires'] = 'Mon, 01 Jan 1990 00:00:00 GMT'
    end

    def index
       
    end

    def home
        # Logika untuk halaman beranda
    end
    
    def about
        # Logika untuk halaman tentang kami
    end

    
    def dashboard
        # url = "aktifalat"
        # @alataktif = MasterHelper.req_get(url)
        # @data_alat = @alataktif['content']
        # url = "/baca"
        # @data_mqtt = MasterHelper.req_get(url)
        @api_key = ENV['API_KEY']
        # render json: @data_mqtt
        # Gunakan api_key sesuai kebutuhan Anda di sini
    end
    # =========aktifkan ketika ada alat iot===========
    def get_data_mqtt

        # url = "/last_monitorings/:alat_id"
        # aktfikan jika ada mqtt
        url = "/baca"
        @data_mqtt = MasterHelper.req_get(url)
        render json: @data_mqtt
      
    end



    
    def req_get(url)
        response = # ... Lakukan permintaan HTTP GET ke URL
        if response.success?
          response.data
        else
          [] # Mengembalikan array kosong jika terjadi kesalahan
        end
    end
      

    def grafiklux
    
    end

    def signup
        data = {
            email: params["email"],
            nama: params["nama"],
            password: params["password"],
            status: "1",
            user_role_id: "64e85e65abf2c224600f736d"
        }
        url= "/tambahuser"
        @signup = SignupHelper.req_post(url,data)
        if @signup['status']
            redirect_to "/login"
        else
            redirect_to "/signup"
        end
    end

    def login
    
    end

    def profileakun

        # if session['sess'] && session['sess']['id']
        #     url = "/user/" + session['sess']['id'].to_s
        #     # Rest of your code
        # else
        #     # Handle the case where 'sess' or 'id' is nil
        # end
        url = "/user/"+session['sess']['id'].to_s
        @profile = MasterHelper.req_get(url)
    end
 
    def editprofile
        data = {
            id: params['id'],
            nama: params['nama'],
            email: params['email'],
            password: params['password']
        }
        url = "/updateuser"
        @edit = MasterHelper.req_post(url,data)
        render json: @edit
    end

    # hanya admin akses usersetting ya
    def require_admin
        unless session["sess"]["role"] == 'admin'
          flash[:alert] = 'Anda tidak memiliki izin untuk mengakses halaman ini.'
          redirect_to "/master/dashboard" # Sesuaikan dengan path yang sesuai jika perlu.
        end
    end

    def tambahalat
        # untuk get alat
        url_alat= "/alats/all"
        @get_alat = MasterHelper.req_get(url_alat)
        if @get_alat['content'].present?
            @data_alat = @get_alat['content']
            @meta = @get_alat['meta']
        end
    end

    def simpan_alat
        if params["id_alat"].present?
            data  = {
                id: params['id_alat'],
                nama_alat: params['nama_alat'],
                lokasi: params['lokasi'],
                status: params['status'],
            }
            url_update_alat = "/updatealat"
            @update_alat = MasterHelper.req_post(url_update_alat, data)
            if @update_alat['status']==true
                redirect_to "/setting"
            else
                redirect_to "/setting"
            end
        else
            data  = {
                nama_alat: params['nama_alat'],
                lokasi: params['lokasi'],
                status: params['status'],
            }
            url_tambah_alat = "/tambahalat"
            @tambah_alat = MasterHelper.req_post(url_tambah_alat,data)
            if @tambah_alat['status']==true
                redirect_to '/setting'
            else
                redirect_to '/setting'
            end
        end
    end

    def hapus_alat
        if params['id'].present?
            url = "/hapusalat/"+params['id']
            Rails.logger.info"=======>#{url}"
            @hapus_alat = MasterHelper.req_post_hapus(url)
            render json: @hapus_alat
        end
    end
    
    def usersetting
        # untuk get alat
        url_user= "/users/all"
        @page = params[:page].present? ? params[:page].to_i: 1
        @limit = params[:limit].present? ? params[:limit].to_i: 10
        @keyword = params[:keyword].present? ? params[:keyword] : ''
        if @keyword == ''
            url = "/users/all?page=#{@page}&keyword=#{@keyword}"
        else
            url = "/users/all?page=1&keyword=#{@keyword}"
        end
        # Menggabungkan parameter page dan limit ke dalam URL permintaan
        
        url_user += "?page=#{@page}&limit=#{@limit}"

        url_user += "&keyword=#{@keyword}" unless @keyword.empty?
        
        @get_user = MasterHelper.req_get(url_user)
        if @get_user['content'].present?
            @data_user = @get_user['content']
            @meta = @get_user['meta']

            @start_page = (@page - 1) * @limit
            session[:page] = @page + 1
        end
    end
    
    def simpan_user
        Rails.logger.info"==========>#{params}"
        if params["id_user"].present?
            if params['role']=="user"
                role = "64e85e65abf2c224600f736d"
            else
                role = "64e85e87abf2c224600f736e"
            end
            data  = {
                id: params['id_user'],
                nama: params['nama'],
                email: params['email'],
                user_role_id: role,
                status: params['status_user'],
            }
            url_update_user = "/updateuser"
            @update_alat = MasterHelper.req_post(url_update_user, data)
            if @update_alat['status']==true
                redirect_to "/user"
            else
                redirect_to "/user"
            end
        else
            if params['role']=="user"
                role = "64e85e65abf2c224600f736d"
            else
                role = "64e85e87abf2c224600f736e"
            end
            data  = {
                nama: params['nama'],
                email: params['email'],
                user_role_id: role,
                status: params['status_user'],
            }
            url_tambah_user = "/tambahuser"
            @tambah_user = MasterHelper.req_post(url_tambah_user,data)
            if @tambah_user['status']==true
                redirect_to '/user'
            else
                redirect_to '/user'
            end
        end
    end
    
    def hapus_user
        if params['id'].present?
            url = "/hapususer/"+params['id']
            Rails.logger.info"=======>#{url}"
            @hapus_user = MasterHelper.req_post_hapus(url)
            render json: @hapus_user

            if @hapus_user['status'] == true
                
                flash[:notice] = "√ Akun berhasil dihapus."
            else
               
                flash[:alert] = "Gagal menghapus data."
            end
        else
            flash[:alert] = "ID tidak valid atau tidak ditemukan."
        end
    end

    def reportdata
        url = '/monitoring/all'
        page = params[:page].present? ? params[:page].to_i: 1
        limit = params[:limit].present? ? params[:limit].to_i: 10000

        # Menggabungkan parameter page dan limit ke dalam URL permintaan
        url += "?page=#{page}&limit=#{limit}"
        @cek_data = MasterHelper.req_get(url)
        if @cek_data['content'].present?
            @data = @cek_data['content']
            @meta = @cek_data['meta']

            @start_page = (page - 1) * limit + 1
        end
    end

    # def download_csv
    #     if params['tgl_mulai'].present? && params['tgl_akhir'].present?
    #         data = {
    #           tgl_mulai: params['tgl_mulai'],
    #           tgl_akhir: params['tgl_akhir']
    #         }
    #         url = "/data/monitoring"
    #         @get_data_csv = MasterHelper.req_post(url, data)
    #         @data_csv = @get_data_csv['content']
            
    #         filename = "reportIoT-MTM.csv"
    #         # Tell Rack to stream the content
    #         headers.delete("Content-Length")
    
    #         # Don't cache anything from this generated endpoint
    #         headers["Cache-Control"] = "no-cache"
    
    #         # Tell the browser this is a CSV file
    #         headers["Content-Type"] = "text/csv"
    
    #         # Make the file download with a specific filename
    #         headers["Content-Disposition"] = "attachment; filename=\"#{filename}\""
    
    #         # Don't buffer when going through proxy servers
    #         headers["X-Accel-Buffering"] = "no"
    
    #         # Set an Enumerator as the body
    #         self.response_body = parse_report(@data_csv)
    #         # Set the status to success
    #         response.status = 200
    #     end
    # end

    # ==============================untuk eksport csv========================
    def download_csv
        if params['tgl_mulai'].present? && params['tgl_akhir'].present?
            tgl_mulai = Date.parse(params['tgl_mulai'])
            tgl_akhir = Date.parse(params['tgl_akhir'])
                
            puts "tgl_mulai: #{tgl_mulai}" # Debugging: Cetak nilai tgl_mulai
            puts "tgl_akhir: #{tgl_akhir}" # Debugging: Cetak nilai tgl_akhir

            data = {
                tgl_mulai: tgl_mulai,
                tgl_akhir: tgl_akhir
            }
        
            url = "/data/monitoring"
            @get_data_csv = MasterHelper.req_post(url, data)
            @data_csv = @get_data_csv['content']
        
            # Sorting data based on date range
            sorted_data = @data_csv.select do |item|
                item_date = Date.parse(item['tanggal']) # Assuming tanggal is the date field in your data
                item_date >= tgl_mulai && item_date <= tgl_akhir
            end
        
            filename = "reportIoT-MTM-#{tgl_mulai.strftime('%Y%m%d')}-#{tgl_akhir.strftime('%Y%m%d')}.csv"

            headers.delete("Content-Length")
    
            # Don't cache anything from this generated endpoint
            headers["Cache-Control"] = "no-cache"
    
            # Tell the browser this is a CSV file
            headers["Content-Type"] = "text/csv"
    
            # Make the file download with a specific filename
            headers["Content-Disposition"] = "attachment; filename=\"#{filename}\""
    
            # Don't buffer when going through proxy servers
            headers["X-Accel-Buffering"] = "no"
        
            # Set the sorted data as the body
            self.response_body = parse_report(sorted_data)
            # Set the status to success
            response.status = 200
        end
    end
      

    # def parse_report(data_csv)
    #     Enumerator.new do |row|
    #         row << CSV.generate_line(['no','tanggal','jam','suhu','kelembaban','kebisingan','lux', 'debu', 'amonia', 'alat'],col_sep: ";")
    #         if data_csv.present?
    #             no = 0
    #             data_csv.each do |data|
    #                 row << CSV.generate_line([
    #                 no,
    #                 data['tanggal'],
    #                 data['jam'],
    #                 data['suhu'],
    #                 data['kelembaban'],
    #                 data['kebisingan'],
    #                 data['lux'],
    #                 data['debu'],
    #                 data['amonia'],
                    
    #                 ], col_sep: ";" ) 
    #                 no += 1
    #             end
    #         end
    #     end
    # end 

    
    

    def parse_report(data_csv)
        # Inisialisasi CSV string
        csv_string = CSV.generate(col_sep: ";") do |csv|
            csv << ['', '', '', '', 'Data', '', '', '', '', ]
            csv << [ ]
            csv << ['no', 'tanggal', 'jam', 'kebisingan', 'lux', 'debu', 'amonia', ]
            
            if data_csv.present?
                no = 1
                kebisingan_values = []
                lux_values = []
                debu_values = []
                amonia_values = []
    
                data_csv.each do |data|
                    # Mengganti koma dengan titik
                    csv << [
                        no,
                        data['tanggal'],
                        data['jam'],
                        data['kebisingan'],
                        data['lux'],
                        data['debu'],
                        data['amonia'],
                    ]
    
                    kebisingan_values << data['kebisingan'].to_f
                    lux_values << data['lux'].to_f
                    debu_values << data['debu'].to_f
                    amonia_values << data['amonia'].to_f
    
                    no += 1
                end
    
                # Menghitung rata-rata
                data_count = data_csv.size.to_f
                total_kebisingan = kebisingan_values.sum
                total_lux = lux_values.sum
                total_debu = debu_values.sum
                total_amonia = amonia_values.sum
    
                average_kebisingan = (total_kebisingan / data_count).round(2)
                average_lux = (total_lux / data_count).round(2)
                average_debu = (total_debu / data_count).round(2)
                average_amonia = (total_amonia / data_count).round(2)
    
                median_kebisingan = kebisingan_values.sort[data_count / 2]
                median_lux = lux_values.sort[data_count / 2]
                median_debu = debu_values.sort[data_count / 2]
                median_amonia = amonia_values.sort[data_count / 2]
    
                max_kebisingan = kebisingan_values.max
                max_lux = lux_values.max
                max_debu = debu_values.max
                max_amonia = amonia_values.max
    
                min_kebisingan = kebisingan_values.min
                min_lux = lux_values.min
                min_debu = debu_values.min
                min_amonia = amonia_values.min
    
                # Penggunaan kategori level
                kategori_kebisingan = if average_kebisingan < 30
                    'Sunyi'
                  elsif average_kebisingan > 30 && average_kebisingan <= 40
                    'Tenang'
                  elsif average_kebisingan > 40 && average_kebisingan <= 60
                    'Normal'
                  elsif average_kebisingan > 60 && average_kebisingan <= 85
                    'Cukup Tinggi'
                  else
                    'Tinggi'
                  end
                
                # Menentukan kategori lux
                kategori_lux = if average_lux < 100
                    'Sangat Rendah'
                  elsif average_lux >= 100 && average_lux <= 150
                    'Rendah'
                  elsif average_lux > 150 && average_lux <= 450
                    'Cukup'
                  elsif average_lux > 450 && average_lux <= 1000
                    'Tinggi'
                  else
                    'Sangat Tinggi'
                  end
    
                kategori_debu = if average_debu < 50
                    'Sangat Baik'
                  elsif average_debu >= 50 && average_debu <= 100
                    'Cukup Baik'
                  elsif average_debu > 100 && average_debu <= 300
                    'Tinggi'
                  else
                    'Sangat Tinggi'
                  end
    
                # Menambahkan baris rata-rata, median, maksimum, minimum
                csv << ['', 'Rata-rata', '', "#{average_kebisingan} dB", "#{average_lux} lx", "#{average_debu} Mc", "#{average_amonia} CO2"]
                csv << ['', 'Median', '', "#{median_kebisingan} dB", "#{median_lux} lx", "#{median_debu} Mc", "#{median_amonia} CO2"]
                csv << ['', 'Maksimum', '', "#{max_kebisingan} dB", "#{max_lux} lx", "#{max_debu} Mc", "#{max_amonia} CO2"]
                csv << ['', 'Minimum', '', "#{min_kebisingan} dB", "#{min_lux} lx", "#{min_debu} Mc", "#{min_amonia} CO2"]
                csv << ['', 'Kategori', '', kategori_kebisingan, kategori_lux, kategori_debu, '', '', '']
            end
        end
    
        return csv_string
    end
    
end