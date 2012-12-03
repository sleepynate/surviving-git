use Rack::Static, 
    :urls => ["/stylesheets", "/images"],
    :index => "index.html",
    :root => "public"

run Rack::File.new('public')
