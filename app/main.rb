# frozen_string_literal: true

require 'sinatra'
require 'json'
require 'httparty'

get '/' do
  'Hello world!'
end

post '/trigger-unit-test' do
  payload = JSON.parse(request.body.read)
  project_id = payload['project']['id']
  gitlab_event = request.env['HTTP_X_GITLAB_EVENT']
  gitlab_token = request.env['HTTP_X_GITLAB_TOKEN']
  return [200, 'Token is required'] if [nil, ''].include?(gitlab_token)
  return [200, 'Event not matched'] unless gitlab_event == 'Push Hook'

  tokens = gitlab_token.split(';')
  return [200, 'Token not matched'] unless tokens[0] == ENV['TOKEN']

  res = HTTParty.post("https://git.kelvinchin.cc/api/v4/projects/#{project_id}/trigger/pipeline",
                      body: { ref: 'unit-test', token: tokens[1] }.to_json,
                      headers: { 'Content-Type' => 'application/json' })
  return [
    201,
    {
      'msg': 'ok',
      'service-response': JSON.parse(res.body),
      'service-status-code': res.code
    }.to_json
  ]
end
