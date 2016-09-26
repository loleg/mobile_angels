# Description:
#   Mobility Angels project
#
# Dependencies:
#
# Commands:
#   start - initiate a conversation

request = require 'request'
moment = require 'moment'

# Convenience function for setting timeouts
delay = (ms, func) -> setTimeout func, ms

# Convert a JavaScript object into a Web Service query
httpBuildQuery = (params) ->
  if typeof params == 'undefined' or typeof params != 'object'
    params = {}
    return params
  query = '?'
  index = 0
  for i of params
    index++
    param = i
    value = params[i]
    if index == 1
      query += param + '=' + value
    else
      query += '&' + param + '=' + value
  query

# Main bot code
module.exports = (robot) ->

	stage = 0
	q_from = ''
	q_to = ''
	target_cxn = null
	depart_cxn = null

	# Listen to any command
	robot.respond /(.*)/i, (res) ->
		query = res.match[1]
		if stage is 0
			res.send "Hi! I'm your mobile angel - I'll help you with your journey today! To start, I need you to tell me which station you are at right now."
			stage = 1
		else if stage is 1
			q_from = query
			res.send "Now, please tell me where you are going."
			stage = 2
		else if stage is 2
			q_to = query
			apiquery = {
				'from': q_from,
				'to': q_to,
				'page': 0,
				'limit': 1,
				'date': moment().format("YYYY-MM-DD"),
				'time': moment().format("HH:mm")
			}
			res.send "Looking up connections from #{q_from} to #{q_to}..."
			# res.send 'http://transport.opendata.ch/v1/connections' + httpBuildQuery(apiquery)
			request.get { uri:'http://transport.opendata.ch/v1/connections' + httpBuildQuery(apiquery), json : true }, (err, r, body) ->
				# res.send JSON.stringify(body)
				depart_cxn = body.connections[0].from
				target_cxn = body.connections[0].to
				c_to = body.to.name
				c_from = body.from.name
				# res.send "Looks like you are going from #{c_from} to #{c_to}."
				c_depart = moment(depart_cxn.departure).fromNow()
				c_platform = depart_cxn.platform
				res.send "OK, your next connection to #{c_to} is #{c_depart} on platform #{c_platform}."
				delay 3000, ->
					res.send "Please let me know when you have boarded the train."
					stage = 3
		else if stage is 3
			c_arrive = moment(target_cxn.arrival).fromNow()
			res.send "Great! Your train will arrive in #{c_arrive}. I will be in touch 10 minutes before you arrive. Enjoy the trip :)"
			stage = 4
			delay 10000, ->
				res.send "You are about to arrive! Don't forget all your bags."

	# stage 3: final destination
	# robot.respond /arrival/i, (res) ->
	# 	res.send "You are about to reach Zürich: you will have 12 minutes to board your train."
	# use case: person is lost
	# robot.respond /help, I'm lost!/i, (res) ->
	# 	res.send "don't worry, I can help. Is it okay for me to try to determine your location?"
	# robot.respond /lost at (.*)/i, (res) ->
	# 	res.send "the information desk is on top floor, room 3"
