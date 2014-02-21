require 'actionpack/action_caching'

class CohortsController < ApplicationController

  caches_action :index, :cache_path => Proc.new{|c| {:num_weeks => params[:num_weeks]}}, :expires_in => 1.day


  def index
    @num_weeks = params[:num_weeks].nil? ? 8 : params[:num_weeks].to_i
    @cohort_report = CohortReport.new(Date.parse("2013/07/01"), @num_weeks)
  end

end