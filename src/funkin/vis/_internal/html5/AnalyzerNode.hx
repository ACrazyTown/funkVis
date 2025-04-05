package funkin.vis._internal.html5;

import flixel.FlxG;
import funkin.vis.AudioClip;
import funkin.vis.AudioBuffer;
#if lime_howlerjs
import lime.media.howlerjs.Howl;
import lime.media.howlerjs.Howler;
import js.html.audio.AnalyserNode as AnalyseWebAudio;
#end

// note: analyze and analyse are both correct spellings of the word, 
// but "AnalyserNode" is the correct class name in the Web Audio API
// and we use the Z variant here...
class AnalyzerNode
{   
    #if lime_howlerjs
    public var analyzer:AnalyseWebAudio;
    public var maxDecibels:Float = -30;
    public var minDecibels:Float = -100;
    public var fftSize:Int = 2048;
    var howl:Dynamic;
    var ctx:Dynamic;
    #end

    var audioClip:AudioClip;

    // #region yoooo
    public function new(?audioClip:AudioClip)
    {
        trace("Loading audioClip");
        this.audioClip = audioClip;

        #if lime_howlerjs
        howl = audioClip.source;
        ctx = howl._sounds[0]._node.context;

        analyzer = new AnalyseWebAudio(ctx);
        reconnectAnalyzer(audioClip);

        howl.on("play", (e) ->
        {
            reconnectAnalyzer(audioClip);
        });

        // trace(node.bufferSource);
        // untyped console.log(node);

        // analyzer = new AnalyseWebAudio(audioClip.source._sounds[0]._node.context);
        // audioClip.source._sounds[0]._node.connect(analyzer);

        // trace(audioClip.source._sounds[0]._node.context.sampleRate);
        // trace(analyzer);
        // trace(analyzer.fftSize);
        // howler = cast buffer.source;
        // trace(howler);
        getFloatFrequencyData();
        #end
    }

    public function getFloatFrequencyData():Array<Float>
    {
        #if lime_howlerjs
        var array:js.lib.Float32Array = new js.lib.Float32Array(analyzer.frequencyBinCount);
        analyzer.fftSize = fftSize;
        analyzer.minDecibels = minDecibels;
        analyzer.maxDecibels = maxDecibels;
        analyzer.getFloatFrequencyData(array);
        return cast array;
        #end
        return [];
    }

    function reconnectAnalyzer(audioClip:AudioClip):Void
    {
        var gainNode = howl._sounds[0]._node;
        var bufferSrc = gainNode.bufferSource;

        // Disconnect everything from the gain node
        gainNode.disconnect();

        if (bufferSrc != null)
        {
            // Disconnect everything from the audio source
            bufferSrc.disconnect();

            // Disconnect our analyzer from any previous leftovers
            analyzer.disconnect();

            // Connect the buffer source directly to the analyzer
            // This way we can the analyzer can get audio data
            // that's not affected by the volume
            bufferSrc.connect(analyzer);

            // Connect the analyzer to the gain node
            analyzer.connect(cast gainNode);
        }
        else 
        {
            // If we can't get the bufferSource, let's try to fall back
            // to the old method of attaching the analyzer to the gain node.
            analyzer.disconnect();
            gainNode.connect(analyzer);
        }

        // Connect the gain node back to the destination
        gainNode.connect(ctx.destination);
    }
}
