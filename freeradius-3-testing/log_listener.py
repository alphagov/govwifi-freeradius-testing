#!/usr/bin/env python3

from http.server import BaseHTTPRequestHandler, HTTPServer
import json

HOST_NAME = "localhost"
PORT = 80


def print_request_data(data_string):
    print('*'*60)
    print('Data String: {}'.format(data_string.decode('utf-8')))
    print('Data JSON: {}'.format(json.loads(data_string)))


class RestReceiver(BaseHTTPRequestHandler):
    def do_POST(self):
        try:
            data_string = self.rfile.read(int(self.headers['Content-Length']))
            print_request_data(data_string)
            self.send_response(200)
            self.end_headers()      
        except Exception as e:
            print(e)
            self.send_response(500)
            self.end_headers()


if __name__ == "__main__":        
    webServer = HTTPServer((HOST_NAME, PORT), RestReceiver)
    print('Server started http://{0}:{1}'.format(HOST_NAME, PORT))

    try:
        webServer.serve_forever()
    except:
        pass

    webServer.server_close()
    print('\nServer stopped.')

