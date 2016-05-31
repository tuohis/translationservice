class CreateTranslationHistories < ActiveRecord::Migration
  def change
    create_table :translation_histories do |t|
      t.references :translation, index: true, foreign_key: true
      t.string :text
      t.datetime :created_at

      t.timestamps null: false
    end
  end
end
