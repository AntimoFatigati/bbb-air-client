package org.bigbluebutton.view.navigation.pages.login.openroom {
	
	import flash.desktop.NativeApplication;
	import flash.events.*;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
	import flash.ui.Keyboard;
	import flash.utils.describeType;
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;
	import mx.events.ItemClickEvent;
	import mx.resources.ResourceManager;
	
	import org.bigbluebutton.command.JoinMeetingSignal;
	import org.bigbluebutton.core.ISaveData;
	import org.bigbluebutton.model.IUserSession;
	import org.bigbluebutton.model.IUserUISession;
	import org.bigbluebutton.model.User;
	import org.bigbluebutton.model.UserList;
	import org.bigbluebutton.view.navigation.pages.disconnect.enum.DisconnectEnum;
	import robotlegs.bender.bundles.mvcs.Mediator;
	import spark.components.View;
	import spark.events.IndexChangeEvent;
	import org.bigbluebutton.view.navigation.pages.login.openroom.recentrooms.IRecentRoomsView;
	import org.bigbluebutton.view.navigation.pages.PagesENUM;
	
	
	
	public class OpenRoomViewMediator extends Mediator {
		
		[Inject]
		public var view:IOpenRoomView;
		
		[Inject]
		public var userSession:IUserSession;
		
		[Inject]
		public var userUISession:IUserUISession;
		
		[Inject]
		public var joinMeetingSignal:JoinMeetingSignal;
		
		override public function initialize():void {
			FlexGlobals.topLevelApplication.profileBtn.visible = false;
			FlexGlobals.topLevelApplication.backBtn.visible = false;
			FlexGlobals.topLevelApplication.bottomMenu.includeInLayout = false;
			FlexGlobals.topLevelApplication.topActionBar.visible = false;
			(view as View).addEventListener(KeyboardEvent.KEY_DOWN, KeyHandler);
			view.goButton.addEventListener(MouseEvent.CLICK, onGoButtonClick);
		}
		
		private function KeyHandler(e:KeyboardEvent):void {
			if (e.keyCode == Keyboard.ENTER) {
				onGoButtonClick(null);
			}
			view.reasonLabel.text = "";
		}
		
		private function onGoButtonClick(e:MouseEvent):void {
			view.reasonLabel.text = "";
			var url:String = view.inputRoom.text;
			if (url.indexOf("http") == -1) {
				url = "http://" + url;
			}
			var loader:URLLoader;
			loader = new URLLoader();
			configureListeners(loader);
			
			var request:URLRequest = new URLRequest(url);
			request.method = URLRequestMethod.GET;
			request.userAgent = "Mozilla/5.0 (Safari; iPad 2)";
			var useragent = request.userAgent;
			trace("xxxxxx_"+useragent);
			request.followRedirects=false;
			
			try {
				loader.load(request);
			} catch (error:Error) {
				trace("Unable to load requested document.");
			}
			
		}
		
		private function configureListeners(dispatcher:IEventDispatcher):void {
			dispatcher.addEventListener(Event.COMPLETE, completeHandler);
			dispatcher.addEventListener(Event.OPEN, openHandler);
			dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			dispatcher.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, httpResponseStatusHandler);
			dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		}
		
		private function completeHandler(event:Event):void {
			var loader:URLLoader = URLLoader(event.target);
			trace("completeHandler: " + loader.data);
			trace("completeHandler: " + event);
			
		    //trace(
		}
		
		private function openHandler(event:Event):void {
			trace("openHandler: " + event);
		}
		
		private function progressHandler(event:ProgressEvent):void {
			trace("progressHandler loaded:" + event.bytesLoaded + " total: " + event.bytesTotal);
		}
		
		private function securityErrorHandler(event:SecurityErrorEvent):void {
			trace("securityErrorHandler: " + event);
		}
		
		private function httpStatusHandler(event:HTTPStatusEvent):void {
			trace("httpStatusHandler: " + event);
			
			// Headers are case insensitive
			
			
		}
		
		private function httpResponseStatusHandler(event:HTTPStatusEvent):void {
			trace("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxhttpResponseStatusHandler: " + event);
			
			//bad request
			if(event.status == 400)
			{	trace ("bad request");
				
				view.reasonLabel.text = "Evento non valido o già terminato";
				//userUISession.popPage();
				//userUISession.pushPage(PagesENUM.LOGIN);
				joinMeetingSignal.dispatch(event.responseURL);
				
				return;
				
			}
			
			for each (var object:Object in event.responseHeaders)
			{
				trace(object.name+" : "+object.value);
				if(object.name == "Location")
				{
					var url = object.value;
					trace("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxURL: " + url);
					joinMeetingSignal.dispatch(url);
				}
				
			}
				
		}
		
		private function ioErrorHandler(event:IOErrorEvent):void {
			trace("ioErrorHandler: " + event);
			view.reasonLabel.text = "URL non corretta";
		}
		
		override public function destroy():void {
			super.destroy();
			(view as View).removeEventListener(KeyboardEvent.KEY_DOWN, KeyHandler);
			view.goButton.removeEventListener(MouseEvent.CLICK, onGoButtonClick);
			view.dispose();
			view = null;
		}
	}
}
