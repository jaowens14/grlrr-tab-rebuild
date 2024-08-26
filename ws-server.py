import asyncio
from websockets.server import serve
import random
import json
dist = 0
async def run_websocket_server():
    async with serve(connection_handler, "0.0.0.0", 5000):
        await asyncio.Future() # runs server forever

async def connection_handler(websocket):

    await asyncio.gather(
        consumer_handler(websocket),
        producer_handler(websocket),
    )

# receive the messages 
async def consumer_handler(websocket):
    async for message in websocket:
        await consumer(message)

# receive messages store them.
async def consumer(packet):
    print(packet)
    await asyncio.sleep(0.01)


# send the messages
async def producer_handler(websocket):
    while True:
        message = await producer()
        await websocket.send(str(message))


async def producer():
    global dist
    dist = round(dist + 0.1, 4)
    await asyncio.sleep(1)
    data = {'ut' : float(random.randint(0, 100)),
            'dist' : dist,
            'status' : "running"}
    data_packet = json.dumps(data)
    return data_packet


asyncio.run(run_websocket_server())





