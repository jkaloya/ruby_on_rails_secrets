class UsersController < ApplicationController
    before_action :require_login, except: [:new, :create]
    before_action :require_correct_user, only: [:show, :edit, :update, :destroy]
    def new
        render "/users/new"
    end

    def create
        if params[:user][:password].to_s == params[:user][:password_confirmation].to_s
            @user = User.new( user_params )
            if @user.save
                session[:user_id] = @user.id
                redirect_to "/users/#{@user.id}"
            else
                flash[:errors] = []
                flash[:errors] = @user.errors.full_messages
                redirect_to "/users/new"
            end
        end
    end

    def show
        @user = User.find( params[:id] )
        @secrets = @user.secrets
        @secrets_liked = @user.secrets_liked
        #The following might work: Secret.where(user_id: session[:user_id])
    end

    def edit
        @user = User.find( params[:id] )
    end

    def destroy
        user = User.find( params[:id] )
        user.destroy!
        session[:user_id] = nil
        redirect_to "/sessions/new"
    end

    def update
        @user = User.find( params[:id] )
        @user.update(name: user_params[:name], email: user_params[:email])
        if @user.update(name: user_params[:name], email: user_params[:email])
            redirect_to "/users/#{@user.id}"
        else
            flash[:errors] = []
            flash[:errors] = @user.errors.full_messages
            redirect_to "/users/#{@user.id}/edit"
        end
    end

    private
    def user_params
        params.require(:user).permit(:email, :name, :password)
    end

end
