class Translation < ActiveRecord::Base
  def self.languages
    ['en', 'fi', 'se', 'no', 'dk', 'ru', 'es', 'it', 'fr', 'fl', 'tur']
  end
  validates :text_id, length: {minimum: 5,
    message: "Text id must be at least 5 characters long" }
  validates :language, inclusion: { in: Translation.languages,
    message: "Language '%{value}' not recognized" }
  validates :text_id, uniqueness: { scope: :language,
    message: "The entry %{value} already exists for given language" }


end
