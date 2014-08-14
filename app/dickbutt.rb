require 'sinatra/base'
require 'mini_magick'

class Dickbutt < Sinatra::Base
  get '/' do
    'Hello world!'
  end

  get %r{(\d+)x(\d+)} do
    width, height = params[:captures].map{|x| x.to_i}
    content_type "image/jpeg"
    resize_image "img/dickbutt.jpg", width, height
  end

  def resize_image(path, width, height)
    size = [width, height].min - 2
    image = MiniMagick::Image.open path
    image.resize "#{size}x#{size}"

    image.combine_options do |opts|
      opts.extent "#{width - 2}x#{height - 2}"
      opts.gravity 'center'
      opts.background 'white'
    end

    image.combine_options do |opts|
      opts.bordercolor "#000000"
      opts.border 1
    end
    image.to_blob
  end
end