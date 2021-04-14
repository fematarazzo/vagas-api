class AddLocalToVagas < ActiveRecord::Migration[6.1]
  def change
    add_column :vagas, :local, :string
  end
end
