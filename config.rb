require 'ostruct'
require 'yaml'

###
# Compass
###

# Change Compass configuration
# compass_config do |config|
#   config.output_style = :compact
# end

###
# Page options, layouts, aliases and proxies
###

page 'sponsorship.html'
page 'venue.html'
page 'speakers.html'
# Per-page layout changes:
#
# With no layout
# page "/path/to/file.html", :layout => false
#
# With alternative layout
# page "/path/to/file.html", :layout => :otherlayout
#
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

# Proxy pages (http://middlemanapp.com/basics/dynamic-pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", :locals => {
#  :which_fake_page => "Rendering a fake page with a local variable" }

###
# Helpers
###

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

# Reload the browser automatically whenever files change
configure :development do
  activate :livereload
end

# Methods defined in the helpers block are available in templates
# helpers do
#   def some_helper
#     "Helping"
#   end
# end

helpers do
  def packages
    YAML.load_file('sponsorship_packages.yml').map do |package|
      OpenStruct.new package
    end
  end

  def speakers
    YAML.load_file('speakers.yml').map { |speaker|
      OpenStruct.new speaker
    }.select(&:show)
  end

  def accommodations
    data = YAML.load_file('accommodations.yml').map { |a| OpenStruct.new a}
    {
      hotel: data.select { |a| a.type == 'hotel' },
      bnb: data.select { |a| a.type == 'bnb' },
    }
  end

  def find_speaker(name)
    speakers.find { |s| s.name == name }
  end

  def talks
    speakers.map { |s|
      {
        title: s.talk_title,
        speaker: s.name,
        abstract: s.abstract
      }
    }
  end
end

set :css_dir, 'stylesheets'

set :js_dir, 'javascripts'

set :images_dir, 'images'

# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  # activate :minify_css

  # Minify Javascript on build
  # activate :minify_javascript

  # Enable cache buster
  # activate :asset_hash

  # Use relative URLs
  # activate :relative_assets

  # Or use a different image path
  # set :http_prefix, "/Content/images/"
end
