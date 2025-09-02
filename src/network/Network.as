package network {

import com.jpauclair.Base64;

import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.geom.ColorTransform;
import flash.net.Socket;
import flash.utils.ByteArray;
import flash.utils.getTimer;
import flash.utils.setTimeout;

import game.config.ConfigurationData;

import network.data.Room;

public class Network {

    private var _game:Game;
    private var _handler:RequestHandler;
    private var _socket:Socket;
    private var _myUserId:Number = -1;
    private var _myUserName:String = "";
    private var _room:Room;
    private var _byteArray:ByteArray;
    private var _startTime:int;

    private var sendQueue:Array = [];
    private var isSending:Boolean = false;

    public function Network(game:Game)
    {
        _game = game;
        _handler = new RequestHandler(game);
        _socket = new Socket();
        _byteArray = new ByteArray();

        listeners();
    }

    public function get myUserId(): Number
    {
        return _myUserId;
    }

    public function set myUserId(newId:Number): void
    {
        _myUserId = newId;
    }

    public function get myUserName(): String
    {
        return _myUserName;
    }

    public function set myUserName(newName:String): void
    {
        _myUserName = newName;
    }

    public function get room(): Room
    {
        return _room;
    }

    public function set room(newRoom:Room): void
    {
        _room = newRoom;
    }

    public function get byteArray(): ByteArray
    {
        return _byteArray;
    }

    public function set byteArray(newByteArray:ByteArray): void
    {
        _byteArray = newByteArray;
    }

    public function connect(ip:String, port:int): void
    {
        _socket.connect(ip, port);
    }

    public function get isConnected(): Boolean
    {
        return _socket.connected;
    }

    public function close(): void
    {
        if (_socket.connected) {
            _socket.close();
        }
    }

    public function send(cmd: String, param2: Array): void
    {
        sendQueue.push(Base64.encode(
                JSON.stringify(
                        {
                            type: "request",
                            body: {
                                cmd:cmd,
                                args:param2
                            },
                            timeStamp: new Date().toString()
                        }
                )
        ));

        processQueueWriteToSocket();
    }

    public function sendEvent(cmd:String, ... args): void
    {
        sendQueue.push(Base64.encode(
                JSON.stringify(
                        {
                            type: "event",
                            body: {
                                cmd:cmd,
                                args:args
                            },
                            timeStamp: new Date().toString()
                        }
                )
        ));

        processQueueWriteToSocket();
    }

    public function processQueueWriteToSocket():void
    {
        if (isSending || sendQueue.length == 0) return;

        var message:String = sendQueue.shift();
        isSending = true;

        var dataByteArray:ByteArray = new ByteArray();
        dataByteArray.writeUTFBytes(message);
        dataByteArray.writeByte(0);
        _socket.writeBytes(dataByteArray);
        _socket.flush();

        isSending = false;

        processQueueWriteToSocket();
    }

    private function listeners(): void {
        _socket.removeEventListener(Event.CONNECT, onConnect);
        _socket.removeEventListener(Event.CLOSE, onClose);
        _socket.removeEventListener(ProgressEvent.SOCKET_DATA, onDataReceived);
        _socket.removeEventListener(IOErrorEvent.IO_ERROR, onError);
        _socket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);

        _socket.addEventListener(Event.CONNECT, onConnect);
        _socket.addEventListener(Event.CLOSE, onClose);
        _socket.addEventListener(ProgressEvent.SOCKET_DATA, onDataReceived);
        _socket.addEventListener(IOErrorEvent.IO_ERROR, onError);
        _socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
    }

    private function onConnect(event:Event):void {
        _byteArray = new ByteArray();
        sendEvent("login", Game.loginInfo.strCharName, Game.loginInfo.strToken, Game.root.params.DeviceType, ConfigurationData.VERSION);
    }

    private function onClose(event:Event):void {
        _byteArray = new ByteArray();
        _game.logout();
        _game.mcConnDetail.showDisconnect("Communication with server has been lost. Please check your internet connection and try again.");
    }

    private function onDataReceived(event:ProgressEvent):void {
        _startTime = getTimer();

        var bytesToRead:int = _socket.bytesAvailable;

        while (bytesToRead > 0) {
            var dataByte:int = _socket.readByte();

            if (dataByte != 0) {
                byteArray.writeByte(dataByte);
            } else {
                try {
                    if (_game.ui.mcInterface.roundTripTime != null)
                    {
                        var elapsedTime:int = getTimer() - _startTime;
                        var colorTransform:ColorTransform = new ColorTransform();

                        colorTransform.color = elapsedTime < 100 ? 0xFF00 : elapsedTime < 200 ? 0xFFFF00 : 0xFF0000;

                        _game.ui.mcInterface.mcRTT.transform.colorTransform = colorTransform;
                        _game.ui.mcInterface.roundTripTime.text = elapsedTime + " ms";
                    }

                    var response:String = Base64.decode(byteArray.toString());
                    var json:Object = JSON.parse(response);

//                    trace("DEBUG DATA RECEIVED: " + JSON.stringify(json));

                    _handler.Protocol(json);
                } catch (e:Error) {
                    trace("====================================");
                    trace("[ERROR RECEIVED] =>[" + byteArray.toString() + "] => [ERROR] => [" + e.getStackTrace() + "]");
                    trace("====================================");
                }

                byteArray = new ByteArray();
            }

            bytesToRead--;
        }

    }

    private function onError(event:IOErrorEvent):void {
        _game.mcConnDetail.showError("Server currently unavailable.");
    }

    private function onSecurityError(event:SecurityErrorEvent):void {

    }

}
}