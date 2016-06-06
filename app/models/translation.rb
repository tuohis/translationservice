class Translation < ActiveRecord::Base
  def self.languages
    ['en', 'fi', 'se', 'no', 'dk', 'fl', 'fr', 'es', 'est', 'lat', 'lit', 'rus', 'it', 'cze', 'pol', 'prt', 'tur']
  end
  validates :text_id, length: {minimum: 5,
    message: "Text id must be at least 5 characters long" }
  validates :language, inclusion: { in: Translation.languages,
    message: "Language '%{value}' not recognized" }
  validates :text_id, uniqueness: { scope: :language,
    message: "The entry %{value} already exists for given language" }
  has_many :translation_histories

  def original
    begin
      Translation.select("text").from("translations").where("text_id = '#{text_id}'").where("language = 'en'").first()["text"]
    rescue
      "N/A"
    end
  end
end
