class TranslationsController < ApplicationController

def new
end

def create
  if all_languages
    @translations = []
    Translation.languages.each do |l|
      creation_params = translation_params
      creation_params[:language] = l
      @translation = Translation.new(creation_params)
      @translation.save!
      @translations << @translation
    end
  else
    @translation = Translation.new(translation_params)
    @translation.save!
    @translations = [@translation]
  end
end

def show
  @translation = Translation.find(params[:id])
end

def edit
  @translation = Translation.find(params[:id])
  #@translation = Translation.where(:text_id => params[:text_id]).where(:language => params[:language]).first
  @translation.text = params[:text]
  @translation.save
  redirect_to @translation unless params[:api]
end

def index
  if params[:languages]
    @translations = Translation.select("translations.*, originals.text as original")
      .from("translations, translations as originals").where("translations.text_id = originals.text_id")
      .where("originals.language = 'en'")
      .where("translations.language = ?", params[:languages])
    #@originals = Translation.where(:language => 'en')
    #@translations = Translation.where(:language => params[:languages])
    #@translations.each do |t|
    #  t.original = @originals.where(:text_id => t.text_id).first().text
    #end
  else
    @translations = Translation.all
  end
end

private
def all_languages
  params.require(:translation).permit(:all_languages)[:all_languages]
end

def translation_params
  params.require(:translation).permit(:text_id, :language, :text)
end
end
