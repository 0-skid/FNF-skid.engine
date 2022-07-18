package ui;

import openfl.Lib;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxCamera;
import flixel.util.FlxColor;
import haxe.ds.StringMap;

class PreferencesMenu extends Page
{
	public static var preferences:StringMap<Dynamic> = new StringMap<Dynamic>();

	var checkboxes:Array<CheckboxThingie> = [];
	var menuCamera:FlxCamera;
	var items:TextMenuList;
	var camFollow:FlxObject;

	override public function new()
	{
		super();
		menuCamera = new FlxCamera();
		FlxG.cameras.add(menuCamera, false);
		menuCamera.bgColor = FlxColor.TRANSPARENT;
		camera = menuCamera;
		add(items = new TextMenuList());
		createPrefItem('Flashing', 'flashing-menu', '', true);
		createPrefItem('Camera Bop', 'camera-zoom', '', true);
		createPrefItem('Show FPS', 'fps-counter', '', true);
		createPrefItem('Auto Pause', 'auto-pause', '', true);
		createPrefItem('Watermark Text', 'watermark', '', false);
		createPrefItem('Downscroll', 'downscroll', '', false);
		createPrefItem('Middlescroll', 'middlescroll', '', false);
		createPrefItem('Ghost Tapping', 'ghost', '', false);
		camFollow = new FlxObject(FlxG.width / 2, 0, 240, 70);
		if (items != null)
		{
			camFollow.y = items.members[items.selectedIndex].y;
		}
		menuCamera.follow(camFollow, null, 0);
		menuCamera.deadzone.set(0, 160, menuCamera.width, 40);
		items.onChange.add(function(item:TextMenuItem)
		{
			camFollow.y = item.y - 200;
		});
	}

	public static function getPref(pref:String)
	{
		return preferences.get(pref);
	}

	public static function initPrefs()
	{
		preferenceCheck('flashing-menu', true);
		preferenceCheck('camera-zoom', true);
		preferenceCheck('fps-counter', true);
		preferenceCheck('auto-pause', true);
		preferenceCheck('watermark', true);
		preferenceCheck('downscroll', false);
		preferenceCheck('middlescroll', false);
		preferenceCheck('ghost', false);
		preferenceCheck('master-volume', 1);
		if (!getPref('fps-counter'))
		{
			Lib.current.stage.removeChild(Main.fpsCounter);
		}
		FlxG.autoPause = getPref('auto-pause');
	}

	public static function preferenceCheck(identifier:String, defaultValue:Dynamic)
	{
		if (preferences.get(identifier) == null)
		{
			preferences.set(identifier, defaultValue);
			trace('set preference!');
		}
		else
		{
			trace('found preference: ' + Std.string(preferences.get(identifier)));
		}
	}

	public function createPrefItem(label:String, identifier:String, type:String, value:Dynamic)
	{
		items.createItem(120, 120 * items.length + 30, label, Bold, function()
		{
			preferenceCheck(identifier, value);
			if (Type.typeof(value) == TBool)
			{
				prefToggle(identifier);
			}
			else
			{
				trace('swag');
			}
		});
		if (Type.typeof(value) == TBool)
		{
			createCheckbox(identifier);
		}
		else
		{
			trace('swag');
		}
		trace(Type.typeof(value));
	}

	public function createCheckbox(identifier:String)
	{
		var box:CheckboxThingie = new CheckboxThingie(0, 120 * (items.length - 1), preferences.get(identifier));
		checkboxes.push(box);
		add(box);
	}

	public function prefToggle(identifier:String)
	{
		var value:Bool = preferences.get(identifier);
		value = !value;
		preferences.set(identifier, value);
		checkboxes[items.selectedIndex].daValue = value;
		trace('toggled? ' + Std.string(preferences.get(identifier)));
		switch (identifier)
		{
			case 'auto-pause':
				FlxG.autoPause = getPref('auto-pause');
			case 'fps-counter':
				if (getPref('fps-counter'))
					Lib.current.stage.addChild(Main.fpsCounter);
				else
					Lib.current.stage.removeChild(Main.fpsCounter);
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		menuCamera.followLerp = CoolUtil.camLerpShit(0.1);
		items.forEach(function(item:MenuItem)
		{
			item.x = 120;
		});
	}
}