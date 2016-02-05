#!/bin/env ruby

require 'yaml'
require 'mkmf'

module MakeMakefile::Logging
  @logfile = File::NULL
end

def save_data(data)
        fname = ENV['HOME']+'/.holdthis'

        File.open(fname, 'w') { |f| YAML.dump(data, f) }
end

def load_data()
        fname = ENV['HOME']+'/.holdthis'
        if (not File.file?(fname))
                save_data({})
                return {}
        end
        return YAML.load_file(fname) || {}
end

def store_bookmark(name, path)
        storage = load_data()
        storage[name] = { 'type' => 'bookmark', 'path' => path }

        save_data(storage)
end

def delete_bookmark(name)
        storage = load_data()
        storage.delete(name)

        save_data(storage)
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
        path = path_array.join(' ')
        executable = find_executable(path_array[0])

        if (executable != nil and path_array.length > 1)
                puts path
                puts "<enter> to run this, or <ctrl+c> to cancel"

                option = gets.chomp()
                exec(path)

        elsif (executable != nil)
                puts path
                puts "<enter> to run this, e to edit it,  or <ctrl+c> to cancel."
                option = gets.chomp()
                if (option == "e")
                        exec(ENV['EDITOR'] + " " + quote_path(path))
                end
                exec(path)

        elsif (File.file?(path) or File.directory?(path))
                puts "Opening " + path
                exec("xdg-open " + quote_path(path))

        else
                puts path
        end
end

def list_bookmarks()

        storage = load_data()

        longest_key = storage.max_by{|a,b| a.length}.first
        max_length = longest_key.length

        storage.each do |key, value|
                length_diff = max_length - key.length

                padding = " " * length_diff
                puts key + ": " + padding + value['path'].join(' ')
        end
end

def main()

        first_arg = ARGV.shift()

        if ['-n', '--new'].include?(first_arg)
                bookmark_name = ARGV.shift()
                bookmark_value = ARGV[0..-1]
                store_bookmark(bookmark_name, bookmark_value)

        elsif ['-l', '--list'].include?(first_arg)
                list_bookmarks()

        elsif ['-d', '--delete'].include?(first_arg)
                delete_bookmark(ARGV.shift())

        else
                open_bookmark(first_arg)

        end

end

main()

