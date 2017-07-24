class CreateReviews < ActiveRecord::Migration[5.1]
  def change
    create_table :reviews do |t|
      t.text :body
      t.references :idea, foreign_key: true, index: true
      t.timestamps
    end
  end
end
