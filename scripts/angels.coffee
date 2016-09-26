# Description:
#   Mobility Angels project
#
# Dependencies:
#
# Commands:
#   start - initiate a conversation

module.exports = (robot) ->

	stage = 0

	robot.respond /(.*)/i, (res) ->
		query = res.match[1]
		if stage is 0
			res.send "Hi! I'm your mobile angel - I'll help you with your journey today! To start, I need you to tell me which station you are at right now."
			stage = 1
		else if stage is 1
			res.send "You are in #{query}. That's nice. Now, please tell me where you are going."
			stage = 2
		else if stage is 2
			res.send "OK, you are going to #{query}. Your next connection is in (24 minutes). Please tell me when you have boarded the train."
			stage = 3
		else if stage is 3
			res.send "Great! Your train will arrive in (50 minutes). I will be in touch 10 minutes before you arrive. Enjoy the trip :)"
			stage = 4
			# handleArrival = (tes) ->
			# 	res.send "You are about to arrive. Your connection is on (platform 3)"
			# setTimeout handleArrival, 5000


	# stage 3: final destination
	# robot.respond /arrival/i, (res) ->
	# 	res.send "You are about to reach Zürich: you will have 12 minutes to board your train."
	# use case: person is lost
	# robot.respond /help, I'm lost!/i, (res) ->
	# 	res.send "don't worry, I can help. Is it okay for me to try to determine your location?"
	# robot.respond /lost at (.*)/i, (res) ->
	# 	res.send "the information desk is on top floor, room 3"
