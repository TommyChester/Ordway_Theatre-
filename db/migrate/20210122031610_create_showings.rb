class CreateShowings < ActiveRecord::Migration[6.1]
  def change
    create_table :showings do |t|
      t.string :name
      t.string :type_of_show
      t.json :body

      t.timestamps
    end
  end
end
