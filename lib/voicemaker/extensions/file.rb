require 'fileutils'

class File
  class << self
    def deep_write(file, content)
      dir = File.dirname file
      FileUtils.mkdir_p dir unless Dir.exist? dir
      File.write file, content
    end
  end
end
