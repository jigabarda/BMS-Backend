class RenamePushTokenToToken < ActiveRecord::Migration[7.1]
def change
  rename_column :devices, :push_token, :token
end

end
