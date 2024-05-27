class RenameIsAdminToIsSuperuserInUsers < ActiveRecord::Migration[7.0]
  def change
    rename_column :users, :is_admin, :is_superuser
  end
end
