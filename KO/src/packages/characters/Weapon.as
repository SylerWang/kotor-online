package packages.characters
{
	import away3d.animators.SkeletonAnimator;
	import away3d.animators.data.JointPose;
	import away3d.animators.data.Skeleton;
	import away3d.animators.data.SkeletonJoint;
	import away3d.animators.data.SkeletonPose;
	import away3d.core.base.SubMesh;
	import away3d.entities.JointObject;
	import away3d.entities.Mesh;
	import away3d.tools.SkeletonTools;
	
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import sunag.sea3d.SEA3D;

	public class Weapon extends Object
	{
		public static const UNDEFINED:int=0;
		public static const LIGHTSABER:int=11;
		public static const DUAL_LIGHTSABER:int=12;
		public static const SABERSTAFF:int=13;
		
		public static const BLADE:int=100;
		public static const RED:int=101;
		public static const BLUE:int=102;
		public static const GREEN:int=103;
		
		public function Weapon()
		{
			 return;
		}
		
		public static function weaponString( value:int): String
		{
			switch( value)
			{
				case LIGHTSABER:
				{
					return "lightsaber";
				}
				case DUAL_LIGHTSABER:
				{
					return "dual_lightsaber";
				}
				case SABERSTAFF:
				{
					return "saberstaff";
				}
			}
			return null;
		}
		
		public static function weaponValue( string: String):int
		{
			switch( string)
			{
				case "lightsaber":
				{
					return LIGHTSABER;
				}
				case "dual_lightsaber":
				{
					return DUAL_LIGHTSABER;
				}
				case "saberstaff":
				{
					return SABERSTAFF;
				}
			}
			return UNDEFINED;
		}
		
		public static function bladeString( value:int): String
		{
			switch( value)
			{
				case RED:
				{
					return "red";
				}
				case BLUE:
				{
					return "blue";
				}
				case GREEN:
				{
					return "green";
				}
			}
			return null;
		}
		
		public static function setWeapon(character: Character, weapon:int, color:int=0): void
		{
			//get weapon sea file
			var string: String = "weapon_" + weaponString(weapon);
			for( var i:int=0;i<Main.sea3dResourcesString.length;i++)
				if(Main.sea3dResourcesString[i] == string)
					var sea3dWeapon:SEA3D = Main.sea3dResources[i];
			
			//set weapon as mesh clone
			character.weaponMesh = sea3dWeapon.getMesh(string).clone() as Mesh;
			character.weaponMesh.scale = new Vector3D(1,1,1);
			
			if(character.weaponMesh)
			{
				//add weapon to  scene
				Main.away3dView.scene.addChild(character.weaponMesh);
				
				//get ready for gender and hand
				var prefix: String = Gender.genderString(character.gender).toLowerCase();
				var jointName: String = prefix + "_rhand";
				
				// manual pose update
				SkeletonTools.poseFromSkeleton(SkeletonAnimator(character.characterClass.animator).globalPose, SkeletonAnimator(character.characterClass.animator).skeleton);
				
				//create weapon joint object and add weapon to joint
				character.weaponJointObject = JointObject.fromName(character.characterClass, jointName, true).clone() as JointObject;
				character.weaponJointObject.addChild(character.weaponMesh);
				
				//set position and rotation of  weapon relative to hand
				var jointIndex:int = SkeletonAnimator(character.characterClass.animator).skeleton.jointIndexFromName(jointName);
				var pose:SkeletonPose = SkeletonAnimator(character.characterClass.animator).globalPose;
				character.weaponMesh.position = new Vector3D(pose.jointPoses[jointIndex].translation.x,pose.jointPoses[jointIndex].translation.y,pose.jointPoses[jointIndex].translation.z);
				//character.weaponMesh.rotation = new Vector3D(pose.jointPoses[jointIndex].orientation.x,pose.jointPoses[jointIndex].orientation.y,pose.jointPoses[jointIndex].orientation.z);
				
				// add joint object in character children
				character.characterClass.addChild(character.weaponJointObject);
				
				//if weapon is light saber
				if(weapon == LIGHTSABER)
				{
					//fix its relative position
					character.weaponMesh.position = character.weaponMesh.position.add( new Vector3D(-character.weaponMesh.position.x,-character.weaponMesh.position.y,-character.weaponMesh.position.z));
					
					//if light saber, but no explicit blade color, then randomize low to high
					if(color==0)	color = int(Main.STATES.randomNumber(RED,GREEN));
					setBlade(character,weapon,color);
					
					//TO DO handle light saber blade on/off
				}
			}
		}
		
		public static function setBlade(character: Character, weapon:int, color:int): void
		{
			for(var w:int=0;w<character.weaponMesh.numChildren;w++)
			{
				//get the blade first, that is the inner white  color of light saber
				var child:*=character.weaponMesh.getChildAt(w);
				if(child && child.name && child.name == "blade")
					 character.bladesArray[BLADE] = child as Mesh;
				if(child)
				{
					for(var t:int=0;t<child.numChildren;t++)
					{
						//get all the possible glow colors
						var grand:*=child.getChildAt(t);
						if(grand && grand.name && grand.name == "bladeglowred")
							character.bladesArray[RED] = grand as Mesh;
						if(grand && grand.name && grand.name == "bladeglowblue")
							character.bladesArray[BLUE] = grand as Mesh;
						if(grand && grand.name && grand.name == "bladeglowgreen")
							character.bladesArray[GREEN] = grand as Mesh;
					}
				}
			}
			
			//hide all blades
			for each ( var bladeColor: Mesh in character.bladesArray)
			{
				bladeColor.visible = false;
			}
			
			//show only the inner white blade and  its colored chosen glow
			character.bladesArray[BLADE].visible = true;
			character.bladesArray[color].visible = true;
		}
	}
}