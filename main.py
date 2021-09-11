from flask import *
from flask  import Flask, app, jsonify
import sys
from datetime import datetime 
import subprocess as sp

x = datetime.now().time().strftime("%H:%M:%S") # time object
y = datetime.now().strftime("%Y-%m-%d") # date object
z= sp.getoutput("wget -q -O - http://169.254.169.254/latest/meta-data/instance-id")



app=Flask(__name__)



@app.route('/', methods=['GET'])
def getm():
   return('Hello World')

@app.route('/healthz', methods=['GET'])
def health():
   response = Response(status=200)
   return response


@app.route('/datetime')
def datetime():
    #now = datetime.datetime.now().time().strftime("%H:%M:%S") # time object
    #date = datetime.datetime.now().strftime("%Y-%m-%d") # date object
    print("date:",y)
    print("time :", x)
    print("InstanceId :",z)
    #print ("id",z)

    myDict={'Date': y, 'Time': x , 'InstanceId':z}
    return jsonify(myDict)
    

if __name__ == '__main__':
    app.run(host="0.0.0.0")