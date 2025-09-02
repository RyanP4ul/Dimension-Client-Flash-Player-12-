package network {

import com.jpauclair.Base64;

import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.net.Socket;
import flash.utils.ByteArray;

public class NetworkServer extends Socket {

//    private var game:Game;
    public var _myUserId:Number = -1;
    public var _myUserName:String = "";
    private var _byteArray:ByteArray;
//    private var socket:Socket;

    public static var test:int = 100;

    public function NetworkServer()
    {
//        this.game = game;
        _byteArray = new ByteArray();

//        socket = new Socket();

        listeners();
    }
    
    public function getMyUserId():Number {
        return _myUserId;
    }

    public function get myUserId(): Number
    {
        return _myUserId;
    }

    public function set myUserId(id:Number): void
    {
        _myUserId = id;
    }

    public function get myUserName(): String
    {
        return _myUserName;
    }

    public function set myUserName(name:String): void
    {
        _myUserName = name;
    }

    public function get byteArray(): ByteArray
    {
        return _byteArray;
    }

    public function set byteArray(byte:ByteArray): void
    {
        _byteArray = byte;
    }

    public function send(cmd: String, param2: Array): void
    {
        this.writeToSocket(Base64.encode(JSON.stringify(
                {
                    type: "request",
                    body: {
                        cmd:cmd,
                        args:param2
                    }
                }
        )));
    }

    public function sendEvent(param1:String, ... args): void
    {
        writeToSocket(Base64.encode(JSON.stringify(
                {
                    type: "event",
                    body: {
                        cmd:param1,
                        args:args
                    }
                }
        )));
    }

    public function writeToSocket(data:String):void
    {
        writeUTFBytes(data);
        writeByte(0);
        flush();
    }

    private function listeners(): void {
        removeEventListener(Event.CONNECT, onConnect);
        removeEventListener(Event.CLOSE, onClose);
        removeEventListener(ProgressEvent.SOCKET_DATA, onDataReceived);
        removeEventListener(IOErrorEvent.IO_ERROR, onError);
        removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);

        addEventListener(Event.CONNECT, onConnect);
        addEventListener(Event.CLOSE, onClose);
        addEventListener(ProgressEvent.SOCKET_DATA, onDataReceived);
        addEventListener(IOErrorEvent.IO_ERROR, onError);
        addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
    }

//    public function connect(ip:String, port:int): void {
//        socket.connect(ip, port);
//    }

    private function onConnect(event:Event):void {
        trace("[Network] => [ON CONNECT]");
        _byteArray = new ByteArray();
        sendEvent("login", Game.loginInfo.strUsername, Game.loginInfo.strToken);
    }

    private function onClose(event:Event):void {
        trace("[Network] => [ON CLOSE]");
        _byteArray = new ByteArray();
//        game.logout();
//        game.gotoAndPlay("login");
//        game.mcConnDetail.showDisconnect("Communication with server has been lost. Please check your internet connection and try again.");
    }

    private function onDataReceived(event:ProgressEvent):void {
        var b:int;
        var response:String;
        var json:Object;
        var arr:Array;
        var bytes:* = bytesAvailable;

        do {
            b = readByte();

            if (b != 0) {
                byteArray.writeByte(b);
            } else {
                try {
                    response = byteArray.toString();
                    json = JSON.parse(response);

                    trace("[RESPONSE] => " + response);
                } catch (e:Error) {
                    trace("[NETWORK] => [ON DATA RECEIVED] => [ERROR] => [" + e.getStackTrace() + "]")
                }
            }

            bytes = (bytes - 1);
        } while ((bytes - 1) >= 0)
    }

    private function onError(event:IOErrorEvent):void {
        trace("Socket connection error: " + event.text);
    }

    private function onSecurityError(event:SecurityErrorEvent):void {
        trace("Security error occurred: " + event.text);
    }

}

}
