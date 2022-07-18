package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import lime.app.Application;

class CreditsState extends MusicBeatState
{
    override function create()
    {

        var bg:FlxSprite = new FlxSprite(null, null, Paths.image('menuDesat'));
	    bg.scrollFactor.x = bg.scrollFactor.x;
	    bg.scrollFactor.y = bg.scrollFactor.y;
	    bg.updateHitbox();
	    bg.visible = true;
	    bg.antialiasing = true;
	    bg.color = 0xFF9a42ff;
        add(bg);

        var creditsFile = Assets.getText(Paths.txt('credits'));

        var creditsText:FlxText = new FlxText(0, 20, FlxG.width, creditsFile, 12);
	    creditsText.scrollFactor.set();
	    creditsText.setFormat("VCR OSD Mono", 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	    add(creditsText);
    }

    override function update(elapsed:Float)
    {
        if (controls.BACK)
		{
			FlxG.sound.play(Paths.sound("cancelMenu"));
			FlxG.switchState(new MainMenuState());
		}
    }
}
