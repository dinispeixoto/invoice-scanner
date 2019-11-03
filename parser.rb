require 'pp'
require 'json'
require 'date'

class InvoiceParser
  REGEX_TOTAL   = /^[Tt][Oo][Tt][Aa][Ll] ?[Aa] ?[Pp][Aa][Gg][Aa][Rr][ \t\r]+(\d+, ?\d+)\n/m
  REGEX_PRODUCT = /[EC] \d{1,2}% ([^,]+)(\n(. )?\d+, ?\d+ ?[Xx] ?\d+, ?\d+)? (\d+, ?\d+)/m

  def initialize
    @result = {}
    @result[:date]        = DateTime.now.iso8601(3)
    @result[:products]    = []
    @result[:currency]    = 'EUR'
    @result[:supermarket] = 'Pingo Doce'
  end

  def parse_file(filepath)
    begin
      filename = pre_processed_image(filepath)
      file     = File.read(filename)

      extract_info(file)
      remove_files(['tmp/', 'public/uploads/'])
    rescue Exception => e
      p "Error: #{e}"
    end

    @result
  end

  def write(filename)
    File.open(filename, 'w') do |file|
      file.write(@result.to_json)
    end
  end

  def print
    puts JSON.pretty_generate(JSON.parse(@result.to_json))
  end

  private

  def extract_info(file_data)
    if file_data =~ REGEX_PRODUCT
      file_data.scan(REGEX_PRODUCT).each do |values|
        product_name, _, _, product_price = values

        @result[:products] << {
          name: product_name,
          price: price_to_float(product_price),
        }
      end
    end

    if file_data =~ REGEX_TOTAL
      @result[:total] = price_to_float(file_data.scan(REGEX_TOTAL)[0][0])
    else
      @result[:total] = @result[:products].reduce(0.0) { |total, product| total + product[:price] }
    end
  end

  def price_to_float(price)
    price
      .sub(/,/, '.')
      .sub(/ /, '')
      .sub(/O/, '0')
      .to_f
  end

  def pre_processed_image(filepath)
    filename = filepath.match(/public\/uploads\/(.+)\.\w+/).captures[0]

    puts "improving #{filename}"
    `mkdir -p tmp`
    `convert "#{filepath}" -brightness-contrast -20x50 -colorspace Gray "tmp/improved_#{filename}.jpg"`

    puts "cropping #{filename}"
    `./multicrop "tmp/improved_#{filename}.jpg" "tmp/cropped_improved_#{filename}.jpg"`

    puts "bordering #{filename}"
    `convert "tmp/cropped_improved_#{filename}-000.jpg" -bordercolor white -border 5% "tmp/bordered_cropped_improved_#{filename}.jpg"`

    puts "tesseract #{filename}"
    `tesseract --dpi 300 --psm 6 tmp/bordered_cropped_improved_#{filename}.jpg tmp/#{filename}`

    "tmp/#{filename}.txt"
  end

  def remove_files(filepaths)
    filepaths.each do |filepath|
      Dir[filepath + '*'].each { |file| File.delete(file) }
    end
  end
end
