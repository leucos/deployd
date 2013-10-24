#!/usr/bin/env ruby

require 'sinatra/base'
require 'git'
require 'json'
require 'fileutils'

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

    # retrieve branch
    hook = JSON.parse request.env["rack.input"].read
    branch = hook["ref"].split("/",3)[2]

    # send 412 Precondition Failed back if pass iznogoud
    if ! KEYS[params[:api_key]][:branches].has_key?(branch)
      logger.error "directory for branch #{branch} not found"
      halt 412
    end

    path = File.expand_path(KEYS[params[:api_key]][:branches][branch])
    repos = hook["repository"]["name"]

    logger.info "checking directory #{path}"
    if Dir.exists?(path)
      g = Git.open(File.expand_path(path + "/" + repos),
                   :log => logger)
    else
      if ! Dir.exists?(path)
        logger.info "creating directory #{path}"
        FileUtils.mkdir_p(path)
      end
      logger.info "cloning #{hook["repository"]["url"]} in #{path}"
      g = Git.clone(hook["repository"]["url"], repos, :path => path)
    end

    commit_tag = hook["after"]

    logger.info "resetting to HEAD"
    g.reset_hard

    logger.info "pulling in #{KEYS[params[:api_key]][:deploy_dir]}"
    g.pull

    logger.info "resetting to commit #{commit_tag}"
    commit = g.gcommit(commit_tag)
    g.reset_hard commit
  end

end


