class AddInstructionsToCocktails < ActiveRecord::Migration[5.0]
  def change
    add_column :cocktails, :instructions, :text
  end
end
