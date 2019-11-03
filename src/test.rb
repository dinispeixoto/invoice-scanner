class Test
  require 'json'
  require_relative 'parser'

  REGEX_FILE = /(.+)_in./

  def run
    begin
      Dir['tests/*_in.txt'].each do |input_filename|
        filename_prefix = input_filename.match(REGEX_FILE).captures[0]
        result          = test(input_filename, filename_prefix)

        puts "#{filename_prefix} => #{result}"
      end
    rescue Exception => e
      p "Error: #{e}"
    end
  end

  private

  def test(input_filename, filename_prefix)
    output_filename = Dir["#{filename_prefix}_out.json"].first

    output = JSON.parse(File.read(output_filename).to_json, symbolize_names: true)
    input  = InvoiceParser.new.parse_file(input_filename)

    input == output
  end
end
