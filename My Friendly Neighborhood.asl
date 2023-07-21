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
	
	vars.DoorCSplits = new List<string>()
	{"Pearl's Rolodexer Room","Pearl's Sound Stage","Pearl's Sound Stage-MainBuildingInside","RaysMainAtrium","RaysFixinsRoom","Ray'sDocks4","Ray'sDocks2","GobblesOfficesEntrance","Gobbles Projection Room2","Gobbles Studio","Gobbles Bare Room Offices","Gobbles Art Storage","Gobbles Elevator Maintenance","GobblesOfficesEntrance-CEOOffice","Exterior-HedgeMaze","Exterior-GreenhouseInterior","Gobbles Sound Studio","RaysFilmArchives","PenthouseEntrance","Elmer's Two Side Room","PenthouseBackHall2","Exterior-Antenna","Unfriendly Neighborhood Proper"};
	
	vars.DoorCSettings = new List<string>()
	{"Rolodexer Room (Handgun Room)","Sound Stage (Town Square)","Stage Main Building (Middle Building)","Underground Atrium","Fixins Room (Power Source)","Dock 4","Dock 2 (Boltcutters)","Office Entrance","Theater Room","Studio (Game Piece)","Bare Room Office (Angry Mask)","Art Storage","Elevator Maintenence Room","CEO Office","Garden Maze","Greenhouse Interior","Sound Studio","Film Archives","Penthouse Entrance","Hexagonal Key Room","Penthouse Art Hall","Roof","Unfriendly Neighbourhood Arena"};
	
	settings.Add("Door", false, "Door Splitter - Splits On EVERY Door");
	
	settings.Add("DoorC", false, "Custom Door Splitter - Only Splits Once On Area");
	settings.CurrentDefaultParent = "DoorC";
	for(int i = 0; i < 23; i++){
        	settings.Add("" + vars.DoorCSplits[i].ToString(), false, "" + vars.DoorCSettings[i].ToString());
    	}
		settings.CurrentDefaultParent = null;
	
	settings.Add("Final", true, "Final Split - Always Active");
}

init
{
    vars.Helper.TryLoad = (Func<dynamic, bool>)(mono => 
    {
	var inv = mono["InventoryInWorld"]; 						
	var invm = mono["InventoryManager"]; 
	var sav = mono["SaveData"];
        var spd = mono["SpeedrunData"];						//Information about the games Speedrun mode
                
        vars.Helper["Time"] = spd.Make<float>("timer");				//The games speedrun timer as a float

        return true; 
    });

    vars.completedSplits = new List<string>();
}

update
{
    current.activeScene = vars.Helper.Scenes.Active.Name == null ? current.activeScene : vars.Helper.Scenes.Active.Name;		//creates a function that tracks the games active Scene name
    current.loadingScene = vars.Helper.Scenes.Loaded[0].Name == null ? current.loadingScene : vars.Helper.Scenes.Loaded[0].Name;	//creates a function that tracks the games currently loading Scene name
	
    if(timer.CurrentPhase == TimerPhase.NotRunning){
	vars.completedSplits.Clear();
    }
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
	
	if(settings["DoorC"])
		{
			for(int i = 0; i < 23; i++)
			{
				if(vars.DoorCSplits.Contains(current.activeScene) && !vars.completedSplits.Contains(current.activeScene) && settings[current.activeScene.ToString()])
				{
					vars.completedSplits.Add(current.activeScene);
					return true;
				}
			}
		}
	
	if(current.activeScene == "EndingA" && old.activeScene != "EndingA" || current.activeScene == "EndingB" && old.activeScene != "EndingB"){
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
