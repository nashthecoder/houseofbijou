class AddIdentityFieldsToSettings < ActiveRecord::Migration[8.1]
  def change
    add_column :settings, :pseudonym, :string
    add_column :settings, :avatar_color, :string, default: "#c29765"
    add_column :settings, :recovery_email, :string
    add_column :settings, :disguise_accent, :string
  end
end
