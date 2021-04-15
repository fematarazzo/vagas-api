class CreateVagas < ActiveRecord::Migration[6.1]
  def change
    create_table :vagas do |t|
      t.string :título
      t.string :empresa
      t.string :nível
      t.text :descrição
      t.string :url
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
