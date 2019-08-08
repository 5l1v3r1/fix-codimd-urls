#!/usr/bin/env ruby
# Sabri | @KINGSABRI
# Fix images path in CodiMD notes backup to be relative path
# 
require 'optparse'
require 'pathname'
require 'uri'

opts   = {}
parser = OptionParser.new do |opt|
  opt.banner = "Fix CodiMD URLs"
  opt.on('-n', '--notes-dir [DIR]',      'The directory that contains all markdown notes',  '  e.g. /local/path/notes')            {|v| opts[:notes]  = v}
  opt.on('-l', '--local-uploads [DIR]',  'local directory where all images are stored.',    '  e.g. /local/path/images')           {|v| opts[:local]  = v}
  opt.on('-r', '--remote-uploads [URL]', 'The upload URL where images have been uploaded.', '  e.g. http://hostname:3000/uploads') {|v| opts[:remote] = v}
  opt.on_tail "Usage:"
  opt.on_tail "ruby #{$PROGRAM_NAME} -n /local/path/notes -l /local/path/images -r http://hostname:3000/uploads"
end
parser.parse! ARGV

if opts[:notes] && opts[:local] && opts[:remote]
  notes_path  = opts[:notes]
  local_path  = opts[:local]
  remote_url  = opts[:remote]
  recursive   = File.join(notes_path, '**', '*.md')
  Dir.glob(recursive).each do |file|
    Dir.chdir(File.dirname(file))
    relative = Pathname.new(local_path).relative_path_from(Dir.pwd).to_s
    content  = File.open(file).read.gsub(remote_url, "#{relative}/")
    File.write(file, content)
    puts "File fixed: #{file}"
  end
  puts "[+] Done!"
else
  puts parser
end
