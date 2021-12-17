package;

import StringTools;
import Xml;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.ui.FlxInputText;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import openfl.net.FileReference;

using StringTools;

#if sys
import sys.io.File;
#end

class PlayState extends FlxState
{
	var page1:Map<String, FlxSprite> = [];
	var animations:Array<SpriteSection> = [];

	// var tabSelection:Array<FlxInputText> = [];
	// var inputFocus:Int = 0;

	override public function create()
	{
		super.create();
		page1.set("pngPathInput", new FlxInputText(0, 100, 150));
		page1.set("WidthInput", new FlxInputText(160, 100, 25));
		page1.set("HeightInput", new FlxInputText(200, 100, 25));
		page1.set("ColInput", new FlxInputText(250, 100, 25));
		page1.set("AnimationNameInput", new FlxInputText(400, 100, 200));

		page1.set("AnimationNamesDisplay", new FlxText(150, 200, 400, ""));
		page1.set("ConfirmButton", new FlxButton(150, 150, "Confirm", createSheet));
		page1.set("AddAnimationButton", new FlxButton(450, 150, "Add Animation", addAnimation));
		page1.set("text0", new FlxText(0, 80, 0, "Png Path"));
		page1.set("text1", new FlxText(160, 80, 0, "Width"));
		page1.set("text2", new FlxText(200, 80, 0, "Height"));
		page1.set("text3", new FlxText(250, 80, 0, "Number of columns"));
		page1.set("text4", new FlxText(400, 80, 0, "Animation names"));
		for (value in page1)
		{
			add(value);
		}
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}

	function createSheet()
	{
		var width:Int = Std.parseInt(cast(page1["WidthInput"], FlxInputText).text);
		var height:Int = Std.parseInt(cast(page1["HeightInput"], FlxInputText).text);
		var numberOfColumns:Int = Std.parseInt(cast(page1["ColInput"], FlxInputText).text);
		var imagePath:String = cast(page1["pngPathInput"], FlxInputText).text;
		var a = "";
		a += "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n";

		a += "<TextureAtlas imagePath=\"" + imagePath + ".png\">\n";

		var index:Int = 0;
		for (anim in animations)
		{
			for (i in 0...anim.framesNumber)
			{
				var num:String = Std.string(i);
				while (num.length < 4)
				{
					num = "0" + num;
				}
				a += "\t<SubTexture name=\"" + anim.name + num + "\" x=\"" + (index % numberOfColumns) * width + "\" y=\""
					+ Std.int(index / numberOfColumns) * height + "\" width=\"" + width + "\" height=\"" + height
					+ "\" frameX=\"0\" frameY=\"0\" frameWidth=\"" + width + "\" frameHeight=\"" + height + "\"/>\n";
				index++;
			}
		}
		a += "</TextureAtlas>\n";

		var file = new FileReference();
		file.save(a, imagePath + ".xml");
	}

	function addAnimation()
	{
		var animInput = Std.downcast(page1["AnimationNameInput"], FlxInputText);
		var animNameDisplay = Std.downcast(page1["AnimationNamesDisplay"], FlxText);
		var arr:Array<String> = animInput.text.split(",");
		arr[0] = arr[0].trim();
		arr[1] = arr[1].trim();
		trace(arr[0] + "," + arr[1]);
		trace(Std.parseInt(arr[1]));
		new SpriteSection(arr[0], Std.parseInt(arr[1]));
		animations.push(new SpriteSection(arr[0], Std.parseInt(arr[1])));
		animNameDisplay.text += " (" + arr[0] + "," + arr[1] + ")";
		animInput.text = "";
	}
}

class SpriteSection
{
	public var name:String = '';
	public var framesNumber:Int = 0;

	public function new(thisName:String, thisFrames:Int)
	{
		name = thisName;
		framesNumber = thisFrames;
	}
}
