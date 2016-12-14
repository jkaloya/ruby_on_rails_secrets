class SecretsController < ApplicationController
    before_action :require_login, only: [:index, :create, :destroy]
    def create
        @user = current_user
        @secret = @user.secrets.create( secrets_params )
        if @secret.save
            redirect_to "/users/#{@user.id}"
        else
            flash[:errors] = []
            flash[:errors] = @user.errors.full_messages
            redirect_to "/users/new"
        end
    end

    def index
        @secrets = Secret.all
        @likes = Like.all
    end

    def destroy
        secret = Secret.find( params[:id] )
        secret.destroy if secret.user == current_user
        redirect_to "/users/#{current_user.id}"
    end

    private
    def secrets_params
        params.require(:form).permit(:content, :user_id)
    end
end
