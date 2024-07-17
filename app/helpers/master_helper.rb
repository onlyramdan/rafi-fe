require 'httparty'
module MasterHelper
    # def self.req_get(url_path)
    #     url = ENV['API_IoT']+url_path
    #     res = HTTParty.get(url)
    #     return res.parsed_response
    # end

    # Di dalam MasterHelper
    def self.req_get(url_path)
        url = ENV['API_IoT'] + url_path
        begin
        res = HTTParty.get(url)
    
        if res.success?
            return res.parsed_response
        else
            # Handle kasus permintaan berhasil tetapi data tidak ada
            return [] if res.code == 404
    
            # Handle kasus permintaan gagal dengan status lain
            raise StandardError, "HTTP request failed with status code #{res.code}"
        end
        rescue StandardError => e
        # Tangani kesalahan lain yang mungkin terjadi selama permintaan
        Rails.logger.error("Error during HTTP request: #{e.message}")
        return [] # Mengembalikan array kosong jika terjadi kesalahan
        end
    end
  
    def self.req_post(url_path,data)
        url = ENV['API_IoT']+url_path
        res = HTTParty.post(url,
            :body => data,
            verify: false
        )
        return res.parsed_response
    end
    
    def self.req_post_hapus(url_path)
        Rails.logger.info"====== helper=========>#{url_path}"
        url = ENV['API_IoT']+url_path
        Rails.logger.info"====== helper=========>#{url}"
        res = HTTParty.post(url)
        return res.parsed_response
    end
end