emp1 = Employee.create("Vahab", "Afsharian", 0)

IO.inspect(emp1)

# Promote
IO.puts("----promoting----")
emp1 = Employee.promote(emp1)
emp1 = Employee.promote(emp1)
IO.inspect(emp1)

# Demote
IO.puts("----Demoting----")
emp1 = Employee.demote(emp1)
IO.inspect(emp1)
