require 'slim'
require 'sinatra'
require 'securerandom'

include FileUtils::Verbose

UPLOADS_PATH = 'public/uploads/'

class FileUpload < Sinatra::Base

  configure do
    set :views, File.join(File.dirname(__FILE__), 'views')
    set :public_folder, File.join(File.dirname(__FILE__), 'public')
  end 

  get '/' do
    slim :index
  end

  post '/upload' do
    # original_filename = params[:file][:filename]
    puts 'hey there'
    uploaded_file = params[:file][:tempfile]
    filename = File.join UPLOADS_PATH, SecureRandom.uuid

    File.open filename, 'wb' do |file|
      file.write uploaded_file.read
    end

    redirect '/'
  end

end