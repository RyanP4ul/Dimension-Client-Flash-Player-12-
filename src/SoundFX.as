// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//SoundFX

package 
{
    import flash.events.EventDispatcher;
    import flash.system.ApplicationDomain;
    import flash.media.SoundTransform;

    public class SoundFX extends EventDispatcher 
    {

        private var sfx:Object = {};
        public var stf:SoundTransform = new SoundTransform(0.7, 0);
        public var bSoundOn:Boolean = true;

        public function playSound(strSound:String):void
        {
            if (bSoundOn)
            {
                if (sfx[strSound] != null)
                {
                    sfx[strSound].play(0, 0, stf);
                }
                else
                {
                    try
                    {
                        var AssetClass:Class;

                        if (Game.root.params.domain.assetsDomain.hasDefinition(strSound))
                        {
                            AssetClass = (Game.root.params.domain.assetsDomain.getDefinition(strSound) as Class);
                            sfx[strSound] = new (AssetClass)();
                            sfx[strSound].play(0, 0, stf);
                        }
                        else if (Game.root.params.domain.soundEffectsDomain.hasDefinition(strSound))
                        {
                            AssetClass = (Game.root.params.domain.soundEffectsDomain.getDefinition(strSound) as Class);
                            sfx[strSound] = new (AssetClass)();
                            sfx[strSound].play(0, 0, stf);
                        }
                        else
                        {
                            trace((("SoundFX : Definition '" + strSound) + "' not found in assetsDomain"));
                        }
                    }
                    catch(e:Error)
                    {
                        trace("SoundFX Error: ");
                        trace(e);
                    }
                }
            }
        }

        public function soundOn():void
        {
            bSoundOn = true;
        }

        public function soundOff():void
        {
            bSoundOn = false;
        }


    }
}//package 

