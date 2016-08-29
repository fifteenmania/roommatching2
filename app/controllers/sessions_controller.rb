class SessionsController < ApplicationController
    def sign_in
        user = User.where { |u| u.email == params[:email] }
        if user.empty?
            
        else
            
        end
        # if user && test_password(params[:password], user.password_hash)
        # session.clear
        # session[:user_id] = user.id
        # redirect '/'
        # else
        # @error = 'Username or password was incorrect'
        # erb :sign_in
        # end
    end
    
    def sign_out
       session.clear 
    end
    
    def create_user
        user = User.new
        user
        redirect '/' 
    end
end
