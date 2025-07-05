package funkin.vis;

/**
 * Represents a currently playing audio clip
 */
interface AudioClip
{
    public var audioSource(default, null):Dynamic;
    public var audioBuffer(default, null):AudioBuffer;
    public var currentFrame(get, never):Int;
    public var streamed:Bool;
}
