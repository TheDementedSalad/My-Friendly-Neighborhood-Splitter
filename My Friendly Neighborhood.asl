// My Friendly Neighbourhood Autosplitter Version 1.0 (21/07/23)
// Supports Door Splits
// Supports IGT
// Splits can be obtained from -
// Script by TheDementedSalad & Nikoheart
// Special thanks to:
// Ero - Creation of asl-help
// Nikoheart - Provided help in creating the door splitter & helping me relearn how to make these

state("My Friendly Neighborhood")
{}

startup
{
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
    vars.Helper.GameName = "My Friendly Neighborhood";
    vars.Helper.LoadSceneManager = true;
    vars.Helper.AlertLoadless();
	
	vars.DoorSkips = new List<string>()
	{"MainMenu","BackToMenuScene"};
	
	settings.Add("Door", false, "Door Splitter");
}

init
{
    vars.Helper.TryLoad = (Func<dynamic, bool>)(mono => 
    {
		var inv = mono["InventoryInWorld"]; 						
		var invm = mono["InventoryManager"]; 
		var sav = mono["SaveData"];
        var spd = mono["SpeedrunData"];								//Information about the games Speedrun mode
                
        vars.Helper["Time"] = spd.Make<float>("timer");				//The games speedrun timer as a float
		vars.Helper["Fin"] = spd.Make<bool>("finished");			//Bool that tracks when the game is complete?
		
		
        return true;
    });
}

update
{
    current.activeScene = vars.Helper.Scenes.Active.Name == null ? current.activeScene : vars.Helper.Scenes.Active.Name;			//creates a function that tracks the games active Scene name
    current.loadingScene = vars.Helper.Scenes.Loaded[0].Name == null ? current.loadingScene : vars.Helper.Scenes.Loaded[0].Name;	//creates a function that tracks the games currently loading Scene name
}

onStart 
{}

onSplit
{}

onReset
{}

start
{
     return current.Time > 0f && old.Time == 0f;
}

split
{    
	if(settings["Door"]){
		if(current.activeScene != old.activeScene && !vars.DoorSkips.Contains(current.activeScene) && !vars.DoorSkips.Contains(old.activeScene)){
			return true;
		}
	}
	
	if(current.Fin && !old.Fin){
		return true;
	}
}

gameTime
{
    return TimeSpan.FromSeconds(current.Time);
}

isLoading
{
    return true;
}

reset
{
	return current.Time == 0f && current.activeScene == "IntroScene";
}
