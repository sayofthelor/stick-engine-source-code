package;

import haxe.ui.HaxeUIApp;
import haxe.ui.components.Button;
import haxe.ui.components.Label;
import haxe.ui.core.Component;
import haxe.ui.macros.ComponentMacros;
import sys.io.File;
import sys.io.Process;

class CrashDialog
{
	/*
		massive thanks to gedehari for the crash dialog code
	 */
	static final quotes:Array<String> = [
		"Oops.",
		"Not a fun day, I take it?",
		"Sorry to bring your funkin' to a halt.",
		"Also try Minecraft!",
		"Main.hx isn't supposed to hold this much.",
		"Flixel is wonderful.",
		"No controlly is cannoli.",
		"Not feeling it today, here's your error.",
		"Stream Kawai Sprite.",
		"Check for semicolons, kids.",
		"Class is screwed. Or maybe not, I don't know.",
		"How many headaches have you been through today?",
		"Don't null-ly reference your objects, y'all!"
	];

	public static function main()
	{
		var args:Array<String> = Sys.args();

		if (args[0] == null)
			Sys.exit(1);
		else
		{
			var path:String = args[0];
			var contents:String = File.getContent(path);
			var split:Array<String> = contents.split("\n");

			var app = new HaxeUIApp();

			app.ready(function()
			{
				var mainView:Component = ComponentMacros.buildComponent("assets/main-view.xml");
				app.addComponent(mainView);

				var messageLabel:Label = mainView.findComponent("message-label", Label);
				messageLabel.text = quotes[Std.random(quotes.length)] + "\nUnfortunately, Lore Engine has crashed.";
				messageLabel.percentWidth = 100;
				messageLabel.textAlign = "center";

				var callStackLabel:Label = mainView.findComponent("call-stack-label", Label);
				callStackLabel.text = "";
				for (i in 0...split.length - 4)
				{
					if (i == split.length - 5)
						callStackLabel.text += split[i];
					else
						callStackLabel.text += split[i] + "\n";
				}

				var crashReasonLabel:Label = mainView.findComponent("crash-reason-label", Label);
				crashReasonLabel.text = "";
				for (i in split.length - 3...split.length - 1)
				{
					if (i == split.length - 2)
						crashReasonLabel.text += split[i];
					else
						crashReasonLabel.text += split[i] + "\n";
				}

				mainView.findComponent("view-crash-dump-button", Button).onClick = function(_)
				{
					#if windows
					Sys.command("start", [path]);
					#elseif linux
					Sys.command("xdg-open", [path]);
					#end
				};

				mainView.findComponent("restart-button", Button).onClick = function(_)
				{
					#if windows
					new Process("Lore", []);
					#elseif linux
					new Process("./Lore", []);
					#end

					Sys.exit(0);
				};

				mainView.findComponent("close-button", Button).onClick = function(_)
				{
					Sys.exit(0);
				};

				app.start();
			});
		}
	}
}
