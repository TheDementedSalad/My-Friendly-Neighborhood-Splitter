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
	vars.Helper.Settings.CreateFromXml("Components/MFN.Settings.xml");
	
	vars.DoorSkips = new List<string>() {"MainMenu", "BackToMenuScene"};
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
	// this function is a helper for checking splits that may or may not exist in settings,
	// and if we want to do them only once
	vars.CheckSplit = (Func<string, bool>)(key => {
		// if the split doesn't exist, or it's off, or we've done it already
		if (!settings.ContainsKey(key)
		  || !settings[key]
		  || vars.completedSplits.Contains(key)
		) {
			return false;
		}

		vars.completedSplits.Add(key);
		vars.Log("Completed: " + key);
		return true;
	});
}

update
{
	current.activeScene = vars.Helper.Scenes.Active.Name ?? current.activeScene;
	current.loadingScene = vars.Helper.Scenes.Loaded[0].Name ?? current.loadingScene;
}

onStart 
{
	vars.completedSplits.Clear();
}

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
	if (old.loadingScene != current.loadingScene)
	{
		if (settings["Door"] && !vars.DoorSkips.Contains(current.loadingScene) && !vars.DoorSkips.Contains(old.loadingScene))
		{
			return true;
		}

		if (settings["DoorC"] && vars.CheckSplit(current.loadingScene))
		{
			return true;
		}

		if (current.loadingScene == "EndingA" || current.loadingScene == "EndingB || current.loadingScene == "EndingC || current.loadingScene == "EndingD")
		{
			return true;
		}
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
