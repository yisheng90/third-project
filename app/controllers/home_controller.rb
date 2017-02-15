class HomeController < ApplicationController
  def index
    @freelancers = Freelancer.all
  end
end
