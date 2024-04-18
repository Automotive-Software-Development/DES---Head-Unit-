import socket
from pydbus import SessionBus
from gi.repository import GLib
import threading

loop = GLib.MainLoop()

class AmbientLighting:
    """
    <node>
        <interface name='com.example.dBus.ambientlight'>
            <method name='getThemeColor'>
                <arg type='s' name='response' direction='out'/>
            </method>
            <method name='setThemeColor'>
                <arg type='s' name='themeColor' direction='in'/>
            </method>
        </interface>
    </node>
    """
    def __init__(self):
        print("Ambient Light Script started")
        self.themeColor = "#0000ff"
        self.host = '0.0.0.0'  # Listen on all network interfaces
        self.port = 8000      # Arbitrary port number
        self.server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.server_socket.bind((self.host, self.port))
        self.server_socket.listen(1)
        print("Server is listening for incoming connections...")
        self.client_socket = None

        socket_thread = threading.Thread(target=self.start_server, name="socket_thread")
        socket_thread.start()

    def _handle_connection(self, client_socket):
        while True:
            data = client_socket.recv(1024)
            if data:
                message = data.decode()
                if message == "GET_COLOR":
                    # If client requests current color, send it
                    client_socket.sendall(self.themeColor.encode())
                else:
                    # Otherwise, assume it's a new color and set it
                    print(f"Setting theme color to {message}")
                    self.setThemeColor(message)

    def start_server(self):
        client_socket, client_address = self.server_socket.accept()
        print(f"Connection established with {client_address}")
        self.client_socket = client_socket
        self._handle_connection(client_socket)
        client_socket.close()

    def getThemeColor(self):
        return self.themeColor

    def setThemeColor(self, color):
        print(f"Setting theme color to {color}")
        self.themeColor = color
        self.client_socket.sendall(color.encode())

bus = SessionBus()
bus.publish("com.example.dBus.ambientlight", AmbientLighting())
loop.run()