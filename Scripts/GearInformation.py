from piracer.vehicles import PiRacerStandard
from piracer.gamepads import ShanWanGamepad
from pydbus import SessionBus
from gi.repository import GLib
import threading
import socket

loop = GLib.MainLoop()

class GearSelection:
    """
    <node>
        <interface name='com.example.dbus.gear'>
            <method name='Get_Gear_Information'>
                <arg type='s' name='gear_response' direction='out'/>
            </method>
            <method name='set_gear'>
                <arg type='s' name='gear' direction='in'/>
            </method>
            <method name='Get_Indicator_Information'>
                <arg type='s' name='indicator_response' direction='out'/>
            </method>
        </interface>
    </node>
    """
    def __init__(self):
        self.host = '0.0.0.0'  # Listen on all network interfaces
        self.port = 3000      # Arbitrary port number
        self.server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.server_socket.bind((self.host, self.port))
        self.server_socket.listen(1)
        print("Server is listening for incoming connections...")
        self.client_socket = None
        socket_thread = threading.Thread(target=self.start_server, name="socket_thread")
        socket_thread.start()
        
        # Gear related intialization
        self.throttle = -0.0
        self.steering = -0.0
        self.gear = "P"
        self.shanwan_gamepad = ShanWanGamepad()
        self.piracer = PiRacerStandard()
        gamepad_thread = threading.Thread(target=self.GamePad_Controller, name='gamepad_thread')
        gamepad_thread.start()
        
    def _handle_connection(self, client_socket):
        while True:
            data = client_socket.recv(1024)
            if data:
                message = data.decode()
                if "," in message:
                    method, argument = message.split(",", 1)
                if message == "GET_GEAR":
                    client_socket.sendall(self.gear.encode())
                elif method == "SET_GEAR":
                    print(argument, " from script")
                    self.set_gear(argument)

    def start_server(self):
        client_socket, client_address = self.server_socket.accept()
        print(f"Connection established with {client_address}")
        self.client_socket = client_socket
        self._handle_connection(client_socket)
        
    def GamePad_Controller(self):

        while True:
            gamepad_input = self.shanwan_gamepad.read_data()

            self.throttle = gamepad_input.analog_stick_right.y * 0.5
            self.steering = -gamepad_input.analog_stick_left.x

            print(self.gear)
            print(f'throttle={self.throttle}, steering={self.steering}')
            
            if self.gear == 'P':
                self.piracer.set_throttle_percent(-0.0)
                self.piracer.set_steering_percent(-0.0)
            elif self.gear == 'R':
                if -0.0 < self.throttle <= 0.5:
                    self.piracer.set_throttle_percent(self.throttle)
                else:
                    self.piracer.set_throttle_percent(-0.0)
                self.piracer.set_steering_percent(self.steering)
            elif self.gear == 'N':
                self.piracer.set_throttle_percent(-0.0)
                self.piracer.set_steering_percent(self.steering)
            elif self.gear == 'D':
                if -0.5 <= self.throttle < -0.0:
                    self.piracer.set_throttle_percent(self.throttle)
                else:
                    self.piracer.set_throttle_percent(-0.0)
                self.piracer.set_steering_percent(self.steering)
    
    def set_gear(self, gear):
        self.gear = gear
        if self.client_socket:
            self.client_socket.sendall(gear.encode())
            
    def Get_Gear_Information(self):
        # if -0.0 < self.throttle <= 0.5:
        #     return "R"
        
        # elif -0.5 <= self.throttle < -0.0:
        #     return "D"
        
        # elif self.throttle == -0.0:
        #     return "N"
        
        # elif self.throttle == -0.0 and self.steering == -0.0:
        #     return "P"
        # else:
        #     print("No Gear Found")
        #     return ""
        return self.gear
        
    def Get_Indicator_Information(self):
        if -0.0 < self.steering <= 1.0:
            print("Left")
            return "L"
        elif -1.0 <= self.steering < -0.0:
            print("Right")
            return "R"
        else:
            print("No Indicator")
            return ""
        
bus = SessionBus()
bus.publish("com.example.dbus.gear", GearSelection())
loop.run()