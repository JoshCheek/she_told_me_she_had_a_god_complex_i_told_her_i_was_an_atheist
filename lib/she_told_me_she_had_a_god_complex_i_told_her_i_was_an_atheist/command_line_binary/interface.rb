module SheToldMeSheHadAGodComplexIToldHerIWasAnAtheist
  class CommandLineBinary
    class Interface
      attr_accessor :io, :password_filename, :exit_status, :success_callback

      def initialize(io, password_filename, &success_callback)
        self.io                = io
        self.password_filename = password_filename
        self.success_callback  = success_callback
      end

      def retrieve_encrypted_file
        return File.read password_filename if File.exist? password_filename
      end

      def fail_cuz_you_need_a_password_file
        io.failure "there is no password file at #{password_filename.inspect}, to create it, set the master password"
        self.exit_status = 1
      end

      def master_password
        @master_password ||= io.password 'enter your master password: '
      end

      def fail_cuz_your_master_password_is_wrong
        io.failure "incorrect master password"
        self.exit_status = 1
      end

      def get_name
        @name ||= io.ask "what is this a password for? "
      end

      def fail_cuz_invalid_name
        io.failure "invalid name"
        self.exit_status = 1
      end

      def should_override_name?
        @override_name ||= io.boolean "#{get_name.inspect} is already being stored, override it? (y/N)",
            true: /^y/i,
            false: /^n/i,
            default: false
      end

      def fail_cuz_no_name_override
        self.exit_status = 0
      end

      def get_search_words(name)
        @search_words ||= io.ask "enter search words: "
      end

      def get_password(name)
        @password ||= io.password "enter the password for #{name}: "
      end

      def persist_encrypted_file(encrypted_file)
        File.open(password_filename, 'w') { |f| f.write encrypted_file }
      end

      def success
        self.exit_status = 0
        success_callback.call
        exit_status
      end

      def old_master_password
      end

      def new_master_password
      end

    end
  end
end
