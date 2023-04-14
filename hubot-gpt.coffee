axios = require('axios')

api_key = process.env.OPENAI_API_KEY

request_gpt = (chunk, api_key, model) ->
  new Promise (resolve, reject) ->
    uri = "https://api.openai.com/v1/chat/completions"

    headers =
      Authorization: "Bearer #{api_key}"
      'Content-Type': 'application/json'

    data =
      messages: [
        { role: 'system', content: "You are a helpful assistant" },
        { role: 'user', content: "Say something relevant in response to this:\n\n #{chunk}." }
      ]
      model: "gpt-3.5-turbo"
      temperature: 0.5
      max_tokens: 250

    axios.post(uri, data, {headers: headers})
      .then (response) ->
        resolve response.data.choices[0].message.content
      .catch (error) ->
        console.error error
        reject error

module.exports = (robot) ->
  robot.hear /hubot/i, (res) ->

    request_gpt(res.message.text)
      .then (response) ->
        res.send response
      .catch (error) ->
        res.send "Error: Unable to get a response from the API."
