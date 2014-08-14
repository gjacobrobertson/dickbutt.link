require 'sinatra/base'
require 'sinatra/assetpack'
require 'mini_magick'

class Dickbutt < Sinatra::Base
  class SizeTooLargeError < RuntimeError
  end
  MAX_SIZE = 4096
  set :root, File.dirname(__FILE__)

  register Sinatra::AssetPack

  assets do
    serve '/js', from: 'js'
    serve '/css', from: 'css'
    serve '/fonts', from: 'fonts'
    serve '/img', from: 'img'

    js :app, [
      '/js/vendor/jquery.js',
      '/js/vendor/jquery.validate.js',
      '/js/vendor/bootstrap.js',
      '/js/main.js'
    ]

    css :application, [
      '/css/bootstrap.css',
      '/css/screen.css'
    ]

    js_compression :jsmin
    css_compression :simple
  end

  error SizeTooLargeError do
    'The requested dickbutt is too large'
  end

  get '/' do
    slim :index
  end

  get %r{(\d+)x(\d+)} do
    width, height = params[:captures].map{|x| x.to_i}
    if width > MAX_SIZE or height > MAX_SIZE
      raise SizeTooLargeError
    end

    content_type "image/jpeg"
    resize_image File.join(settings.root, 'img', 'dickbutt.jpg'), width, height
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