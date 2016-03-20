class TranslationsController < ApplicationController

def new
end

def create
  @translation = Translation.new(translation_params)
  @translation.save
  redirect_to @translation
end

def show
  @translation = Translation.find(params[:id])
end

def index
  @translations = Translation.all
end

private
def translation_params
  params.require(:translation).permit(:text_id, :language, :text)
end
end
