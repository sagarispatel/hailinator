require 'twitter'

Twitter.configure do |config|
  config.consumer_key = "2V679I3ibUOUOMRaUBbAgw"
  config.consumer_secret = "cHpppblF9AWPQdJMIvTaBgnsivTYpnmwsbuUjg04F8"
  config.oauth_token = "21982035-rewL3I46Epje9S1lyBMuraiGi7Km6FpV41GymlfdY"
  config.oauth_token_secret = "cWACMscWhilSh7iyT8FHqkvkxzB01yDdCz7DC4b1M"
end

tweet_array = Twitter.search("Hail damage").results

# puts "#{tweet_array.inspect}"

tweets = tweet_array.each do |tweet|
 	puts "#{tweet.inspect}: #{tweet.text}"
end

# puts "#{tweet_array.inspect}"
