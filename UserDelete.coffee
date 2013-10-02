excel = require 'excel'
client = require 'restler'
require 'js-yaml'

token = process.env.APP47_API_TOKEN
excelFile = process.argv[2]

if !token or !excelFile
	throw new Error('You must provide an APP47_API_TOKEN API_TOKEN and pass in a path to an excel file')

baseURL = process.env.APP47_URL || 'http://localhost:3000'
httpHeader = {headers:{'X-Token':token, 'Accept':'application/json', 'Content-Type': 'application/json'}}

console.log "Communicating with #{baseURL} using #{token} as an API Token"

excel excelFile, (err, stuff) ->
	for row, index in stuff
		if index > 0
			email = row[1]
			client.get("#{baseURL}/api/users/email/#{email.replace('.', '%2E')}", httpHeader).on '2XX', (data, response) ->
				if data['_id']
					client.del("#{baseURL}/api/users/#{data['_id']}", httpHeader).on '2XX', (delData, delResponse) ->


