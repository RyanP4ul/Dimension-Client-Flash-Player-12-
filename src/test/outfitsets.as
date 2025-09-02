// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//outfitsets

package test {
import fl.motion.AdjustColor;

import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.text.TextField;
import flash.events.MouseEvent;

import fl.motion.Color;

import flash.utils.getDefinitionByName;
import flash.filters.ColorMatrixFilter;

public class outfitsets extends MovieClip {

    public var btnLeft:SimpleButton;
    public var txtPage:TextField;
    public var highlighter:MovieClip;
    public var btnEquip:MovieClip;
    public var btnRight:SimpleButton;
    public var interfaceOutfitEdit:outfitedit;
    public var outfit:Outfit;
    private var game:Game;
    public var world:World;
    private var page:int = 0;
    private var pages:int;
    private var selected:int = -1;

    public function outfitsets(outfit:Outfit, game:Game) {
        this.outfit = outfit;
        this.game = game;
        this.world = game.world;
        this.initInterface();
    }

    public function initInterface():void {
        this.drawMenu();
        if (this.pages > 1) {
            if (!this.btnLeft.hasEventListener(MouseEvent.CLICK)) {
                this.btnLeft.addEventListener(MouseEvent.CLICK, this.onLeft, false, 0, true);
                this.btnRight.addEventListener(MouseEvent.CLICK, this.onRight, false, 0, true);
            }
            this.applyBrightness(this.btnLeft, 0);
            this.applyBrightness(this.btnRight, 0);
        } else {
            this.applyBrightness(this.btnLeft);
            this.applyBrightness(this.btnRight);
        }
        this.highlighter.mouseEnabled = false;
        this.btnEquip.addEventListener(MouseEvent.CLICK, this.onEquip, false, 0, true);
    }

    private function onOver(e:MouseEvent):void {
    }

    private function onOut(e:MouseEvent):void {
//            this.m.tt.close();
    }

    private function handleEmpty(val:String):int {
        return ((val == "") ? -1 : parseInt(val));
    }

    private function getItemByID(tID:int):* {
        var item:*;
        for each (item in this.outfit.pAV.items) {
            if (item.ItemID == tID) {
                return (item);
            }
        }
        return (null);
    }

    public function onEquip(e:MouseEvent):void {
        var equips:Object;
        if (this.selected != -1) {
//                if (!this.world.coolDown("equipLoadout"))
//                {
//                    this.m.slowDown();
//                    return;
//                }
            equips = this.outfit.sets[this.selected];
            this.game.net.send("equipLoadout", ["cmd", equips.name]);
            this.outfit.fClose();
        }
    }

    public function onWear(e:MouseEvent):void {
        var equips:Object;
        if (this.selected != -1) {
//                if (!this.world.coolDown("wearLoadout"))
//                {
//                    this.m.slowDown();
//                    return;
//                }
            equips = this.outfit.sets[this.selected];
            this.game.net.send("wearLoadout", [equips.name]);
//                this.m.onBack();
        }
    }

    public function applyBrightness(mc:*, brightness:int = 0):void {
        var color:Color = new Color();
        color.brightness = brightness;
        mc.transform.colorTransform = color;
    }

    public function onLeft(e:MouseEvent):void {
        this.page--;
        if (this.page < 0) {
            this.page = (this.pages - 1);
        }
        this.drawMenu();
    }

    public function onRight(e:MouseEvent):void {
        this.page++;
        if (this.page > (this.pages - 1)) {
            this.page = 0;
        }
        this.drawMenu();
    }

    public function btnMain():MovieClip {
        var AssetClass:Class = (getDefinitionByName("test.outfitbutton") as Class);
        return (new (AssetClass)() as MovieClip);
    }

    public function btnNew():MovieClip {
        var AssetClass:Class = (getDefinitionByName("test.newoutfitbutton") as Class);
        return (new (AssetClass)() as MovieClip);
    }

    public function btnUnlock():MovieClip {
        var AssetClass:Class = (getDefinitionByName("test.unlockoutfitbutton") as Class);
        return (new (AssetClass)() as MovieClip);
    }

    public function drawMenu():void {
        var mode:int;
        var tgt:*;
        var i:int = 5;
        while (i < this.numChildren) {
            if (this.getChildAt(i).name.indexOf("set_") != -1) {
                this.removeChild(this.getChildAt(i));
                i--;
            }
            i++;
        }
        this.highlighter.visible = false;
        this.selected = -1;
        this.setEnabled(this.btnEquip, false);
        this.outfit.sets.sortOn("name");
        this.pages = Math.ceil((this.outfit.slots / 7));
        var _x:int = 1.45;
        var _y:int = -124.35;
        var _main_gap:int = 55.55;
        var _new_gap:int = 5.2;
        var _unlock_gap:int = 40.15;
        var j:int = (this.page * 7);
        while (j < ((this.page * 7) + 7)) {
            if (this.outfit.sets[j]) {
                tgt = addChild((this.btnMain() as MovieClip));
                tgt.txtName.text = this.outfit.sets[j].name;
                tgt.txtName.mouseEnabled = false;
                tgt.btnMain.addEventListener(MouseEvent.CLICK, this.onEquipSet, false, 0, true);
                tgt.btnEdit.addEventListener(MouseEvent.CLICK, this.onEditSet, false, 0, true);
                tgt.btnDelete.addEventListener(MouseEvent.CLICK, this.onDeleteSet, false, 0, true);
                mode = 0;
            } else {
                if (j < outfit.slots) {
                    tgt = addChild((this.btnNew() as MovieClip));
                    tgt.addEventListener(MouseEvent.CLICK, this.onNewSet, false, 0, true);
                    mode = 1;
                } else {
                    tgt = addChild((this.btnUnlock() as MovieClip));
                    tgt.addEventListener(MouseEvent.CLICK, this.onUnlock, false, 0, true);
                    mode = 2;
                }
            }
            tgt.name = ("set_" + j);
            tgt.x = _x;
            if (j == (this.page * 7)) {
                tgt.y = _y;
            } else {
                switch (mode) {
                    case 0:
                        mode = _main_gap;
                        break;
                    case 1:
                        mode = _new_gap;
                        break;
                    case 2:
                        mode = _unlock_gap;
                        break;
                }
                tgt.y = ((getChildByName(("set_" + Number((j - 1)).toString())).y + getChildByName(("set_" + Number((j - 1)).toString())).height) + 5);
            }
            j++;
        }
        this.txtPage.text = (((this.page + 1) + " / ") + this.pages);
    }

    public function positionHighlighter(y:int):void {
        this.highlighter.visible = true;
        this.highlighter.x = -144.6;
        this.highlighter.y = (y - 17.5);
        this.setChildIndex(this.highlighter, (this.numChildren - 1));
    }

    public function onEquipSet(e:MouseEvent):void {
        var sES:*;
        var s_clrs:Array;
        var clr:*;
        var item:*;
        var clr_prop:String;
        this.positionHighlighter(e.currentTarget.parent.y);
        this.selected = parseInt(e.currentTarget.parent.name.slice(4));
        this.setEnabled(this.btnEquip, true);
        var missingItemCount:int = 0;
        var s_sES:Array = ["he", "ba", "ar", "co", "Weapon", "pe", "am", "mi"];
        var equips:Object = this.outfit.sets[this.selected];

        for each (sES in s_sES) {
            if (equips[sES] != null) {
                item = this.game.copyObj(this.getItemByID(equips[sES]));
                if (item) {
                    this.outfit.pAV.objData.eqp[sES] = item;
                    this.outfit.pAV.loadMovieAtES(sES, item.sFile, item.sLink);
                } else {
                    missingItemCount++;
                    delete this.outfit.pAV.objData.eqp[sES];
                    this.outfit.pAV.unloadMovieAtES(sES);
                }
            } else {
                delete this.outfit.pAV.objData.eqp[sES];
                this.outfit.pAV.unloadMovieAtES(sES);
            }
        }

        s_clrs = ["intColorHair", "intColorSkin", "intColorEye", "intColorBase", "intColorTrim", "intColorAccessory"];

        for each (clr in s_clrs) {
            clr_prop = clr.substr(8);
            clr_prop = (clr_prop.charAt(0).toLowerCase() + clr_prop.substr(1));
            if (equips.colors[clr_prop]) {
                this.outfit.pAV.objData[clr] = equips.colors[clr_prop];
            }
        }

        if (missingItemCount > 0) {
            this.game.MsgBox.notify((("Could not find " + missingItemCount) + " set item(s) in your inventory!"));
        }
    }

    public function setupEditor():void {
        this.outfit.addChild(this.interfaceOutfitEdit);
        this.interfaceOutfitEdit.x = 182.15;
        this.interfaceOutfitEdit.y = 167.8;
        this.visible = false;
    }

    public function onEditSet(e:MouseEvent):void {
        this.onEquipSet(e);
        this.interfaceOutfitEdit = new outfitedit(outfit, game, parseInt(e.currentTarget.parent.name.slice(4)));
        this.setupEditor();
    }

    public function onDeleteSet(e:MouseEvent):void {
//            if (!this.world.coolDown("removeLoadout"))
//            {
//                this.m.slowDown();
//                return;
//            }
        var setIndex:Number = parseInt(e.currentTarget.parent.name.slice(4));
        this.game.net.send("removeLoadout", [this.outfit.sets[setIndex].name]);
    }

    public function onServerResponseRemove(setName:String):void {
        var s:*;
        var i:int = 0;
        while (i < this.outfit.sets.length) {
            s = this.outfit.sets[i];
            if (s.name == setName) {
                this.outfit.sets.splice(i, 1);
                this.drawMenu();
                return;
            }
            i++;
        }
    }

    public function onNewSet(e:MouseEvent):void {
        var sES:*;
        outfit.pAV.items = game.copyObj(this.world.myAvatar.items);
        outfit.pAV.objData = game.copyObj(this.world.myAvatar.objData);
        var s_sES:Array = ["he", "ba", "ar", "co", "Weapon", "pe", "am", "mi"];
        for each (sES in s_sES) {
            if (outfit.pAV.objData.eqp[sES] != null) {
                outfit.pAV.loadMovieAtES(sES, outfit.pAV.objData.eqp[sES].sFile, outfit.pAV.objData.eqp[sES].sLink);
            } else {
                outfit.pAV.unloadMovieAtES(sES);
            }
        }
        this.interfaceOutfitEdit = new outfitedit(outfit, game, -1);
        this.setupEditor();
    }

    public function onUnlock(e:MouseEvent):void {
        this.game.MsgBox.notify("The ability to unlock more slots is not yet available.");
    }

    internal function setEnabled(mc:MovieClip, mode:Boolean):void {
        var mColorMatrix:ColorMatrixFilter;
        if (mode) {
            mc.buttonMode = true;
            mc.filters = [];
            return;
        }
        var colorFilter:AdjustColor = new AdjustColor();
        var mMatrix:Array = [];
        colorFilter.hue = 0;
        colorFilter.saturation = -100;
        colorFilter.brightness = 0;
        colorFilter.contrast = 0;
        mMatrix = colorFilter.CalculateFinalFlatArray();
        mColorMatrix = new ColorMatrixFilter(mMatrix);
        mc.buttonMode = false;
        mc.filters = [mColorMatrix];
    }


}
}//package 

