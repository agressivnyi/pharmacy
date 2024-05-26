class AddNewPreperateToProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :new_preperate, :boolean
    add_column :projects, :commercial_name, :string
    add_column :projects, :international_no_patent, :string
    add_column :projects, :chemical_name, :string
    add_column :projects, :type, :string
  end
end
