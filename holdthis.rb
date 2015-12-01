#!/bin/env ruby

require 'yaml'
require 'mkmf'

module MakeMakefile::Logging
  @logfile = File::NULL
end

def create_storage_file()
        fname = ENV['HOME']+'/.holdthis'

        if (not File.file?(fname))
                store = File.open(fname, 'w') { |f| YAML.dump({}, f) }
        end

end

def load_data()
        create_storage_file()
        return YAML.load_file(ENV['HOME']+'/.holdthis') || {}
end

def lookup_bookmark(name)
        bookmarks = load_data()
        return storage[name]
end

def store_bookmark(name, path)
        storage = load_data()
        storage[name] = { 'type' => 'bookmark', 'path' => path }

        File.open(ENV['HOME']+'/.holdthis', 'w') { |f| YAML.dump(storage, f) }
end

def quote_path(path)

        if (path.include?("'"))
                path["'"] = "'\''"
        end
        return "'" + path + "'"
end

def open_bookmark(name)
        storage = load_data()

        path_array = storage[name]['path']

        executable = find_executable(path_array[0])
        path = path_array.join(' ')

        if (executable != nil)
                puts path
                puts "<enter> to run this, e to edit it,  or <ctrl+c> to cancel."
                option = gets.chomp()
                if (option == "e")
                        exec(ENV['EDITOR'] + " " + quote_path(path))
                end
                exec(path)

        elsif (File.file?(path))
                puts "Opening " + path
                exec("xdg-open " + quote_path(path))

        elsif (File.directory?(path))
                puts ("Going to " + path)
                exec('cd ' + quote_path(path))
        end
end

def main()
        options = {:create => false}

        bookmark_name = nil
        bookmark_value = nil
        bookmark_type = nil
        create = false

        first_arg = ARGV.shift()

        if ['-n', '--new'].include?(first_arg)
                create = true
                bookmark_name = ARGV.shift()
                bookmark_value = ARGV[0..-1]
                bookmark_type = 'bookmark'
                store_bookmark(bookmark_name, bookmark_value)

        elsif ['-l', '--list'].include?(first_arg)
                storage = load_data()
                storage.each do |key, value|
                        puts key + ": " + value['path'].join(' ')
                end
        else
                open_bookmark(first_arg)

        end

end

main()

