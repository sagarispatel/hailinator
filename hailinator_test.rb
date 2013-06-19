def require filename
  response = super filename

  if defined?(Twitter) && !defined?(LOADED_TWITTER)
    Kernel.const_set(:LOADED_TWITTER, true)

    Twitter.module_eval do
      def self.search(*args)
        Kernel.const_set(:SEARCHED_TWITTER, true)

        super
      end
    end
  end

  response
end

def puts *args
  @inspected ||= args.any? do |arg|
    arg.inspect.include?('Twitter::Tweet')
  end

  super
end

at_exit do
  if @error_message
    e = @error_message
    puts "\n" * 4, "*" * 40, "\n" * 2
    puts "  ERROR TYPE: #{e.class.name}"
    puts "     MESSAGE: #{e.message}"
    puts "   FILE NAME: #{e.backtrace.first.split(':').first}"
    puts " LINE NUMBER: #{e.backtrace.first.split(':')[1]}"
    puts "\n" * 3
    puts [e.class.name, e.message, *e.backtrace].join "\n"
  end
end

# set_trace_func proc { |event, file, line, id, binding, classname|
#   if classname =~ /Module/
#     printf "%8s %s:%-2d %10s %8s\n", event, file, line, id, classname
#   end
# }

begin
  Dir['*.csv'].each do |file|
    File.delete(file)
  end

  puts "*" * 40
  puts "SCRIPT OUTPUT"
  puts "*" * 40

  load 'hailinator.rb'
rescue LoadError, Exception => e
  @error_message = e
ensure
  puts "\n" * 5, "*" * 40
  puts "//SCRIPT OUTPUT"
  puts "*" * 40, "\n" * 5
end


def step number
  total = 8

  puts "#" * (total + 2)
  puts ["[", "*" * number, " " * (total - number), "]"].join
  puts "STEP #{number} OF #{total}"
end

def twitter_gem_installed?
  @twitter_gem_response = require 'twitter'

  true
rescue LoadError
  false
end

def twitter_gem_loaded?
  # If require returns false, our script loaded it
  !@twitter_gem_response
end

def searching_twitter?
  defined?(SEARCHED_TWITTER)
end

def inspected_tweets?
  @inspected || csv_file_exists?
end

def csv_file_exists?
  Dir['*.csv'].any?
end

def csv_has_headers?
  Dir['*.csv'].any? do |file|
    File.read(file).include?('handle,text,url')
  end
end

def csv_has_rows?
  Dir['*.csv'].any? do |file|
    File.read(file).split("\n").length > 2
  end
end




unless File.exist?('hailinator.rb')
  puts <<-WELCOME

 __   __  _______  ___  d ___      ___   __    _  _______  _______  _______  ______
|  | |  ||   _   ||   | |   |    |   | |  |  | ||   _   ||       ||       ||    _ |
|  |_|  ||  |_|  ||   | |   |    |   | |   |_| ||  |_|  ||_     _||   _   ||   | ||
|       ||       ||   | |   |    |   | |       ||       |  |   |  |  | |  ||   |_||_
|       ||       ||   | |   |___ |   | |  _    ||       |  |   |  |  |_|  ||    __  |
|   _   ||   _   ||   | |       ||   | | | |   ||   _   |  |   |  |       ||   |  | |
|__| |__||__| |__||___| |_______||___| |_|  |__||__| |__|  |___|  |_______||___|  |_|


We're going to create a Ruby application!  Hailinator will:

* search Twitter for certain hashtags, like #hail and #damage,
* export the tweet details to a CSV file for our sales reps

The sales reps need leads for people who have likely suffered from hail damage,
because they can try to sell them on their bodyshop's repair services. Amazingly,
some sales reps will pay up to $10 per lead!  With just a few lines of code,
we'll be able to print some fun beer money.

This wizard will guide you through each step to build the working application.
Pass the current step to see the next step.

NOTE: If you break something, this wizard might jump back a few steps. That's OK,
just figure out what you broke and un-do it. You didn't lose any work.

READY?

To continue, create a file called 'hailinator.rb'.  Once you're done, please
run this script again.

IF YOU STILL SEE THE SAME MESSAGE, check:
* to be sure you named your file correctly
* that you created it in the same directory
* HINT: you can see all files in the directory by typing 'ls'


WELCOME

  # TODO:
  # Add levenshtein check for incorrect filenames


  exit
end



## STEP TWO

unless twitter_gem_installed?
    step 2

    puts <<-TWITTER

OK, we're going to search Twitter, right?  So we need a way to talk to Twitter.

Ruby has different "libraries" or "gems" that add on to Ruby's abilities.
There are gems for talking to Facebook, gems for creating Excel spreadsheets, gems for sending email, and tens of thousands of other things.

Let's add the gem for twitter.

Run: 'gem install twitter' in Terminal

TWITTER

    exit
end



unless twitter_gem_loaded?
    step 3

    puts <<-TWITTER

Cool, now we have the Twitter gem installed.  But our hailinator script doesn't know about it.

We have to ask Ruby to "require" it.  This is kinda like 'load', but pulls in a whole gem instead of
just a file. Also, the gem doesn't have to be in the current directory that our script is in.

It just needs to be installed on the machine.

  Add 'require "twitter"' to 'hailinator.rb'

TWITTER

    exit
end

Twitter.home_timeline rescue nil

unless Twitter.client?
  step 4

  puts <<-AUTHENTICATED

Awesome, we've loaded in the Twitter gem.  Next we need to authenticate with Twitter.

Follow the quick-start guide to get that going:
https://github.com/sferik/twitter#quick-start-guide

AUTHENTICATED

    exit
end



unless searching_twitter?
  step 5

  puts <<-AUTHENTICATED

Cool, we're authenticated!  Hello, Twitter.

** GRAB AN INSTRUCTOR and explain what you've done so far to them.

Then, now we need to search for those tweets!

The documentation should help you get started.

AUTHENTICATED

    exit
end


unless inspected_tweets?

  step 6

  puts <<-INSPECTED

Great, we're searching for stuff... Loop over the results and `puts` them to the screen.

Hint: `.inspect` is your friend

INSPECTED

  exit

end


unless csv_file_exists?
  step 7

puts <<-CSV
So we've done several things:
 * 'gem install twitter'
 * `require 'twitter'` in our script
 * Authenticated with Twitter
 * Searched for tweets

Alright, that's a lot of stuff going on.  We want to spit the tweets out into a CSV, though.

Google for how to generate a CSV file in Ruby.  To pass this step,
we should be creating a file with a ".csv" extension in this directory.


CSV

  exit

end


unless csv_has_headers?
  step 7

  puts <<-CSV

RIGHT ON! OK, we have a CSV file named '#{Dir['*.csv'].first}'.  Now we need some data in it.

Our client is using a propietary format and needs the file to be in this format EXACTLY:

handle,text,url

Let's add those as the CSV file headers.

HINT: run `cat {filename}.csv` to see what your actual file output is

CSV



  exit
end


unless csv_has_rows?
  step 8

  puts <<-CSV

Cool, we have our headers.  Let's display the tweet information on each row now.

CSV


  exit
end




puts "SHIP IT"
puts <<-SQUIRREL


                  SHIP IT



                           ..\|||||/',//
                        `\\`\           ///
                      `\`        |  /    '/'
                   -.`\      \        |   // //
                  _- -.   \    |         /   /.
                -                 |      /  .'.'
               -- - `.  \            /       .'.'
              -_  -  `  \   \     /    /   /  .'-'
             -_  _ -` |\      |        ' '  -'-''
             -___  '`/  `  \      /  /   _--   -'_
             _  _/ '`  \       |    /|       _ -
             _.__  / `.            //|  _ -   _ -_
             _   '| \._    \ __.--// |     -  __
            _-  '  `  \`.  .'    (/  | -  _    -
            ' '|  \    \ `'          |\   _  _-_
            '/          \ |      ` _   `.  _ _
             \ |   ` `  >/        '      `-.
            \|       .-' |_        db       `.
           \       .'    d|        MP         \       ___      _.-
          `  ` | .'      Vb         '   |'     \   .-'   `----'
        `\     .'  /      \         .-' |      _\.'
       \     .'            |       ---.___    .'       `
            /      -        \._mm) `-._ /   .'                 _.-
      `\   /       .         `"Y"       --.'         .--------'
     \\   /         `.    `-._____      .'        .-'
         /            \           `-.  /        .'
     )  /              '.           .-'       .'
     ` /              '  -._.-    .'        .'
    ) '                '      `..'        .'
    .                ' '  `   .'        .'`
   `                   '    .'        .'  `
   `                  ' '.-'        .'   `
   `               _   .'         .'  .`
    '              _`.'         .'  .`
     '.        .-'_ `_'       .'   `
       -      .' _  `_`    .-'  .`
       )          `-._`  .'    `
        '__   _.-_  `  .'   .`           VK
           '.'     `' /__. `
           /         /_.-'






SQUIRREL



