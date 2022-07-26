send_messages = fn num_messages ->
  {:ok,conn}= AMQP.Connection.open();
  {:ok,channel}= AMQP.Channel.open(conn);

  Enum.each(1..num_messages,fn _ ->
    event = Enum.random(["cenima","musical","play"]);
    user_id = Enum.random(1..3);
    AMQP.Basic.publish(channel,"","booking_queue","#{event},#{user_id}")
  end)
  AMQP.Connection.close(conn)
end
