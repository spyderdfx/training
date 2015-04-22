require 'resque/job_with_status'

class SearchJob
  include Resque::Plugins::Status

  @queue = :simple

  def perform
    file_name = options['file_name']
    search_word = options['search_word']

    found_lines = Array.new
    file_path = Rails.root.join('public').to_s + "/#{file_name}"
    file_path_found_lines = file_path + '_found'

    File.open(file_path) do |f|
      f.each do |line|
        found_lines << line if line.include?(search_word)
      end
    end

    if found_lines.size > 0
      File.open(file_path_found_lines, "w+") do |f|
        f.puts(found_lines)
      end
    else
      File.open(file_path_found_lines, "w+") do |f|
        f.puts('!Not found!')
      end
    end

    sendmail(file_name, file_path_found_lines)

    File.delete(file_path_found_lines) if File.exist?(file_path_found_lines)
    File.delete(file_path) if File.exist?(file_path)
  end

  def sendmail(file_name, file_path)
    Mail.defaults do
      delivery_method :smtp, {
        :address => 'smtp.gmail.com',
        :port => 587,
        :user_name => 'mikhail.test.acc@gmail.com',
        :password => 'abakpresstestacc',
        :authentication => :plain,
        :enable_starttls_auto => true
      }
    end

    mail = Mail.new do
      from     'mikhail.test.acc@gmail.com'
      to       'mikhail.nelaev@gmail.com'
      subject  'Found lines'
      add_file :filename => file_name, :content => File.read(file_path)
    end

    mail.deliver!
  end
end
