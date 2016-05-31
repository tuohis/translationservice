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
  @translations = Translation.select("translations.*, originals.text as original")
    .from("translations, translations as originals").where("translations.text_id = originals.text_id")
    .where("originals.language = 'en'")
  if params[:languages]
    @translations = @translations.where("translations.language = ?", params[:languages])
  end
  if params[:filter] == 'untranslated'
    @translations = @translations.where("translations.text LIKE originals.text")
  elsif params[:filter] == 'translated'
    @translations = @translations.where("translations.text NOT LIKE originals.text")
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
