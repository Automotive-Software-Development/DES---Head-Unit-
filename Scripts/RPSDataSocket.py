import can
from pydbus import SessionBus
from gi.repository import GLib
import threading
import struct
import socket

# Create a CAN bus channel
can_bus = can.interface.Bus(interface='socketcan', channel='can1', bitrate=1000000)
loop = GLib.MainLoop()
class MyDBUSService:
    """
    <node>
        <interface name='com.example.dBus.rps'>
            <method name='RPS'>
                <arg type='s' name='response' direction='out'/>
            </method>
        </interface>
    </node>
    """
    def __init__(self):
        self.host = '0.0.0.0'  # Listen on all network interfaces
        self.port = 4000      # Arbitrary port number
        self.server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.server_socket.bind((self.host, self.port))
        self.server_socket.listen(1)
        print("Server is listening for incoming connections...")
        self.client_socket = None
        socket_thread = threading.Thread(target=self.start_server, name="socket_thread")
        socket_thread.start()
        
        self.rps = 0
        can_thread = threading.Thread(target=self.Receive_CAN_Message, name="can_thread")
        can_thread.start()

    def start_server(self):
        client_socket, client_address = self.server_socket.accept()
        print(f"Connection established with {client_address}")
        self.client_socket = client_socket
        
    def Receive_CAN_Message(self):
        while True:
            message = can_bus.recv()
            if message:
                print("CAN Message", message)
                print("converted value", struct.unpack('f', message.data)[0])
                self.rps = struct.unpack('f', message.data)[0]
    def RPS(self):
        print("RPS method: ", self.rps)
        if self.client_socket:
            self.client_socket.sendall(str(self.rps).encode())
        return str(self.rps)
        
bus = SessionBus()
bus.publish("com.example.dBus.rps", MyDBUSService())
loop.run()