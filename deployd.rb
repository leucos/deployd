#!/usr/bin/env ruby

require 'sinatra/base'
require 'git'
require 'json'

# Require keys config
require_relative 'config/keys.rb'

class Deployd < Sinatra::Base

  set :bind, '0.0.0.0'

  configure :production, :development do
    enable :logging
  end

  post '/deploy' do
    # send 412 Precondition Failed back if key not found
    if ! KEYS.include?(params[:api_key])
      logger.error "key #{params[:api_key]} not found"
      halt 412
    end

    # send 412 Precondition Failed back if pass iznogoud
    if KEYS[params[:api_key]][:secret] != params[:api_secret]
      logger.error "key #{params[:api_key]} found but password doesn't match"
      halt 412
    end

    logger.info "valid secret for key #{params[:api_key]} received"

    g = Git.open(KEYS[params[:api_key]][:working_dir], :log => logger)
    hook = JSON.parse request.env["rack.input"].read
    commit_tag = hook["after"]

    logger.info "resetting to HEAD"
    g.reset_hard

    logger.info "pulling in #{KEYS[params[:api_key]][:working_dir]}"
    g.pull

    logger.info "resetting to commit #{commit_tag}"
    commit = g.gcommit(commit_tag)
    g.reset_hard commit
  end

end


