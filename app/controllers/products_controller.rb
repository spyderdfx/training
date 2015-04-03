class ProductsController < ApplicationController
  def show
  	@group = Group.find_by id: params[:group_id]
  	@product = Product.find_by id: params[:id], group_id: params[:group_id]
  end

  def index
  	@group = Group.find params[:group_id]
  	@products = Product.where group_id: params[:group_id]
 	end

  def new
  	@group = Group.find params[:group_id]
  	@product = Product.new(group_id: @group.id)
  end

 	def create
    @product = Product.new(name: params[:product][:name], group_id: params[:group_id])
    if @product.save
      redirect_to(group_product_path(@product.group_id, @product))
    else
      render 'new'
    end
  end

  def edit
  	@group = Group.find params[:group_id]
  	@product = Product.find params[:id]
  end

  def update
  	@product = Product.find params[:id]
  	if @product.update_attributes(params.require(:product).permit(:name, :group_id))
      redirect_to(group_product_path(@product.group_id, @product))
    else
      render 'edit'
    end
  end

  def destroy
  	Product.find(params[:id]).destroy
  	redirect_to action: 'index'
  end
end
