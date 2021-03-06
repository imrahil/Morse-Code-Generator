/*
 Copyright (c) 2013 Imrahil Corporation, All Rights Reserved
 @author   Jarek Szczepanski
 @contact  imrahil@imrahil.com
 @project  Morse Code Generator
 @internal
 */
package
{
    import com.imrahil.bbapps.morsegenerator.MorseCodeGeneratorContext;

    import flash.display.Sprite;

    import mx.logging.Log;
    import mx.logging.LogEventLevel;
    import mx.logging.targets.TraceTarget;

    public class MorseCodeGenerator extends Sprite
    {
        protected var _context:MorseCodeGeneratorContext;

        public function MorseCodeGenerator()
        {
            CONFIG::debugMode
            {
                var logTarget:TraceTarget = new TraceTarget();
                logTarget.level = LogEventLevel.ALL;
                logTarget.includeDate = true;
                logTarget.includeTime = true;
                logTarget.includeCategory = true;
                logTarget.includeLevel = true;
                Log.addTarget(logTarget);
            }

            _context = new MorseCodeGeneratorContext(this);
        }
    }
}
