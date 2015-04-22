class Datafile
  attr_accessor :upload

  def self.save_file(upload)
    file_name = upload.original_filename
    file = upload.read

    file_root = Rails.root.join('public').to_s

    File.open(file_root + "/" + file_name, "wb")  do |f|
      f.write(file)
    end
  end
end
