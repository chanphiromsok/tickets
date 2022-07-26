defmodule Tickets do
  @user [
    %{id: "1", email: "foo@gmail.com"},
    %{id: "2", email: "bar@gmail.com"},
    %{id: "3", email: "baz@gmail.com"}
  ]

  def user_by_id(ids) when is_list(ids) do
    Enum.filter(@user, &(&1.id in ids))
  end

  # def ticket_available?("cenima") do
  #   Process.sleep(Enum.random(100..200))
  #   false
  # end

  def ticket_available?(_event) do
    Process.sleep(Enum.random(100..200))
    true
  end

  def crate_ticket(_user, _event) do
    Process.sleep(Enum.random(250..1000))
  end

  def send_email(_user) do
    Process.sleep(Enum.random(100..250))
  end

  def insert_all_tickets(messages) do
    # If using ecto Repo.insert_all/3
    Process.sleep(Enum.count(messages)*250)
    messages
  end
end
