class UsersController < ApplicationController
    def main
        if params[:token].nil?
            current_user = nil
        else
            current_user = User.find_user_with_token(params[:token])
        end
        
        if current_user.nil?
            is_login = true
            stage = nil
            token = nil
        else
            is_login = false
            stage = current_user.stage
            token = current_user.token
        end
    end
    
    def sign_in
        
    end
    
    private
        def facebook_params
           params.permit(:email, :gender, :image) 
        end
end
