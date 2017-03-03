package org.bigbluebutton.view.navigation.pages.login.openroom {
	
	import org.bigbluebutton.view.navigation.pages.login.openroom.OpenRoomViewBase;
	import org.bigbluebutton.view.navigation.pages.login.openroom.recentrooms.IRecentRoomsView;
	import org.bigbluebutton.view.ui.NavigationButton;
	import spark.components.Button;
	import spark.components.List;
	import spark.components.TextInput;
	import spark.components.Label;
	
	
	public class OpenRoomView extends OpenRoomViewBase implements IOpenRoomView {
		override protected function childrenCreated():void {
			super.childrenCreated();
		}
		
		public function get inputRoom():TextInput {
			return inputRoom0;
		}
		
		public function get goButton():Button {
			return goButton0;
		}
		
		public function get reasonLabel():Label {
			return reasonLabel0;
		}
		
		public function set setReasonLabel( val) {
			reasonLabel0.text = val;
		}
		
		public function dispose():void {
		}
	}
}
