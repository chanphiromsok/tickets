defmodule BookingPipeline do
  use Broadway
  @producer BroadwayRabbitMQ.Producer
  @producer_config [
    queue: "booking_queue",
    declare: [durable: true],
    on_failure: :reject_and_requeue
  ]

  def start_link(_args) do
    options = [
      name: BookingPipeline,
      producer: [
        module: {@producer, @producer_config}
      ],
      processors: [
        default: []
      ],
      batchers: [
        cenima: [batch_size: 75],
        # musical default batch_size 100
        musical: [],
        default: [batch_size: 50]
      ]
    ]

    Broadway.start_link(__MODULE__, options)
  end

  @impl true
  def prepare_messages(messages, _context) do
    messages =
      Enum.map(messages, fn message ->
        Broadway.Message.update_data(message, fn data ->
          [event, user_id] = String.split(data, ",")
          %{event: event, user_id: user_id}
        end)
      end)

    users = Tickets.user_by_id(Enum.map(messages, & &1.data.user_id))

    Enum.map(messages, fn message ->
      Broadway.Message.update_data(message, fn data ->
        user = Enum.find(users, &(&1.id == data.user_id))
        Map.put(data, :user, user)
      end)
    end)
  end

  @impl true
  def handle_message(_processor, message = %Broadway.Message{}, _context) do
    %{data: %{event: event}} = message

    IO.inspect(message)
    if Tickets.ticket_available?(event) do
      case message do
        %{data: %{event: "cenima"}} = message ->
          Broadway.Message.put_batcher(message, :cenima)

        %{data: %{event: "musical"}} = message ->
          Broadway.Message.put_batcher(message, :musical)

        message ->
          message
      end
    else
      Broadway.Message.failed(message, "booking-closed")
    end
  end

  @impl true
  def handle_failed(messages, _context) do
    IO.inspect(messages, label: "Failed Message")

    Enum.map(messages, fn
      %{status: {:failed, "booking-closed"}} = msg ->
        Broadway.Message.configure_ack(msg, on_failure: :reject)

      msg ->
        msg
    end)
  end

  # @impl true
  # def handle_batch(:cenima, messages, batch_info, _context) do
  # end

  @impl true
  def handle_batch(_batcher, messages, batch_info, _context) do
    IO.puts("#{inspect(self())} Batch #{batch_info.batcher} #{batch_info.batch_key}")

    messages
    |> Tickets.insert_all_tickets()
    |> Enum.each(fn message ->
      channel = message.metadata.amqp_channel
      payload = "email,#{message.data.user.email}"
      AMQP.Basic.publish(channel, "", "notification_queue", payload)
    end)

    messages
  end
end
