require 'slim'
require 'sinatra'
require 'securerandom'
require_relative 'parser'

include FileUtils::Verbose

UPLOADS_PATH = '../public/uploads/'

USERNAME = ENV['ELASTIC_USERNAME']
PASSWORD = ENV['ELASTIC_PASSWORD']
HOSTNAME = ENV['ELASTIC_HOSTNAME']
PORT = ENV['ELASTIC_PORT']

ELASTIC_URL  = "http://#{USERNAME}:#{PASSWORD}@#{HOSTNAME}:#{PORT}"

class FileUpload < Sinatra::Base

  configure do
    set :views, File.join(File.dirname(__FILE__), '../views')
    set :public_folder, File.join(File.dirname(__FILE__), '../public')
  end

  get '/' do
    slim :index
  end

  post '/upload' do
    puts "New image!"

    begin
      uploaded_file  = params[:file][:tempfile]
      file_extension = File.basename(uploaded_file).match(/.+(\.\w+)$/).captures[0]
      filepath       = File.join(UPLOADS_PATH, SecureRandom.uuid) + file_extension

      p uploaded_file
      p filepath

      File.open filepath, 'wb' do |file|
        p file
        file.write uploaded_file.read
      end

      puts 'debug'

      parser = InvoiceParser.new
      result = parser.parse_file(filepath)
      parser.print

      client = Elasticsearch::Client.new url: ELASTIC_URL, log: true

      client.create index: 'invoice', body: result
    rescue Exception => e
      puts "Error: #{e}"
    end

    redirect '/'
  end
end