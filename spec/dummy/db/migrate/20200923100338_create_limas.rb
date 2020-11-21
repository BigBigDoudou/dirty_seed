class CreateLimas < ActiveRecord::Migration[6.0]
  def change
    create_table :limas do |t|
      t.string :address
      t.string :city
      t.string :country
      t.string :description
      t.string :email
      t.string :first_name
      t.string :firstname
      t.string :last_name
      t.string :lastname
      t.string :lat
      t.string :latitute
      t.string :lng
      t.string :locale
      t.string :longitude
      t.string :middlename
      t.string :middle_name
      t.string :password
      t.string :phone
      t.string :phone_number
      t.string :reference
      t.string :title
      t.string :user_name
      t.string :username
      t.string :uuid

      t.timestamps
    end
  end
end
