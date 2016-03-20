class CreateTranslations < ActiveRecord::Migration
  def change
    create_table :translations do |t|
      t.string :text_id
      t.string :language
      t.text :text

      t.timestamps null: false
    end
  end
end
