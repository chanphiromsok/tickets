
#### A message is Ready when it is waiting to be processed.
When a consumer connects to the queue it gets a batch of messages to process. The amount is given in the prefetch size. While this consumer is working on the messages they get the status unacked.

Unacked means that the consumer has promised to process them but has not acknowledged that they are processed. When the consumer crashed the queue knows which messages are to be delivered again when the consumer comes online. When you have multiple consumers the messages are distributed among them.
