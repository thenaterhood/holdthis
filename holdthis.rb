#!/bin/env ruby

require 'yaml'

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

def store_path_bookmark(name, path)
        storage = load_data()
        storage[name] = { 'type' => 'bookmark', 'path' => path }

        File.open(ENV['HOME']+'/.holdthis', 'w') { |f| YAML.dump(storage, f) }
end

def store_command_bookmark(name, command)
        storage = load_data()
        storage[name] = { :type => 'command', :path => command }

        File.open(ENV['HOME']+'/.holdthis', 'w') { |f| YAML.dump(storage, f) }
end

def open_bookmark(name)
        storage = load_data()

        puts storage[name]['path'].join(' ')
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
                store_path_bookmark(bookmark_name, bookmark_value)

        elsif ['-c', '--command'].include?(first_arg)
                create = true
                bookmark_name = first_arg
                bookmark_value = ARGV[0..-1]
                bookmark_type = 'command'
                store_command_bookmark(bookmark_name, bookmark_value)

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

