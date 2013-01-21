/*
 *   __| ___  __  __   __| ___  __  __  ___  
 *  (__|(__/_(___(__(_(__|(__/_|  )(___(__/__
 *  tile scrolling engine
 *
 * Licensed under the MIT License
 * Copyright (c) 2011 Hexagon Star Softworks
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to
 * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
 * the Software, and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
 * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */
package 
{
	import com.hexagonstar.decadence.Tile;
	import com.hexagonstar.decadence.TileGroup;
	import com.hexagonstar.decadence.TileMap;
	import com.hexagonstar.exception.IllegalArgumentException;
	import com.hexagonstar.util.Dice;
	import com.hexagonstar.util.NumberGenerator;
	
	
	/**
	 * Factory that creates tilemaps.
	 */
	public class TileMapFactory
	{
		//-----------------------------------------------------------------------------------------
		// Properties
		//-----------------------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private var _tilemap:TileMap;
		
		
		//-----------------------------------------------------------------------------------------
		// Constructor
		//-----------------------------------------------------------------------------------------
		
		/**
		 * Creates a new instance of the class.
		 */
		public function TileMapFactory()
		{
		}
		
		
		//-----------------------------------------------------------------------------------------
		// Public Methods
		//-----------------------------------------------------------------------------------------
		
		/**
		 * Creates a TileMap object from the specified tilemap data.
		 * 
		 * @param tilemapData XML data for the tilemap.
		 * @return The created tilemap.
		 */
		public function create(tilemapData:XML):TileMap
		{
			parseData(tilemapData);
			var tilemap:TileMap = _tilemap;
			_tilemap.measure();
			_tilemap = null;
			return tilemap;
		}
		
		
		/**
		 * Generates a random tilemap.
		 * 
		 * @param sizeRange 0 = any, 1 = small, 2 = medium, 3 = large
		 * 
		 * @return The generated tilemap.
		 */
		public function generate(mapType:int, sizeRange:int = 0):TileMap
		{
			switch (mapType)
			{
				case 1:
					generateType1RandomMap(sizeRange);
					break;
				case 2:
					generateType2RandomMap(sizeRange);
					break;
				case 3:
					generateType3RandomMap(sizeRange);
					break;
				case 4:
					generateType4RandomMap(sizeRange);
					break;
			}
			
			_tilemap.measure();
			var tilemap:TileMap = _tilemap;
			_tilemap = null;
			return tilemap;
		}
		
		
		/**
		 * Returns a String Representation of the class.
		 * 
		 * @return A String Representation of the class.
		 */
		public function toString():String
		{
			return "[TileMapFactory]";
		}
		
		
		//-----------------------------------------------------------------------------------------
		// Private Methods
		//-----------------------------------------------------------------------------------------
		
		/**
		 * Parses the specified XML data and creates a ready-to-use TileMap object
		 * from it.
		 * 
		 * @private
		 */
		private function parseData(tilemapData:XML):void
		{
			// TODO
		}
		
		
		/**
		 * @private
		 */
		private function generateType1RandomMap(sizeRange:int):void
		{
			var minSize:int = (sizeRange == 0) ? 2 : (sizeRange == 1) ? 2 : (sizeRange == 2) ? 20 : 100;
			var maxSize:int = (sizeRange == 0) ? 200 : (sizeRange == 1) ? 10 : (sizeRange == 2) ? 40 : 200;
			
			/* Random size */
			var w:int = NumberGenerator.random(minSize, maxSize);
			var h:int = NumberGenerator.random(minSize, maxSize);
			
			_tilemap = new TileMap();
			//Debug.trace((w * (h + 2)));
			
			/* random margin */
			if (Dice.chance(33)) _tilemap.margin = 0;
			else _tilemap.margin = NumberGenerator.random(20, 200);
			
			/* Random bg color */
			_tilemap.backgroundColor = generateRandomColor();
			
			var c:int = 0;
			for (var y:int = 0; y < h; y++)
			{
				for (var x:int = 0; x < w; x++)
				{
					var rnd:int = NumberGenerator.random(1, 3);
					switch (rnd)
					{
						case 1:
							_tilemap.addTileGroup(generateTileGroup("128x128", 128 * x, 128 * y));
							break;
						case 2:
							_tilemap.addTileGroup(generateTileGroup("128x128b", 128 * x, 128 * y));
							break;
						case 3:
							_tilemap.addTileGroup(generateTileGroup("32x32", 128 * x, 128 * y));
							_tilemap.addTileGroup(generateTileGroup("128x96", 128 * x, 128 * y));
							_tilemap.addTileGroup(generateTileGroup("128x32", 128 * x, (128 * y) + 96));
							c += 2;
							break;
					}
					c++;
				}
			}
			//Debug.trace(c);
		}
		
		
		/**
		 * @private
		 */
		private function generateType2RandomMap(sizeRange:int):void
		{
			var minSize:int = (sizeRange == 0) ? 2 : (sizeRange == 1) ? 2 : (sizeRange == 2) ? 20 : 100;
			var maxSize:int = (sizeRange == 0) ? 200 : (sizeRange == 1) ? 10 : (sizeRange == 2) ? 40 : 200;
			
			_tilemap = new TileMap();
			var i:int;
			
			/* Random size */
			var w:int = NumberGenerator.random(minSize, maxSize);
			var h:int = NumberGenerator.random(minSize, maxSize);
			var c:int = ((w + h) / 2) * 20;
			var spreadH:int = (128 * w) - 128 - 32;
			var spreadV:int = (128 * h) - 128 - 32;
			
			/* random margin */
			if (Dice.chance(33)) _tilemap.margin = 0;
			else _tilemap.margin = NumberGenerator.random(20, 200);
			
			/* Random bg color */
			_tilemap.backgroundColor = generateRandomColor();
			
			/* Generate upper and lower border for the tilemap. */
			for (i = 0; i < w; i++)
			{
				_tilemap.addTileGroup(generateTileGroup("128x16", 128 * i, 0));
				_tilemap.addTileGroup(generateTileGroup("128x16", 128 * i, 16 + 128 * h));
			}
			/* Generate left and right border for the tilemap. */
			for (i = 0; i < h; i++)
			{
				_tilemap.addTileGroup(generateTileGroup("16x128", 0, 16 + 128 * i));
				_tilemap.addTileGroup(generateTileGroup("16x128", 128 * w - 16, 16 + 128 * i));
			}
			
			/* Fill the tilemap with random tilegroups. */
			for (i = 0; i < c; i++)
			{
				_tilemap.addTileGroup(generateTileGroup("16x128", 16 + int(Math.random() * spreadH), 16 + int(Math.random() * spreadV)));
				_tilemap.addTileGroup(generateTileGroup("48x32", 16 + int(Math.random() * spreadH), 16 + int(Math.random() * spreadV)));
				_tilemap.addTileGroup(generateTileGroup("128x64", 16 + int(Math.random() * spreadH), 16 + int(Math.random() * spreadV)));
				_tilemap.addTileGroup(generateTileGroup("128x16", 16 + int(Math.random() * spreadH), 16 + int(Math.random() * spreadV)));
			}
		}
		
		
		/**
		 * @private
		 */
		private function generateType3RandomMap(sizeRange:int):void
		{
			var w:int = 12;
			var h:int = 10;
			
			_tilemap = new TileMap();
			_tilemap.margin = 0;
			
			/* Random bg color */
			_tilemap.backgroundColor = generateRandomColor();
			
			var c:int = 0;
			for (var y:int = 0; y < h; y++)
			{
				for (var x:int = 0; x < w; x++)
				{
					var rnd:int = NumberGenerator.random(1, 3);
					switch (rnd)
					{
						case 1:
							_tilemap.addTileGroup(generateTileGroup("128x128", 128 * x, 128 * y));
							break;
						case 2:
							_tilemap.addTileGroup(generateTileGroup("128x128b", 128 * x, 128 * y));
							break;
						case 3:
							_tilemap.addTileGroup(generateTileGroup("32x32", 128 * x, 128 * y));
							_tilemap.addTileGroup(generateTileGroup("128x96", 128 * x, 128 * y));
							_tilemap.addTileGroup(generateTileGroup("128x32", 128 * x, (128 * y) + 96));
							c += 2;
							break;
					}
					c++;
				}
			}
		}
		
		
		/**
		 * @private
		 */
		private function generateType4RandomMap(sizeRange:int):void
		{
			var minSize:int = (sizeRange == 0) ? 2 : (sizeRange == 1) ? 2 : (sizeRange == 2) ? 20 : 100;
			var maxSize:int = (sizeRange == 0) ? 200 : (sizeRange == 1) ? 10 : (sizeRange == 2) ? 40 : 200;
			
			_tilemap = new TileMap();
			var i:int;
			
			/* Random size */
			var w:int = NumberGenerator.random(minSize, maxSize);
			var h:int = NumberGenerator.random(minSize, maxSize);
			
			/* random margin */
			if (Dice.chance(33)) _tilemap.margin = 0;
			else _tilemap.margin = NumberGenerator.random(20, 200);
			
			/* Random bg color */
			_tilemap.backgroundColor = generateRandomColor();
			
			/* Generate upper and lower border for the tilemap. */
			for (i = 0; i < w; i++)
			{
				_tilemap.addTileGroup(generateBDTileGroup("border_128x32", 128 * i, 0));
				_tilemap.addTileGroup(generateBDTileGroup("border_128x32", 128 * i, 32 + 128 * h));
			}
			/* Generate left and right border for the tilemap. */
			for (i = 0; i < h; i++)
			{
				_tilemap.addTileGroup(generateBDTileGroup("border_32x128", 0, 32 + 128 * i));
				_tilemap.addTileGroup(generateBDTileGroup("border_32x128", 128 * w - 32, 32 + 128 * i));
			}
			
			var fw:int = (w * 4) - 1;
			var fh:int = (h * 4) + 1;
			for (var y:int = 1; y < fh; y++)
			{
				for (var x:int = 1; x < fw; x++)
				{
					var rnd:int = NumberGenerator.random(1, 5);
					switch (rnd)
					{
						case 1:
							_tilemap.addTileGroup(generateBDTileGroup("ground_32x32", 32 * x, 32 * y));
							break;
						case 2:
							_tilemap.addTileGroup(generateBDTileGroup(Dice.chance(80) ? "wall_32x32" : "ground_32x32", 32 * x, 32 * y));
							break;
						case 3:
							_tilemap.addTileGroup(generateBDTileGroup(Dice.chance(40) ? "rock_32x32" : "ground_32x32", 32 * x, 32 * y));
							break;
						case 4:
							_tilemap.addTileGroup(generateBDTileGroup(Dice.chance(20) ? "gem_32x32" : "ground_32x32", 32 * x, 32 * y));
							break;
						case 5:
							_tilemap.addTileGroup(generateBDTileGroup(Dice.chance(1) ? "exit_32x32" : "ground_32x32", 32 * x, 32 * y));
							break;
					}
				}
			}
		}
		
		
		/**
		 * Generates a tilegroup of the specified signature.
		 * 
		 * @param type The type of the tilegroup.
		 * @param x The x position of the tilegroup on the tilemap.
		 * @param y The y position of the tilegroup on the tilemap.
		 * 
		 * @private
		 */
		private function generateTileGroup(type:String, x:int, y:int):TileGroup
		{
			var tilegroup:TileGroup = new TileGroup();
			
			switch (type)
			{
				case "32x32":
					tilegroup.addTile(generateTile(BitmapTile16x16, 0, 0));
					tilegroup.addTile(generateTile(BitmapTile16x16, 16, 0));
					tilegroup.addTile(generateTile(BitmapTile16x16, 0, 16));
					tilegroup.addTile(generateTile(BitmapTile16x16, 16, 16));
					tilegroup.width = 32;
					tilegroup.height = 32;
					break;
				case "128x16":
					tilegroup.addTile(generateTile(BitmapTile64x16, 0, 0));
					tilegroup.addTile(generateTile(BitmapTile64x16, 64, 0));
					tilegroup.width = 128;
					tilegroup.height = 16;
					break;
				case "16x128":
					tilegroup.addTile(generateTile(BitmapTile16x64, 0, 0));
					tilegroup.addTile(generateTile(BitmapTile16x64, 0, 64));
					tilegroup.width = 16;
					tilegroup.height = 128;
					break;
				case "48x32":
					tilegroup.addTile(generateTile(BitmapTile16x16, 0, 0));
					tilegroup.addTile(generateTile(BitmapTile16x16, 16, 0));
					tilegroup.addTile(generateTile(BitmapTile16x16, 32, 0));
					tilegroup.addTile(generateTile(BitmapTile16x16, 0, 16));
					tilegroup.addTile(generateTile(BitmapTile16x16, 16, 16));
					tilegroup.addTile(generateTile(BitmapTile16x16, 32, 16));
					tilegroup.width = 48;
					tilegroup.height = 32;
					break;
				case "128x32":
					tilegroup.addTile(generateTile(BitmapTile32x32, 0, 0));
					tilegroup.addTile(generateTile(BitmapTile32x32, 32, 0));
					tilegroup.addTile(generateTile(BitmapTile32x32, 64, 0));
					tilegroup.addTile(generateTile(BitmapTile32x32, 96, 0));
					tilegroup.width = 128;
					tilegroup.height = 32;
					break;
				case "128x64":
					tilegroup.addTile(generateTile(BitmapTile64x64, 0, 0));
					tilegroup.addTile(generateTile(BitmapTile64x64, 64, 0));
					tilegroup.width = 128;
					tilegroup.height = 64;
					break;
				case "128x96":
					tilegroup.addTile(generateTile(BitmapTile16x64, 0, 32));
					tilegroup.addTile(generateTile(BitmapTile16x64, 16, 32));
					tilegroup.addTile(generateTile(BitmapTile96x96, 32, 0));
					tilegroup.width = 128;
					tilegroup.height = 96;
					break;
				case "128x128":
					tilegroup.addTile(generateTile(BitmapTile64x64, 0, 0));
					tilegroup.addTile(generateTile(BitmapTile64x64, 64, 0));
					tilegroup.addTile(generateTile(BitmapTile64x64, 0, 64));
					tilegroup.addTile(generateTile(BitmapTile64x64, 64, 64));
					tilegroup.width = 128;
					tilegroup.height = 128;
					break;
				case "128x128b":
					tilegroup.addTile(generateTile(BitmapTile32x32, 0, 0));
					tilegroup.addTile(generateTile(BitmapTile32x32, 32, 0));
					tilegroup.addTile(generateTile(BitmapTile32x32, 0, 32));
					tilegroup.addTile(generateTile(BitmapTile32x32, 32, 32));
					tilegroup.addTile(generateTile(BitmapTile64x64, 64, 0));
					tilegroup.addTile(generateTile(BitmapTile64x64, 0, 64));
					
					tilegroup.addTile(generateTile(BitmapTile32x32, 64, 64));
					tilegroup.addTile(generateTile(BitmapTile32x32, 96, 64));
					tilegroup.addTile(generateTile(BitmapTile32x32, 64, 96));
					tilegroup.addTile(generateTile(BitmapTile32x32, 96, 96));
					tilegroup.width = 128;
					tilegroup.height = 128;
					break;
				case "1024x512":
					tilegroup.addTile(generateTile(BitmapTile512x512, 0, 0));
					tilegroup.addTile(generateTile(BitmapTile512x512, 512, 0));
					tilegroup.width = 1024;
					tilegroup.height = 512;
					break;
				default:
					throw new IllegalArgumentException(toString()
						+ " Unknown tilegroup type: " + type);
					return null;
			}
			
			tilegroup.x = x;
			tilegroup.y = y;
			tilegroup.right = x + tilegroup.width;
			tilegroup.bottom = y + tilegroup.height;
			
			return tilegroup;
		}
		
		
		/**
		 * @private
		 */
		private function generateBDTileGroup(type:String, x:int, y:int):TileGroup
		{
			var tilegroup:TileGroup = new TileGroup();
			
			switch (type)
			{
				case "border_128x32":
					tilegroup.addTile(generateTile(BitmapTileBD1, 0, 0));
					tilegroup.addTile(generateTile(BitmapTileBD1, 32, 0));
					tilegroup.addTile(generateTile(BitmapTileBD1, 64, 0));
					tilegroup.addTile(generateTile(BitmapTileBD1, 96, 0));
					tilegroup.width = 128;
					tilegroup.height = 32;
					break;
				case "border_32x128":
					tilegroup.addTile(generateTile(BitmapTileBD1, 0, 0));
					tilegroup.addTile(generateTile(BitmapTileBD1, 0, 32));
					tilegroup.addTile(generateTile(BitmapTileBD1, 0, 64));
					tilegroup.addTile(generateTile(BitmapTileBD1, 0, 96));
					tilegroup.width = 32;
					tilegroup.height = 128;
					break;
				case "ground_32x32":
					tilegroup.addTile(generateTile(BitmapTileBD4, 0, 0));
					tilegroup.width = 32;
					tilegroup.height = 32;
					break;
				case "wall_32x32":
					tilegroup.addTile(generateTile(BitmapTileBD3, 0, 0));
					tilegroup.width = 32;
					tilegroup.height = 32;
					break;
				case "exit_32x32":
					tilegroup.addTile(generateTile(BitmapTileBD2, 0, 0));
					tilegroup.width = 32;
					tilegroup.height = 32;
					break;
				case "rock_32x32":
					tilegroup.addTile(generateTile(BitmapTileBD5, 0, 0));
					tilegroup.width = 32;
					tilegroup.height = 32;
					break;
				case "gem_32x32":
					tilegroup.addTile(generateTile(BitmapTileBD6, 0, 0));
					tilegroup.width = 32;
					tilegroup.height = 32;
					break;
				default:
					throw new IllegalArgumentException(toString()
						+ " Unknown tilegroup type: " + type);
					return null;
			}
			
			tilegroup.x = x;
			tilegroup.y = y;
			tilegroup.right = x + tilegroup.width;
			tilegroup.bottom = y + tilegroup.height;
			
			return tilegroup;
			
		}
		
		
		/**
		 * Generates a tile for generated tilegroups.
		 * @private
		 */
		private function generateTile(tileSymbolClass:Class, x:int, y:int):Tile
		{
			var t:Tile = new Tile();
			t.symbolClass = tileSymbolClass;
			t.x = x;
			t.y = y;
			return t;
		}
		
		
		/**
		 * @private
		 */
		public function generateRandomColor():uint
		{
			//var colors:Array = [0xFF000000, 0xFF661100, 0xFF004411, 0xFF001144, 0xFF004488, 0xFF666666];
			var colors:Array =
			[
				0xFF000000,
				0xFFA24D42,
				0xFF6AC2C8,
				0xFFA256A5,
				0xFF5CAD5F,
				0xFF4F449D,
				0xFFA3683A,
				0xFF6D530B,
				0xFF636363,
				0xFF8B8B8B
			];
			var r:int = Math.random() * colors.length;
			var c:uint = colors[r];
			return c;
		}
	}
}
