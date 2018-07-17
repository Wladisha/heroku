require 'net/http'
require 'mail'
require 'yaml'
config = YAML.load_file('data/config.yml')


Mail.defaults do
  delivery_method :smtp, { :address   => "smtp.sendgrid.net",
                           :port      => 587,
                           :domain    => "statistics.com",
                           :user_name => "apikey",
                           :password  => config["TEST_API_KEY"],
                           :authentication => 'plain',
                           :enable_starttls_auto => true }
end

class Email
  def standardemail(currencies, url)
    mail = Mail.deliver do
      to 'wladisha@gmail.com'
      from 'Currency statistics <currency@statistics.com>'
      subject 'Your daily currency statistics report'
      text_part do
        body "'The following currencies' #{currencies} changed for more than 5%"
      end
      html_part do
        content_type 'text/html; charset=UTF-8'
        body "<b> The following currencies' #{currencies} changed for more than 5%'</b>.<br />
        <img src = '#{url}'/>"
      end
    end
  end

  def firstemail(currencies)
    mail = Mail.deliver do
      to 'wladisha@gmail.com'
      from 'Currency statistics <currency@statistics.com>'
      subject 'Thank you for choosing CurrencyWatch'
      text_part do
        body "You have initialized CurrencyWatch. When any of your selected currencies: #{currencies} change for more than 5% in value, you will receive an email notification."
    end
    html_part do
      content_type 'text/html; charset=UTF-8'
      body "<b> You have initialized CurrencyWatch. When any of your selected currencies: #{currencies} change for more than 5% in value, you will receive an email notification .</b>"
      end
    end
  end
end
