class DropReaders < ActiveRecord::Migration
  def change
    drop_table :readers
  end
end
