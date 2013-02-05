package
{		
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import mx.containers.Canvas;

	public class HeartAnimation extends Timer
	{
		public function HeartAnimation(canvas:Canvas, basex:Number, basey:Number, size:Number)
		{
			super( 1 );
			x = 0;
			base_point_x = basex;
			base_point_y = basey;
			heartSize = size;
			drawCanvas = canvas;
			lineColor = 0xffffff * Math.random();
			drawCanvas.graphics.lineStyle(lineThick, lineColor);
			ori_point1 = new Point( get_actual_x(0), get_actual_y(0) );
			ori_point2 = new Point( get_actual_x(0), get_actual_y(0) );
			addEventListener("timer", drawHeart);
			start();
		}
		
		private var drawCanvas:Canvas = null;
		private var lineColor:uint = 0xff0000;
		private var lineThick:uint = 10;
		private var heartSize:uint = 100;
		private var base_point_x:Number;
		private var base_point_y:Number;
		
		private var ori_point1:Point;
		private var ori_point2:Point;
		private var point1:Point = new Point();
		private var point2:Point = new Point();
		private var x:Number = 0;
		private var step:Number = 0.01;
		
		/**
		 * progress == 1, drawing upper area;
		 * progress == -1, drawing down area;
		 * progress == others, stop drawing;
		 */
		private var progress:int = 1;
		
		private function get_actual_x( x:Number ):Number{
			return base_point_x - x*heartSize;
		}
		private function get_actual_y( y:Number ):Number{
			return base_point_y - y*heartSize;
		}
		private function upper_func( x:Number ):Number{
			return Math.sqrt( 1 - Math.pow(Math.abs(x)-1, 2) );
		}
		private function down_func( x:Number ):Number{
			return -3 * Math.sqrt( 1 - Math.sqrt(Math.abs(x)/2) );
		}
		
		private function redraw():void{
			lineColor = 0xffffff * Math.random();
			drawCanvas.graphics.lineStyle(lineThick, lineColor);
			ori_point1.setTo( get_actual_x(0), get_actual_y(0) );
			ori_point2.setTo( get_actual_x(0), get_actual_y(0) );
		}
		

		private function drawHeart(event:TimerEvent):void{
			if( progress == 1 )
				drawUpperHeart();
			else if( progress == -1 )
				drawDownHeart();
			else
				stop();
		}
		
		private function drawUpperHeart():void {
			point1.setTo( get_actual_x(x), get_actual_y(upper_func(x)) );
			point2.setTo( get_actual_x(-1*x), get_actual_y(upper_func(-1*x)) );
			drawCanvas.graphics.moveTo( ori_point1.x, ori_point1.y );
			drawCanvas.graphics.lineTo( point1.x, point1.y );
			drawCanvas.graphics.moveTo( ori_point2.x, ori_point2.y );
			drawCanvas.graphics.lineTo( point2.x, point2.y );
			ori_point1.copyFrom( point1 );
			ori_point2.copyFrom( point2 );
			
			x += step;
			if( x > 2 ){
				progress = -1;
				x = 2;
			}
		}
		
		private function drawDownHeart():void {
			point1.setTo( get_actual_x(x), get_actual_y(down_func(x)) );
			point2.setTo( get_actual_x(-1*x), get_actual_y(down_func(-1*x)) );
			drawCanvas.graphics.moveTo( ori_point1.x, ori_point1.y );
			drawCanvas.graphics.lineTo( point1.x, point1.y );
			drawCanvas.graphics.moveTo( ori_point2.x, ori_point2.y );
			drawCanvas.graphics.lineTo( point2.x, point2.y );
			ori_point1.copyFrom( point1 );
			ori_point2.copyFrom( point2 );
			
			x -= step;
			if( x < 0 ){
				progress = 1;
				x = 0;
				redraw();
			}
		}
		
	}
}