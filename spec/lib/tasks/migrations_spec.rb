#   Copyright (c) 2010, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

require 'spec_helper'
require File.join(Rails.root, 'lib/hcard')

describe 'migrations' do


  describe 'service_reclassify' do
    it 'makes classless servcices have class' do
      s1 = Service.new(:access_token => "foo", :access_secret => "barbar", :provider => "facebook")
      s2 = Service.new(:access_token => "foo", :access_secret => "barbar", :provider => "twitter")
      s1.save
      s2.save

      require "rake"
      @rake = Rake::Application.new
      Rake.application = @rake
      Rake.application.rake_require "lib/tasks/migrations"
      Rake::Task.define_task(:environment)
      @rake['migrations:service_reclassify'].invoke   

      Service.all.any?{|x| x.class.name == "Services::Twitter"}.should be true
      Service.all.any?{|x| x.class.name == "Services::Facebook"}.should be true
    end
  end
end

