class SkillsController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :find_user, except: [:index]
  before_action :find_profile
  before_action :find_skill, only: [:edit, :update, :destroy]
  def new
    @skill = Skill.new
    respond_to do |format|
      format.html { render "skills/new" }
      format.js   { render "skills/create_success" }
    end
  end


  def create
    @skill = Skill.new skill_params
    @skill.profile = @profile
    if @skill.save
      redirect_to user_profile_path(@user, @profile),notice:  "New Skill Created!"
    else
      flash[:alert] = "Error. Skill not created!"
      redirect_to user_profile_path(@user, @profile)
    end
  end



  def index
    @skills = Skill.all
    respond_to do |format|
      format.html { render "skills/index"}
      format.js   { render "skills/display"}
    end
  end

  def edit
    redirect_to root_path, alert: "access defined" unless can? :edit, @profile
    respond_to do |format|
      format.html { render }
      format.js   { render :update_success }
    end
  end


  def update
    redirect_to root_path, alert: "access defined" unless can? :update, @profile
    if @skill.update skill_params
      redirect_to user_profile_path(@user, @profile)
    else
      render :edit
    end
  end

  def destroy
    redirect_to root_path, alert: "access defined" unless can? :destroy, @profile
    @skill.destroy
    redirect_to user_profile_path(@user,@profile)
  end


  private

  def skill_params
    skill_params = params.require(:skill).permit(:name, :rating)
  end

  def find_skill
    @skill = Skill.find params[:id]
  end

end
