package
{
	import com.adobe.nativeExtensions.AppPurchase;
	import com.adobe.nativeExtensions.AppPurchaseEvent;
	
	import flash.debugger.enterDebugger;
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageOrientation;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.StageOrientationEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	public class splashdemo extends Sprite
	{
		public function splashdemo()
		{
			super();
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			//The orientation reads correctly right here.
			trace("The stage orientation in the ctor is: " + stage.orientation);
			
			//But, the splash screen has skewed Default-Landscape.png.
			//Look at your device now that the debugger has stopped.
			enterDebugger();

			//If you remove <orientation>landscape</orientation> in the config xml file
			//the stage may be in a portrait view here.
			//This is where you can work around the skewed Default-Landscape.png issue 
			//and manually rotate the stage.
			if (!isOrientationAllowed())
				stage.setOrientation(StageOrientation.ROTATED_RIGHT);
			
			//This is just the typical init process I use.
			if (isStageCorrectSize() && isOrientationAllowed())
			{
				initAfterStageIsReallyReady();
			}
			else
			{
				stage.addEventListener(Event.RESIZE, onCheckStageStage);
				stage.addEventListener(StageOrientationEvent.ORIENTATION_CHANGE, onCheckStageStage);
			}
			
			//This will enforce landscape-only.
			stage.addEventListener(StageOrientationEvent.ORIENTATION_CHANGING, onCheckOrientation);
		}
		
		private function onCheckStageStage(e:Event):void
		{
			if (!isStageCorrectSize() || !isOrientationAllowed())
				return;
			
			stage.removeEventListener(Event.RESIZE, onCheckStageStage);
			stage.removeEventListener(StageOrientationEvent.ORIENTATION_CHANGE, onCheckStageStage);
			initAfterStageIsReallyReady();
		}
		
		private function isOrientationAllowed():Boolean
		{
			return stage.orientation == StageOrientation.ROTATED_LEFT || stage.orientation == StageOrientation.ROTATED_RIGHT;
		}
		
		private function isStageCorrectSize():Boolean
		{
			return stage.stageHeight == stage.fullScreenHeight && stage.stageWidth == stage.fullScreenWidth;
		}
		
		private function initAfterStageIsReallyReady():void
		{
			var tf:TextField = new TextField();
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.type = TextFieldType.DYNAMIC;
			tf.text = "This is an amazing app that works only in landscape orientation.";
			tf.x = (stage.stageWidth - tf.textWidth) * .5;
			tf.y = (stage.stageHeight - tf.textHeight) * .5;
			addChild(tf);
		}
		
		private function onCheckOrientation(e:StageOrientationEvent):void
		{
			if (e.afterOrientation == StageOrientation.DEFAULT || e.afterOrientation == StageOrientation.UPSIDE_DOWN)
			{
				e.preventDefault();
				trace("Ignoring request to change orientation to: " + e.afterOrientation);
			}
			else
			{
				trace("Allowing request to change orientation to: " + e.afterOrientation);
			}
				
		}
	}
}