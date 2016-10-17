Sequel.migration do
  up do
    create_table(:users) do
      primary_key :id

      String :email
      String :password
      String :firstname
      String :lastname
      Integer :perm
      Date :coach_date
      Time :coach_time
    end
  end

  down do
    drop_table(:users)
  end
end