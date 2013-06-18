/*
 Copyright (c) 2013 Imrahil Corporation, All Rights Reserved
 @author   Jarek Szczepanski
 @contact  imrahil@imrahil.com
 @project  Morse Code Generator
 @internal
 */
package com.imrahil.bbapps.morsegenerator.views
{
    import com.imrahil.bbapps.morsegenerator.utils.TextFormatUtil;

    import org.osflash.signals.Signal;

    import qnx.fuse.ui.core.Container;
    import qnx.fuse.ui.core.SizeOptions;
    import qnx.fuse.ui.events.SliderEvent;
    import qnx.fuse.ui.layouts.Align;
    import qnx.fuse.ui.layouts.gridLayout.GridData;
    import qnx.fuse.ui.layouts.gridLayout.GridLayout;
    import qnx.fuse.ui.slider.Slider;
    import qnx.fuse.ui.slider.VolumeSlider;
    import qnx.fuse.ui.text.Label;
    import qnx.system.AudioManager;
    import qnx.system.AudioOutput;

    public class SettingsView extends TitlePage
    {
        public var volumeSlider:VolumeSlider;
        public var speedSlider:Slider;

        public var volumeSliderSignal:Signal = new Signal(Number);
        public var speedSliderSignal:Signal = new Signal(int);

        public var viewAddedSignal:Signal = new Signal();

        public function SettingsView()
        {
            super();

            title = "Settings";
        }

        override protected function onAdded():void
        {
            super.onAdded();

            var container:Container = new Container();
            var layout:GridLayout = new GridLayout();
            layout.paddingLeft = 50;
            layout.paddingRight = 50;
            layout.paddingTop = 50;
            layout.paddingBottom = 50;
            container.layout = layout;

            var containerData:GridData = new GridData();
            containerData.hAlign = Align.BEGIN;
            containerData.vAlign = Align.BEGIN;
            containerData.setOptions(SizeOptions.RESIZE_BOTH);
            container.layoutData = containerData;

            var infoLabel:Label;

            infoLabel = new Label();
            infoLabel.text = "Volume:";
            infoLabel.format = TextFormatUtil.setFormat(infoLabel.format);
            container.addChild(infoLabel);

            var sliderLayoutData:GridData = new GridData();
            sliderLayoutData.marginTop = 30;
            sliderLayoutData.marginBottom = 100;
            sliderLayoutData.hAlign = Align.FILL;
            sliderLayoutData.vAlign = Align.END;

            volumeSlider = new VolumeSlider();
            volumeSlider.minimum = 0;
            volumeSlider.maximum = 100;
            volumeSlider.layoutData = sliderLayoutData;

            CONFIG::device
            {
                volumeSlider.value = AudioManager.audioManager.getOutputLevel(AudioOutput.SPEAKERS);
            }

            CONFIG::debugMode
            {
                volumeSlider.value = 50;
            }

            volumeSlider.addEventListener(SliderEvent.MOVE, onVolumeSliderMove);
            container.addChild(volumeSlider);

            infoLabel = new Label();
            infoLabel.text = "Play speed:";
            infoLabel.format = TextFormatUtil.setFormat(infoLabel.format);
            container.addChild(infoLabel);

            speedSlider = new Slider();
            speedSlider.minimum = 0;
            speedSlider.maximum = 9;
            speedSlider.addEventListener(SliderEvent.MOVE, onSpeedSliderMove);
            speedSlider.layoutData = sliderLayoutData;
            container.addChild(speedSlider);

            content = container;

            viewAddedSignal.dispatch();
        }

        private function onVolumeSliderMove(event:SliderEvent):void
        {
            volumeSliderSignal.dispatch(event.value);
        }

        private function onSpeedSliderMove(event:SliderEvent):void
        {
            speedSliderSignal.dispatch(Math.round(event.value));
        }
    }
}
