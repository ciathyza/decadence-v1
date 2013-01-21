package 
{
	import com.hexagonstar.decadence.TileMap;
	import com.hexagonstar.decadence.TileScroller;
	import com.hexagonstar.display.StageReference;
	import com.hexagonstar.util.debug.Debug;

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.KeyboardEvent;
	import flash.geom.Rectangle;
	import flash.system.System;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import flash.utils.setInterval;



	
	
	public class ScrollTest extends Sprite
	{
		//-----------------------------------------------------------------------------------------
		// Constants
		//-----------------------------------------------------------------------------------------
		
		private static const VIEWPORT_SIZES:Array =
		[
			{w: 320,  h: 200},
			{w: 384,  h: 256},
			{w: 640,  h: 400},
			{w: 800,  h: 500},
			{w: 1024, h: 640},
			{w: 1280, h: 800},
			{w: 1440, h: 900},
			{w: 1600, h: 1000},
			{w: 1920, h: 1200},
		];
		
		//-----------------------------------------------------------------------------------------
		// Properties
		//-----------------------------------------------------------------------------------------
		
		private var _tilemap:TileMap;
		private var _tileScroller:TileScroller;
		private var _infoBox:Sprite;
		private var _helpBox:Sprite;
		private var _infoTF:TextField;
		private var _helpTF:TextField;
		private var _format:TextFormat;
		
		private var _currentSize:int = 1;
		private var _mem:String = "0.0";
		private var _edgeMode:String = "";
		
		
		//-----------------------------------------------------------------------------------------
		// Constructor
		//-----------------------------------------------------------------------------------------
		
		/**
		 * Creates a new instance of the class.
		 */
		public function ScrollTest()
		{
			super();
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.fullScreenSourceRect = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
			StageReference.stage = stage;
			
			Debug.monitor(stage);
			Debug.clear();
			
			setup();
		}
		
		
		//-----------------------------------------------------------------------------------------
		// Event Handlers
		//-----------------------------------------------------------------------------------------
		
		private function onKeyDown(e:KeyboardEvent):void
		{
			switch (e.keyCode)
			{
				case Keyboard.LEFT:
				case 65:
					_tileScroller.scroll("l");
					break;
				case Keyboard.RIGHT:
				case 68:
					_tileScroller.scroll("r");
					break;
				case Keyboard.UP:
				case 87:
					_tileScroller.scroll("u");
					break;
				case Keyboard.DOWN:
				case 83:
					_tileScroller.scroll("d");
					break;
				case 71:
					_tileScroller.showAreas = !_tileScroller.showAreas;
					break;
				case 77:
					_tileScroller.showMapBoundaries = !_tileScroller.showMapBoundaries;
					break;
				case 66:
					_tileScroller.showBoundingBoxes = !_tileScroller.showBoundingBoxes;
					break;
				case 82:
					_tileScroller.showBuffer = !_tileScroller.showBuffer;
					break;
				case 67:
					_tileScroller.cacheObjects = !_tileScroller.cacheObjects;
					break;
				case 80:
					_tileScroller.paused = !_tileScroller.paused;
					break;
				case 72:
					_tileScroller.autoScrollH = !_tileScroller.autoScrollH;
					break;
				case 86:
					_tileScroller.autoScrollV = !_tileScroller.autoScrollV;
					break;
				case 70:
					toggleFullscreen();
					break;
				case 69:
					switchEdgeMode();
					break;
				case 84:
					_tileScroller.useTimer = !_tileScroller.useTimer;
					break;
				case 189:
				case 109:
					if (e.ctrlKey) _tileScroller.speedV--;
					else if (e.shiftKey) _tileScroller.speedH--;
					else _tileScroller.speed--;
					break;
				case 187:
				case 107:
					if (e.ctrlKey) _tileScroller.speedV++;
					else if (e.shiftKey) _tileScroller.speedH++;
					else _tileScroller.speed++;
					break;
				case 188:
					if (_tileScroller.frameRate > 10) _tileScroller.frameRate--;
					break;
				case 190:
					if (_tileScroller.frameRate < 200) _tileScroller.frameRate++;
					break;
				case 186:
					if (stage.frameRate > 10) stage.frameRate--;
					break;
				case 222:
					if (stage.frameRate < 200) stage.frameRate++;
					break;
				case 112:
					if (_infoBox.visible)
					{
						_infoBox.visible = false;
						removeChild(_infoBox);
					}
					else
					{
						addChild(_infoBox);
						_infoBox.visible = true;
					}
					break;
				case 113:
					if (_helpBox.visible)
					{
						_helpBox.visible = false;
						removeChild(_helpBox);
					}
					else
					{
						addChild(_helpBox);
						_helpBox.visible = true;
					}
					break;
				case 75:
					resizeScroller(false);
					break;
				case 76:
					resizeScroller(true);
					break;
				case 49:
					if (e.ctrlKey && e.shiftKey) createTilemap(1, 2);
					else if (e.ctrlKey) createTilemap(1, 1);
					else if (e.shiftKey) createTilemap(1, 3);
					else createTilemap(1, 0);
					break;
				case 50:
					if (e.ctrlKey && e.shiftKey) createTilemap(2, 2);
					else if (e.ctrlKey) createTilemap(2, 1);
					else if (e.shiftKey) createTilemap(2, 3);
					else createTilemap(2, 0);
					break;
				case 51:
					if (e.ctrlKey && e.shiftKey) createTilemap(3, 2);
					else if (e.ctrlKey) createTilemap(3, 1);
					else if (e.shiftKey) createTilemap(3, 3);
					else createTilemap(3, 0);
					break;
				case 52:
					if (e.ctrlKey && e.shiftKey) createTilemap(4, 2);
					else if (e.ctrlKey) createTilemap(4, 1);
					else if (e.shiftKey) createTilemap(4, 3);
					else createTilemap(4, 0);
					break;
				case 191:
					_tileScroller.reset();
					break;
			}
		}
		
		
		private function onKeyUp(e:KeyboardEvent):void
		{
			switch (e.keyCode)
			{
				case Keyboard.LEFT:
				case 65:
					_tileScroller.stopScroll("l");
					break;
				case Keyboard.RIGHT:
				case 68:
					_tileScroller.stopScroll("r");
					break;
				case Keyboard.UP:
				case 87:
					_tileScroller.stopScroll("u");
					break;
				case Keyboard.DOWN:
				case 83:
					_tileScroller.stopScroll("d");
					break;
			}
		}
		
		
		private function onTileScrollerTick(ts:TileScroller):void
		{
			updateInfo();
		}
		
		
		//-----------------------------------------------------------------------------------------
		// Private Methods
		//-----------------------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function setup():void
		{
			createScroller();
			createTilemap(3);
			createTextFormat();
			createInfoBox();
			createHelpBox();
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			
			_tileScroller.start();
			setInterval(checkMem, 1000);
		}
		
		
		/**
		 * @private
		 */
		private function createTextFormat():void
		{
			Font.registerFont(TerminalscopeFont);
			//Font.registerFont(TerminalscopeInverseFont);
			
			_format = new TextFormat();
			_format.font = "Terminalscope";
			_format.size = 16;
			_format.color = 0xFFFFFF;
		}
		
		
		/**
		 * @private
		 */
		private function createInfoBox():void
		{
			_infoBox = new Sprite();
			_infoTF = new TextField();
			_infoTF.x = 4;
			_infoTF.y = 4;
			_infoTF.width = 170;
			_infoTF.height = 310;
			_infoTF.multiline = true;
			_infoTF.selectable = false;
			_infoTF.embedFonts = true;
			_infoTF.defaultTextFormat = _format;
			_infoBox.addChild(_infoTF);
			updateInfo();
			_infoBox.graphics.beginFill(0x0000FF, 1.0);
			_infoBox.graphics.drawRect(0, 0, _infoBox.width + 8, _infoBox.height + 8);
			_infoBox.graphics.endFill();
			_infoBox.x = 10;;
			_infoBox.y = 10;
			addChild(_infoBox);
		}
		
		
		/**
		 * @private
		 */
		private function createHelpBox():void
		{
			_helpBox = new Sprite();
			_helpTF = new TextField();
			_helpTF.x = 4;
			_helpTF.y = 4;
			_helpTF.width = 170;
			_helpTF.height = 280;
			_helpTF.multiline = true;
			_helpTF.selectable = false;
			_helpTF.embedFonts = true;
			_helpTF.defaultTextFormat = _format;
			_helpTF.text = ""
				+ "[cursor/wasd] scroll"
				+ "\n[1,2,3,4] generate map"
				+ "\n[f] fullscreen"
				+ "\n[p] pause"
				+ "\n[g] areagrid"
				+ "\n[m] map boundaries"
				+ "\n[b] bounding boxes"
				+ "\n[r] render buffer"
				+ "\n[c] caching on/off"
				+ "\n[e] switch edge mode"
				+ "\n[t] switch timer mode"
				+ "\n[-+] scroll speed"
				+ "\n[kl] viewport size"
				+ "\n[hv] h/v autoscroll"
				+ "\n[,.] dec/inc scroll FPS"
				+ "\n[;'] dec/inc stage FPS"
				+ "\n[/] reset scroller"
				+ "\n[f1] toggle infobox"
				+ "\n[f2] toggle helpbox"
				+ "";
			_helpBox.addChild(_helpTF);
			_helpBox.graphics.beginFill(0x0000AA, 1.0);
			_helpBox.graphics.drawRect(0, 0, _helpBox.width + 8, _helpBox.height + 8);
			_helpBox.graphics.endFill();
			_helpBox.x = 10;;
			_helpBox.y = _infoBox.y + _infoBox.height;
			addChild(_helpBox);
		}
		
		
		/**
		 * @private
		 */
		private function updateInfo():void
		{
			var s:String = ""
				+ "View Size: " + _tileScroller.viewportWidth + " x " + _tileScroller.viewportHeight
				+ "\n"
				+ "\nMap Size: " + _tilemap.width + " x " + _tilemap.height
				+ "\nPos:  x" + _tileScroller.xPos + " y" + _tileScroller.yPos
				+ "\nArea: " + _tileScroller.currentArea
				+ "\nAreas #" + _tilemap.areaCount
				+ "\n"
				+ "\nFPS:   " + _tileScroller.fps + " (t:" + _tileScroller.frameRate + " s:" + stage.frameRate + ")"
				+ "\nMS:    " + _tileScroller.ms
				+ "\nMEM:   " + _mem
				+ "\n"
				+ "\nObj.Total:   " + _tilemap.groupCount
				+ "\nObj.Visible: " + _tileScroller.visibleObjectCount
				+ "\nObj.Cached:  " + _tileScroller.cachedObjectCount
				+ "\nPurge Count: " + _tileScroller.objectPurgeAmount
				+ "\n"
				+ "\nSpeed H: " + _tileScroller.speedH
				+ "\nSpeed V: " + _tileScroller.speedV
				+ "\nEdge Mode: " + _edgeMode
				+ "\nUse Timer: " + _tileScroller.useTimer
				+ "\n\n" + (_tileScroller.paused ? "PAUSED" : "")
				+ "";
			_infoTF.text = s;
		}
		
		
		/**
		 * @private
		 */
		private function createScroller():void
		{
			TileScroller.stageReference = stage;
			
			var w:int = VIEWPORT_SIZES[_currentSize]["w"];
			var h:int = VIEWPORT_SIZES[_currentSize]["h"];
			_tileScroller = new TileScroller(w, h);
			_tileScroller.onTick = onTileScrollerTick;
			//_tileScroller.edgeMode = TileScroller.EDGE_MODE_HALT;
			//_edgeMode = "halt";
			_tileScroller.edgeMode = TileScroller.EDGE_MODE_WRAP;
			_edgeMode = "wrap";
			_tileScroller.speed = 10;
			_tileScroller.deceleration = 0.9;
			//_tileScroller.pooling = false;
			addChild(_tileScroller);
			centerScroller();
		}
		
		
		/**
		 * @private
		 */
		private function createTilemap(mapType:int, sizeRange:int = 0):void
		{
			_tilemap = new TileMapFactory().generate(mapType, sizeRange);
			_tileScroller.tilemap = _tilemap;
		}
		
		
		/**
		 * @private
		 */
		private function resizeScroller(inc:Boolean):void
		{
			var w:int;
			var h:int;
			
			if (inc)
			{
				if (_currentSize == VIEWPORT_SIZES.length - 1) return;
				w = VIEWPORT_SIZES[_currentSize + 1]["w"];
				h = VIEWPORT_SIZES[_currentSize + 1]["h"];
				if (w > stage.stageWidth)
				{
					return;
				}
				else
				{
					_currentSize++;
				}
			}
			else
			{
				if (_currentSize == 0) return;
				_currentSize--;
			}
			
			w = VIEWPORT_SIZES[_currentSize]["w"];
			h = VIEWPORT_SIZES[_currentSize]["h"];
			
			_tileScroller.setViewportSize(w, h);
			centerScroller();
		}
		
		
		/**
		 * @private
		 */
		private function centerScroller():void
		{
			//_tileScroller.x = 40;
			//_tileScroller.y = 40;
			_tileScroller.x = int((stage.stageWidth / 2) - (_tileScroller.viewportWidth / 2));
			_tileScroller.y = int((stage.stageHeight / 2) - (_tileScroller.viewportHeight / 2));
		}
		
		
		/**
		 * @private
		 */
		private function toggleFullscreen():void
		{
			var state:String = stage.displayState;
			var interactive:String = StageDisplayState["FULL_SCREEN_INTERACTIVE"];
			/* We have fs interactive support! */
			if (interactive != null)
			{
				if (state == StageDisplayState["FULL_SCREEN_INTERACTIVE"]
					|| state == StageDisplayState.FULL_SCREEN)
				{
					state = StageDisplayState.NORMAL;
				}
				else
				{
					state = StageDisplayState["FULL_SCREEN_INTERACTIVE"];
				}
			}
			else
			{
				if (state == StageDisplayState.FULL_SCREEN)
				{
					state = StageDisplayState.NORMAL;
				}
				else
				{
					state = StageDisplayState.FULL_SCREEN;
				}
			}
			
			stage.displayState = state;
		}
		
		
		/**
		 * @private
		 */
		private function switchEdgeMode():void
		{
			if (_tileScroller.edgeMode == TileScroller.EDGE_MODE_OFF)
			{
				_tileScroller.edgeMode = TileScroller.EDGE_MODE_HALT;
				_edgeMode = "halt";
			}
			else if (_tileScroller.edgeMode == TileScroller.EDGE_MODE_HALT)
			{
				_tileScroller.edgeMode = TileScroller.EDGE_MODE_WRAP;
				_edgeMode = "wrap";
			}
			else if (_tileScroller.edgeMode == TileScroller.EDGE_MODE_WRAP)
			{
				_tileScroller.edgeMode = TileScroller.EDGE_MODE_BOUNCE;
				_edgeMode = "bounce";
			}
			else if (_tileScroller.edgeMode == TileScroller.EDGE_MODE_BOUNCE)
			{
				_tileScroller.edgeMode = TileScroller.EDGE_MODE_OFF;
				_edgeMode = "off";
			}
		}
		
		
		/**
		 * @private
		 */
		private function checkMem():void
		{
			var m:String = "" + Number((System.totalMemory * 0.000000954).toFixed(1));
			if (m.length < 3) m += ".0";
			_mem = m + " MB";
		}
	}
}
