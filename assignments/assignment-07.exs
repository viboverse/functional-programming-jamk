defmodule Dealer do
  # 1. Start the dealer process
  def start do
    spawn(fn -> loop() end)
  end

  # 2. Dealer just sits and waits for one of two commands
  defp loop do
    receive do
      # Hit
      {:hit, player_pid} ->
        send(player_pid, {:card, Enum.random(2..11)})
        loop()

      # Stand
      {:dealer_turn, player_pid} ->
        # Calculate dealer score (draws cards until >= 17)
        dealer_score = play_dealer_turn(0)

        # Send final score back
        send(player_pid, {:result, dealer_score})
        loop()
    end
  end

  # Simple loop for the dealer to quickly draw cards until 17
  defp play_dealer_turn(score) do
    if score < 17 do
      play_dealer_turn(score + Enum.random(2..11))
    else
      score
    end
  end
end

defmodule Player do
  def play do
    dealer_pid = Dealer.start()
    game_loop(dealer_pid, 0)
  end

  # Main game loop
  defp game_loop(dealer_pid, score) do
    if score == 0, do: IO.puts("\n=== NEW GAME ===")

    input = IO.gets("Your score is #{score}. Hit (h) or Stand (s)? ") |> String.trim()

    if input == "h" do
      # Send a message to get a card
      send(dealer_pid, {:hit, self()})

      # Wait for the card
      receive do
        {:card, card} ->
          new_score = score + card
          IO.puts("You drew a #{card}.")

          if new_score > 21 do
            IO.puts("Score: #{new_score}. You lose.")
            ask_replay(dealer_pid)
          else
            game_loop(dealer_pid, new_score)
          end
      end
    else
      # Stand - tell the dealer to go
      send(dealer_pid, {:dealer_turn, self()})

      receive do
        {:result, dealer_score} ->
          IO.puts("Dealer ended with #{dealer_score}.")

          # Simple check who won
          if dealer_score > 21 or score > dealer_score do
            IO.puts("YOU WIN!")
          else
            IO.puts("YOU LOSE!")
          end

          ask_replay(dealer_pid)
      end
    end
  end

  # Ask to play again
  defp ask_replay(dealer_pid) do
    ans = IO.gets("Play again? (y/n): ") |> String.trim()
    if ans == "y" do
      game_loop(dealer_pid, 0) # Restart game loop with 0 score
    else
      IO.puts("Bye!")
    end
  end
end

Player.play()
