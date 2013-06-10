module SheToldMeSheHadAGodComplexIToldHerIWasAnAtheist
  class CommandLineBinary

    class UserInteraction
      attr_accessor :argv, :io, :password_filename, :exit_status, :succeed_callback

      def initialize(argv, io, password_filename, &succeed_callback)
        self.argv              = argv
        self.io                = io
        self.password_filename = password_filename
        self.succeed_callback  = succeed_callback || Proc.new {}
      end

      def words_searched_for
        argv
      end

      def retrieve_encrypted_passwords
        return File.read password_filename if File.exist? password_filename
      end

      def fail_cuz_you_have_no_encrypted_passwords
        io.failure "there is no password file at #{password_filename.inspect}, to create it, set the master password"
        self.exit_status = 1
      end

      def master_password
        @master_password ||= io.password 'enter your master password: '
      end

      def master_password_confirmation
        @master_password_confirmation ||= io.password 're-enter your master password: '
      end

      def fail_cuz_your_master_password_confirmation_does_not_match
        io.failure "Your password confirmation does not match"
        self.exit_status = 1
      end

      def fail_cuz_your_master_password_is_wrong
        io.failure "incorrect master password"
        self.exit_status = 1
      end

      def name
        @name ||= io.ask "what is this a password for? "
      end

      def fail_cuz_invalid_name
        io.failure "invalid name"
        self.exit_status = 1
      end

      def login
        @login ||= io.ask "enter your login: "
      end

      def should_override_name?
        @override_name ||= io.boolean "#{name.inspect} is already being stored, override it? (y/N)",
            true: /^y/i,
            false: /^n/i,
            default: false
      end

      def fail_cuz_no_name_override
        self.exit_status = 0
      end

      def search_string(name)
        @search_string ||= io.ask "enter search words: " # to the user, we present them as search words
      end

      def fail_cuz_your_search_matched_multiples(matched_passwords)
        names = matched_passwords.map(&:name).map { |name| "'#{name}'" }.join(', ') # omg, just go add single/double quoted strings to haiti -.-
        io.failure "'#{words_searched_for.join(' ')}' matched: #{names}"
        self.exit_status = 1
      end

      def fail_cuz_your_search_has_no_matches
        io.failure "'#{words_searched_for.join(' ')}' matched nothing"
        self.exit_status = 1
      end

      def password(name)
        @password ||= io.password "enter the password for #{name}: "
      end

      def persist_encrypted_passwords(encrypted_file)
        File.open(password_filename, 'w') { |f| f.write encrypted_file }
      end

      def succeed(*args)
        self.exit_status = 0
        succeed_callback.call(*args)
        exit_status
      end

      def old_master_password
        @old_master_password ||= io.password 'enter your old passord: '
      end

      def new_master_password
        @new_master_password ||= io.password 'enter your new passord: '
      end

      def new_master_password_confirmation
        @new_master_password_confirmation ||= io.password 're-enter your master password: '
      end

      def fail_cuz_your_new_master_password_confirmation_does_not_match
        io.failure "Your password confirmation does not match"
        self.exit_status = 1
      end

      def list_passwords(passwords)
        return io.failure 'no passwords to list' if passwords.empty?
        name_size     = passwords.map(&:name).map(&:size).max
        login_size    = passwords.map(&:login).map(&:size).max
        format_string = "%#{name_size}s | %#{login_size}s | %s\n"

        io.tell format_string.gsub('%', '%-') % ['NAME', 'LOGIN', 'SEARCH WORDS']
        passwords.each do |password|
          io.tell format_string % [password.name, password.login, password.search_string]
        end
      end
    end
  end
end
