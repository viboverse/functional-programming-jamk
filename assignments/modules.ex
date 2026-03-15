defmodule Employee do
  defstruct [
    firstname: "",
    lastname: "",
    id: 1,
    salary: 0,
    job: :none
  ]

  def create(firstname, lastname, prevId \\ 0) do
    %Employee{
      firstname: firstname,
      lastname: lastname,
      id: prevId + 1
    }
  end

  def promote(%Employee{job: :none} = emp),     do: %{emp | job: :coder, salary: 2000}
  def promote(%Employee{job: :coder} = emp),    do: %{emp | job: :designer, salary: 4000}
  def promote(%Employee{job: :designer} = emp), do: %{emp | job: :manager, salary: 6000}
  def promote(%Employee{job: :manager} = emp),  do: %{emp | job: :ceo, salary: 8000}
  def promote(%Employee{job: :ceo} = emp),      do: emp



  def demote(%Employee{job: :ceo} = emp),       do: %{emp | job: :manager, salary: 6000}
  def demote(%Employee{job: :manager} = emp),   do: %{emp | job: :designer, salary: 4000}
  def demote(%Employee{job: :designer} = emp),  do: %{emp | job: :coder, salary: 2000}
  def demote(%Employee{job: :coder} = emp),     do: %{emp | job: :none, salary: 0}
  def demote(%Employee{job: :none} = emp),      do: emp
end
