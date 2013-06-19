require 'twitter'
require 'CSV'

Twitter.configure do |config|
  config.consumer_key = "2V679I3ibUOUOMRaUBbAgw"
  config.consumer_secret = "cHpppblF9AWPQdJMIvTaBgnsivTYpnmwsbuUjg04F8"
  config.oauth_token = "21982035-rewL3I46Epje9S1lyBMuraiGi7Km6FpV41GymlfdY"
  config.oauth_token_secret = "cWACMscWhilSh7iyT8FHqkvkxzB01yDdCz7DC4b1M"
end

# tweet_array = Twitter.search("Hail damage").results

# puts "#{tweet_array.inspect}"

# tweets = tweet_array.map do |tweet|
#  	puts "#{tweet.inspect}: #{tweet.text}"
# end

# tweet_array = Twitter.search("Hail damage").results.map do |tweet|
# 	"#{tweet}"
# end

# # puts "#{tweet_array.inspect}"

#  CSV.open("tweets.csv","wb") do |csv|
#  	csv << 
#  end

 	CSV.open("tweets.csv","wb") do |csv|
 		csv << ["handle", "text", "url"]			
		Twitter.search("hail").results.map do |tweet|
			csv << [tweet.from_user, tweet.text,tweet.user.url]
		end
	end
