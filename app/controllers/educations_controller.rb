class EducationsController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :find_user, except: [:index]
  before_action :find_profile, except: [:index]
  before_action :find_education, only: [:edit, :update, :destroy]

  def index
    @educations = Education.all
  end

  def new
    @education = Education.new
  end

  def create
    @education = Education.new education_params
    @education.profile = @profile
    if @education.save
      redirect_to user_profile_path(@user, @profile), notice: "New education added!"
    else
      flash[:alert] = "Education could not be added"
      render :new
    end
  end

  def edit
    redirect_to root_path, alert: "access defined" unless can? :edit, @profile
  end

  def update
    redirect_to root_path, alert: "access defined" unless can? :update, @profile
    if @education.update education_params
      redirect_to user_profile_path(@user, @profile), notice: "New education updated!"
    else
      flash[:alert] = "Education not updated"
      render :edit
    end
  end

  def destroy
    redirect_to root_path, alert: "access defined" unless can? :destroy, @profile
    @education.destroy
    redirect_to user_profile_path(@user, @profile), notice: "Education deleted"
  end

  private

  def education_params
    params.require(:education).permit(:school, :major, :description, :start, :end)
  end

  def find_education
    @education = Education.find(params[:id])
  end
end
