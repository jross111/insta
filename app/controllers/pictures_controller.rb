class PicturesController < ApplicationController
  before_action :require_login
  skip_before_action :require_login, only: [:index,:show]

 def index
   @pictures = Picture.hot_pics
 end

 def new
   @picture = Picture.new
 end

 def create
   @tags = params[:picture][:tags].split(',')
   @picture = Picture.new(picture_params)
   @picture.user_id = current_user.id
   @tags.each do |tags|
     tag = Tag.find_or_create_by(name: tags)
     @picture.tags << tag
   end
   if @picture.valid?
     @picture.save
     redirect_to picture_path(@picture)
   else
     flash[:notice] = "URL must be for GIF, JPG or PNG image."
     redirect_to new_picture_path
   end
 end

 def show

   @picture = Picture.find(params[:id])
   @comment = Comment.new
   @tag = Tag.new
   @picture_tag = PictureTag.create(tag_id: @tag.id, picture_id: @picture.id)
  #  byebug
 end

 def edit
   @picture = Picture.find(params[:id])
   if @picture.user.id != current_user.id
     redirect_to user_path(current_user)
   end
 end

 def update
   @picture = Picture.find(params[:id])
   @picture.update(picture_params)
   redirect_to picture_path(@picture.id)
 end


 def destroy
   @picture.delete
 end

 private

 def picture_params (*args)
   params.require(:picture).permit(:image_url, :title, :tag_ids => [])

 end

 def require_login
    return head(:forbidden) unless session.include? :user_id
  end

end
