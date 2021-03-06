class CaptchaController < ApplicationController
  def generate
    # generate captcha using cool-captcha
    raw_out = `cd #{RAILS_ROOT}/extra && php5 captcha.php`

    # find index of captcha text
    captag = "%CAPTCHA%"
    capt_pos = raw_out.index(captag)

    # extract captcha text
    captcha = raw_out[capt_pos + captag.length, raw_out.length]
    session[:captcha] = captcha
    
    # extract raw jpg
    raw_jpg = raw_out[0, capt_pos]

    send_data raw_jpg, :type => 'image/jpg',:disposition => 'inline'
    
  rescue => details
    general_rescue details
    if not session[:captcha].nil? then
      session.delete(:captcha)
    end
  end

end
