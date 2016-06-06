require 'file_parser'
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
    @translations << @translation
  end
end

def is_number? string
  true if Float(string) rescue false
end

def show
  if is_number?(params[:id])
    show_by_id(params[:id])
  else
    show_by_text_id(params[:id])
  end
end

def show_by_id(id)
  #@translation = Translation.find(params[:id])
  @translation = Translation.select("translations.*, originals.text as original")
    .from("translations, translations as originals")
    .where("translations.id = #{id}")
    .where("translations.text_id = originals.text_id")
    .where("originals.language = 'en'")
    .first()
end

def show_by_text_id(id)
  @translations = Translation.select("translations.*, originals.text as original")
    .from("translations, translations as originals")
    .where("translations.text_id = '#{id}'")
    .where("translations.text_id = originals.text_id")
    .where("originals.language = 'en'")
  render "show_all_languages"
end

def edit
  @translation = Translation.find(params[:id])
  if @translation.text != params[:text]
    translationHistory = @translation.translation_histories.create({:text=>@translation.text})
    translationHistory.save!
    @translation.text = params[:text]
    @translation.save!
  end
  redirect_to @translation unless params[:api]
end

def index
  @translations = Translation.select("translations.*, originals.text as original")
    .from("translations, translations as originals").where("translations.text_id = originals.text_id")
    .where("originals.language = 'en'")
  if params[:languages]
    @translations = @translations.where("translations.language IN (?)", params[:languages])
  end
  if params[:filter] == 'untranslated'
    @translations = @translations.where("translations.text LIKE originals.text")
  elsif params[:filter] == 'translated'
    @translations = @translations.where("translations.text NOT LIKE originals.text")
  end
end

def import
  render 'import'
end

def upload_res_file
  uploaded_io = params[:res_file]
  file_type = params[:file_type]
  filename = uploaded_io.original_filename
  data = uploaded_io.read
  save_upload_to_file(data, filename)
  @translations = create_translations_from_upload(data, file_type)
  render 'index'
end

private
def save_upload_to_file(data, filename)
  target_dir = Rails.root.join('public', 'uploads')
  FileUtils.mkdir_p(target_dir) unless File.directory?(target_dir)
  File.open(timestamp_filename(target_dir.join(filename)), 'wb') do |file|
    file.write(data)
  end
end

def create_translations_from_upload(data, file_type)
  raise "Unknown file format" unless file_type == "res"
  translations = []
  parser = ::FileParser.new()
  parser.parse_each(data) do |t| 
    params[:translation] = t
    translation = Translation.new(translation_params)
    translation.save!
    translations << translation
  end
  translations
end

def timestamp_filename(file)
  dir  = File.dirname(file)
  base = File.basename(file, ".*")
  time = Time.now.strftime "%Y-%m-%d_%H%M%S"  # or format however you like
  ext  = File.extname(file)
  File.join(dir, "#{base}_#{time}#{ext}")
end

def all_languages
  params.require(:translation).permit(:all_languages)[:all_languages]
end

def translation_params
  params.require(:translation).permit(:text_id, :language, :text)
end
end
