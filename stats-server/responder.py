from flask import Flask,request
import logging

app = Flask("Usage")
@app.route('/ping',methods=['POST'])
def ping():
    app.logger.warning( f"Get usage :{dict(request.form)}")
    return {'status':'ok'},200, {'Content-Type': 'application/json'}


if __name__ == '__main__':
    app.run()
