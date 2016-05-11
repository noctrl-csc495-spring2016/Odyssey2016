class SessionsController < ApplicationController

def new
end

def create
  redirect_to '/pickups'
end

end