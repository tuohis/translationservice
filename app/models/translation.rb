class Translation < ActiveRecord::Base
  validates :text_id, presence: true
  validates :language, presence: true
  validates :text_id, uniqueness: { scope: [:text_id] }

  @@languages = ['en', 'fi', 'se', 'no', 'dk', 'ru', 'es', 'it', 'fr', 'fl', 'tur']
end
