package com.math
{
	import flash.geom.Vector3D;
	
	public final class Nurbs
	{
		public function Nurbs()
		{
		}
		
		//Function that calculates a point on a Nurbs curve…
		public static function nurbs(p : Number, controlPoints : Vector.<Vector3D>, degreeParam : uint = 3, orderParam : int = -1) : Vector3D {
			
			var cp : uint = controlPoints.length;
			var degree : uint = degreeParam < 1 ? 1 : degreeParam > cp ? cp : degreeParam;
			var order : uint = orderParam == -1 ? degree + 1 : orderParam < 0 ? degree + 1 : orderParam > degree + 1 ? degree + 1 : orderParam;
			var totalKnots : uint = cp + degree + 1;
			
			var i : uint;
			var j : uint;
			var baseVector : Vector.<Number> = new Vector.<Number>();
			var knotsVector : Vector.<Number> = new Vector.<Number>();
			var recursion : uint;
			var output : Vector3D = new Vector3D();
			var f : Number;
			var g : Number;
			var rangoFinal : Number;
			var t : Number;
			
			i = 0;
			while(i < order) {
				knotsVector[i] = 0;
				i += 1;
			}
			
			i = order;
			while(i < cp) {
				//knotsVector.push(i – order + 1);
				knotsVector.push(i - order + 1);
				i += 1;
			}
			
			i = cp;
			while(i < totalKnots) {
				//knotsVector.push(cp – order + 1);
				knotsVector.push(cp - order + 1);
				i += 1;
			}
			var data : Number = 1;
			rangoFinal = knotsVector[cp + 1];
			t = p * (rangoFinal);
			
			//Generate the Basis Functions…
			i = 0;
			//recursion = totalKnots – 1;
			recursion = totalKnots - 1;
			while(i < recursion) {
				baseVector[i] = (knotsVector[i] <= t && t <= knotsVector[i + 1] && knotsVector[i] < knotsVector[i + 1]) ? 1 : 0;
				i += 1;
			}
			recursion -= 1;
			j = 1;
			while(j <= degree) {
				i = 0;
				while(i < recursion) {
					//f = knotsVector[i + j] – knotsVector[i];
					f = knotsVector[i+j] - knotsVector[i];
					//g = (knotsVector[i + j + 1] – knotsVector[i + 1]);
					g = knotsVector[i + j + 1] - knotsVector[i + 1];
					//f = f != 0 ? (t – knotsVector[i]) / f : 0;
					f = f != 0 ? (t - knotsVector[i]) / f : 0;
					//g = g != 0 ? (knotsVector[i + j + 1] – t) / g : 0;
					g = g != 0 ? (knotsVector[i + j + 1] - t) / g : 0;
					baseVector[i] = f * baseVector[i] + g * baseVector[i + 1];
					i += 1;
				}
				if(p == data) {
					var exit : String = "";
					for(var u : uint = 0;u < recursion; u++) {
						exit += baseVector[u] + ",";
					}
				}
				j += 1;
				recursion -= 1;
			}
			
			//Calculate the Rational points…
			i = 0;
			var divider : Number = 0;
			while(i < cp) {
				output.x += baseVector[i] * controlPoints[i].x;// * controlPoints[i].w;
				output.y += baseVector[i] * controlPoints[i].y;// * controlPoints[i].w;
				output.z += baseVector[i] * controlPoints[i].z;// * controlPoints[i].w;
				divider += baseVector[i];// * controlPoints[i].w;
				i += 1;
			}
			
			output.x /= divider;
			output.y /= divider;
			output.z /= divider;
			return output;
		}
	}
}