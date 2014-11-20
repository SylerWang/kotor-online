package bootloader
{
    import flash.utils.*;
    
    public class YdMEXMzq extends Object
    {
        public function YdMEXMzq()
        {
            super();
            return;
        }

		public static function EncodeData(data : ByteArray) : String
		{
			var out : ByteArray = new ByteArray();
			//Presetting the length keep the memory smaller and optimize speed since there is no "grow" needed
			out.length = (2 + data.length - ((data.length + 2) % 3)) * 4 / 3; //Preset length //1.6 to 1.5 ms
			var i : int = 0;
			var r : int = data.length % 3;
			var len : int = data.length - r;
			var c : int;   //read (3) character AND write (4) characters
			
			while (i < len)
			{
				//Read 3 Characters (8bit * 3 = 24 bits)
				c = data[i++] << 16 | data[i++] << 8 | data[i++];
				
				//Cannot optimize this to read int because of the positioning overhead. (as3 bytearray seek is slow)
				//Convert to 4 Characters (6 bit * 4 = 24 bits)
				c = (_encodeChars[c >>> 18] << 24) | (_encodeChars[c >>> 12 & 0x3f] << 16) | (_encodeChars[c >>> 6 & 0x3f] << 8) | _encodeChars[c & 0x3f];
				
				//Optimization: On older and slower computer, do one write Int instead of 4 write byte: 1.5 to 0.71 ms
				out.writeInt(c);
				/*
				out.writeByte(_encodeChars[c >> 18] );
				out.writeByte(_encodeChars[c >> 12 & 0x3f]);
				out.writeByte(_encodeChars[c >> 6 & 0x3f]);
				out.writeByte(_encodeChars[c & 0x3f]);
				*/
			}
			
			if (r == 1) //Need two "=" padding
			{
				//Read one char, write two chars, write padding
				c = data[i];
				c = (_encodeChars[c >>> 2] << 24) | (_encodeChars[(c & 0x03) << 4] << 16) | 61 << 8 | 61;
				out.writeInt(c);
			}
			else if (r == 2) //Need one "=" padding
			{
				c = data[i++] << 8 | data[i];
				c = (_encodeChars[c >>> 10] << 24) | (_encodeChars[c >>> 4 & 0x3f] << 16) | (_encodeChars[(c & 0x0f) << 2] << 8) | 61;
				out.writeInt(c);
			}
			
			out.position = 0;
			return out.readUTFBytes(out.length);
		}
					
        public static function EncodeString(arg1:String):String
        {
            var loc1:*=new flash.utils.ByteArray();
            loc1.writeUTFBytes(arg1);
            return EncodeData(loc1);
        }
		
		public static function InitEncoreChar() : Vector.<int>
		{
			var encodeChars : Vector.<int> = new Vector.<int>();
			// We could push the number directly, but i think it's nice to see the characters (with no overhead on encode/decode)
			var chars : String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
			for (var i : int = 0; i < 64; i++)
			{
				encodeChars.push(chars.charCodeAt(i));
			}
			/*
			encodeChars.push(
			65, 66, 67, 68, 69, 70, 71, 72,
			73, 74, 75, 76, 77, 78, 79, 80,
			81, 82, 83, 84, 85, 86, 87, 88,
			89, 90, 97, 98, 99, 100, 101, 102,
			103, 104, 105, 106, 107, 108, 109, 110,
			111, 112, 113, 114, 115, 116, 117, 118,
			119, 120, 121, 122, 48, 49, 50, 51,
			52, 53, 54, 55, 56, 57, 43, 47);
			*/
			return encodeChars;
		}

		private static const _encodeChars : Vector.<int> = InitEncoreChar();
    }
}
