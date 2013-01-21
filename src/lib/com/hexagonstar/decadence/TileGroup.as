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
package com.hexagonstar.decadence
{
	import flash.display.Shape;
	import flash.display.Sprite;
	
	
	/**
	 * A TileGroup is a group of tiles which are grouped together to form one object
	 * that the tile engine can process faster and more easily.
	 */
	public class TileGroup
	{
		//-----------------------------------------------------------------------------------------
		// Properties
		//-----------------------------------------------------------------------------------------
		
		/**
		 * Unique number ID of the tilegroup.
		 */
		public var id:int;
		
		/**
		 * The x position of the tilegroup on the tilemap.
		 */
		public var x:int;
		
		/**
		 * The y position of the tilegroup on the tilemap.
		 */
		public var y:int;
		
		/**
		 * The width of the tilegroup.
		 */
		public var width:int;
		
		/**
		 * The height of the tilegroup.
		 */
		public var height:int;
		
		/**
		 * The x position of the group's right edge.
		 */
		public var right:int;
		
		/**
		 * The y position of the group's bottom edge.
		 */
		public var bottom:int;
		
		/**
		 * Determines if the tilegroup has been placed in the scroll container.
		 * @private
		 */
		public var placed:Boolean;
		
		/**
		 * Determines if this tilegroup has been moved to the coordinate on a wrapped area.
		 * @private
		 */
		public var wrapped:Boolean;
		
		/**
		 * Used to temporarily store the horizontal wrapping offset for this tilegroup.
		 * @private
		 */
		public var offsetH:int;
		
		/**
		 * Used to temporarily store the vertical wrapping offset for this tilegroup.
		 * @private
		 */
		public var offsetV:int;
		
		/**
		 * The wrapper symbol that contains all sub-tiles and the bounding box.
		 * @private
		 */
		public var symbol:Sprite;
		
		/**
		 * Holds the bounding box of the tile group. Used for debugging.
		 * @private
		 */
		public var boundingBox:Shape;
		
		/**
		 * The number of tiles contained in the tilegroup.
		 * @private
		 */
		public var tileCount:int;
		
		/**
		 * A vector of Tile objects which are part of this TileGroup.
		 * @private
		 */
		public var tiles:Vector.<Tile>;
		
		
		//-----------------------------------------------------------------------------------------
		// Constructor
		//-----------------------------------------------------------------------------------------
		
		/**
		 * Creates a new instance of the class.
		 */
		public function TileGroup()
		{
			tiles = new Vector.<Tile>();
			tileCount = 0;
			placed = false;
		}
		
		
		//-----------------------------------------------------------------------------------------
		// Public Methods
		//-----------------------------------------------------------------------------------------
		
		/**
		 * Adds a tile to the tilegroup.
		 */
		public function addTile(tile:Tile):void
		{
			tiles.push(tile);
			tileCount++;
		}
		
		
		/**
		 * Disposes the tilegroup.
		 */
		public function dispose():void
		{
			for each (var t:Tile in tiles)
			{
				if (t.bitmap)
				{
					t.bitmap.bitmapData.dispose();
					t.bitmap.bitmapData = null;
					t.bitmap = null;
				}
			}
			boundingBox = null;
			symbol = null;
			
			if (wrapped)
			{
				x -= offsetH;
				y -= offsetV;
				right -= offsetH;
				bottom -= offsetV;
				wrapped = false;
			}
		}
		
		
		/**
		 * Returns a String Representation of the class.
		 * 
		 * @return A String Representation of the class.
		 */
		public function toString():String
		{
			return "[TileGroup, id=" + id + "\ttiles=" + tiles.length + "\t x=" + x + "\t y=" + y
				+ "\t w=" + width + "\t h="+ height + "]";
		}
		
		
		//-----------------------------------------------------------------------------------------
		// Getters & Setters
		//-----------------------------------------------------------------------------------------
		
		
		
		
		//-----------------------------------------------------------------------------------------
		// Event Handlers
		//-----------------------------------------------------------------------------------------
		
		
		
		
		//-----------------------------------------------------------------------------------------
		// Private Methods
		//-----------------------------------------------------------------------------------------
		
		
	}
}
