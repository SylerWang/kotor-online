package packages.characters
{
	public class NPC extends Object
	{
		public function NPC()
		{
			super();
		}
		
		public static function getNPCByEncounterID(id:int):Character
		{
			var character: Character;
			switch(id)
			{
				case 1:
				{
					character = new Character(Classes.SCOUNDREL, false);
					character.characterName = "Atton";
					character.gender = Gender.MALE;
					character.race = Race.HUMAN;
					character.origin = Origins.MERCENARY;
					character.dialog = 1;//TO DO
					//character.activeWeapon = Weapon.LIGHTSABER;
					return character;
				}
				case 100:
				{
					character = new Character(Classes.OFFICER, false);
					character.characterName = "Placeholder";
					character.gender = Gender.FEMALE;
					character.race = Race.SITH;
					character.origin = Origins.CORE;
					return character;
				}
			}
			return null;
		}
	}
}