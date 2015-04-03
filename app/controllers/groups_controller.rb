class GroupsController < ApplicationController
  def show
  	@group = Group.find params[:id]
  end

  def index
  	@groups = Group.all
 	end

  def new
  	@group = Group.new
  end

 	def create
    @group = Group.new(name: params[:group][:name])
    if @group.save
      redirect_to(group_path(@group))
    else
      render 'new'
    end
  end

  def edit
    @group = Group.find params[:id]
  end

  def update
    @group = Group.find params[:id]
    if @group.update_attributes(params.require(:group).permit(:name))
      redirect_to(group_path(@group))
    else
      render 'edit'
    end
  end

  def destroy
    Group.find(params[:id]).destroy
    redirect_to action: 'index'
  end
end
