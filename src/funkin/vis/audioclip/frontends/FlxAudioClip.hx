package funkin.vis.audioclip.frontends;

import flixel.sound.FlxSound;

class FlxAudioClip extends LimeAudioClip
{
    public function new(sound:FlxSound)
    {
        @:privateAccess
        super(
            #if (openfl < "9.3.2") 
            sound._channel.__source 
            #else 
            sound._channel.__audioSource 
            #end
        );
    }
}
