classdef RELegendArray < handle
    properties
        Parent
        Position
        
        EmLabelSystem
        AbLabelSystem
        ClLabelSystem
    end
    properties
        EmLegendArray RELegend
        AbLegendArray RELegend
        ClLegendArray RELegend
    end
    methods
        function modeDisplayUpdate(obj,src,edata)
            switch edata.AffectedObject.Mode
                case 'Emulate'
                    obj.turnOffAbArray();
                    obj.turnOffClArray();
                    obj.turnOnEmArray();
                case 'Ablate'
                    obj.turnOffEmArray();
                    obj.turnOffClArray();
                    obj.turnOnAbArray();
                case 'Calibrate'
                    obj.turnOffEmArray();
                    obj.turnOffAbArray();
                    obj.turnOnClArray();
            end
                
        end
        function turnOnEmArray(obj)
            for i = 1:length(obj.EmLegendArray)
                obj.EmLegendArray(i).turnOnLegend;
            end
        end
        function turnOffEmArray(obj)
            for i = 1:length(obj.EmLegendArray)
                obj.EmLegendArray(i).turnOffLegend;
                obj.EmLegendArray(i).turnOffEstimate;
                obj.EmLegendArray(i).turnOffTruth;
            end
        end
        function keepUniqueEmEstimate(obj,ind)
            for i = 1:length(obj.EmLegendArray)
                obj.EmLegendArray(i).turnOffEstimate();
            end
            obj.EmLegendArray(ind).turnOnEstimate();
        end
        function keepUniqueEmTruth(obj,ind)
            for i = 1:length(obj.EmLegendArray)
                obj.EmLegendArray(i).turnOffTruth();
            end
            obj.EmLegendArray(ind).turnOnTruth();
        end
        function turnOnAbArray(obj)
            for i = 1:length(obj.AbLegendArray)
                obj.AbLegendArray(i).turnOnLegend;
            end
        end
        function turnOffAbArray(obj)
            for i = 1:length(obj.AbLegendArray)
                obj.AbLegendArray(i).turnOffLegend;
                obj.AbLegendArray(i).turnOffEstimate;
                obj.AbLegendArray(i).turnOffTruth;
            end
        end
        function keepUniqueAbEstimate(obj,ind)
            for i = 1:length(obj.AbLegendArray)
                obj.AbLegendArray(i).turnOffEstimate();
            end
            obj.AbLegendArray(ind).turnOnEstimate();
        end
        function turnOnClArray(obj)
            for i = 1:length(obj.ClLegendArray)
                obj.ClLegendArray(i).turnOnLegend;
            end
        end
        function turnOffClArray(obj)
            for i = 1:length(obj.ClLegendArray)
                obj.ClLegendArray(i).turnOffLegend;
                obj.ClLegendArray(i).turnOffEstimate;
                obj.ClLegendArray(i).turnOffTruth;
            end
        end
        function loadEmLabelSystem(obj,Name)
            LabelSystem_temp = load(['LabelSystem_' Name '.mat']);
            obj.EmLabelSystem = LabelSystem_temp.LabelSystem;
        end
        function loadAbLabelSystem(obj,Name)
            LabelSystem_temp = load(['LabelSystem_' Name '.mat']);
            obj.AbLabelSystem = LabelSystem_temp.LabelSystem;
        end
        function loadClLabelSystem(obj,Name)
            LabelSystem_temp = load(['LabelSystem_' Name '.mat']);
            obj.ClLabelSystem = LabelSystem_temp.LabelSystem;
        end
        function updateEmLabelSystem(obj,src,edata)
            obj.loadEmLabelSystem(edata.AffectedObject.EmLabelSystemName);
            obj.deleteEmArray();
            obj.createEmArray();
        end
        function updateAbLabelSystem(obj,src,edata)
            obj.loadAbLabelSystem(edata.AffectedObject.AbLabelSystemName);
            obj.deleteAbArray();
            obj.createAbArray();
        end
        function updateClLabelSystem(obj,src,edata)
            obj.loadClLabelSystem(edata.AffectedObject.ClLabelSystemName);
            obj.deleteClArray();
            obj.createClArray();
        end
        function deleteEmArray(obj)
            for i = 1:length(obj.EmLegendArray)
                obj.EmLegendArray(i).delete();
            end
        end
        function deleteAbArray(obj)
            for i = 1:length(obj.AbLegendArray)
                obj.AbLegendArray(i).delete();
            end
        end
        function deleteClArray(obj)
            for i = 1:length(obj.ClLegendArray)
                obj.ClLegendArray(i).delete();
            end
        end
        function createEmArray(obj)
            Parent = obj.Parent;
            Position = obj.Position;
            x = Position(1); y = Position(2); W = Position(3); H = Position(4);
            unitH = H*20/300; gapH = H*15/300;
            pos_EmArray_y = arrayfun(@(i) y+(i-1)*(unitH+gapH), 1:length(obj.EmLabelSystem));
            for i = 1:length(obj.EmLabelSystem)
                obj.EmLegendArray(i) = RELegend(obj,Parent.Interface,...
                    [x pos_EmArray_y(i) W unitH],...
                    obj.EmLabelSystem(i).Name,obj.EmLabelSystem(i).Color,obj.EmLabelSystem(i).Index);
            end
        end
        function createAbArray(obj)
            Parent = obj.Parent;
            Position = obj.Position;
            x = Position(1); y = Position(2); W = Position(3); H = Position(4);
            unitH = H*20/300; gapH = H*15/300;
            pos_AbArray_y = arrayfun(@(i) y+(i-1)*(unitH+gapH), 1:length(obj.AbLabelSystem));
            for i = 1:length(obj.AbLabelSystem)
                obj.AbLegendArray(i) = RELegend(obj,Parent.Interface,...
                    [x pos_AbArray_y(i) W unitH],...
                    obj.AbLabelSystem(i).Name,obj.AbLabelSystem(i).Color,obj.AbLabelSystem(i).Index);
            end
        end
        function createClArray(obj)
            Parent = obj.Parent;
            Position = obj.Position;
            x = Position(1); y = Position(2); W = Position(3); H = Position(4);
            unitH = H*20/300; gapH = H*15/300;
            pos_ClArray_y = arrayfun(@(i) y+(i-1)*(unitH+gapH), 1:length(obj.ClLabelSystem));
            for i = 1:length(obj.ClLabelSystem)
                obj.ClLegendArray(i) = RELegend(obj,Parent.Interface,...
                    [x pos_ClArray_y(i) W unitH],...
                    obj.ClLabelSystem(i).Name,obj.ClLabelSystem(i).Color,obj.ClLabelSystem(i).Index);
                obj.ClLegendArray(i).enableButton();
            end
        end
        function EmulateLoaded(obj,src,edata)
            obj.turnOffEmArray();
            obj.turnOnEmArray();
            h_Emulate = edata.AffectedObject.Emulate;
            addlistener(h_Emulate,'currFrame','PostSet',@obj.EmulateUpdated);
        end
        function EmulateUpdated(obj,src,edata)
            h_Emulate = edata.AffectedObject;
            displayFrame = h_Emulate.currFrame-1;
            switch h_Emulate.samplingMode
                case 'Sequential'
                    truthFrame = displayFrame;
                case 'Random'
                    truthFrame = h_Emulate.randSequence(displayFrame);
            end
            estimateLbl = h_Emulate.Label(displayFrame);
            estimateInd = find([h_Emulate.LabelSystem.Index] == estimateLbl,1);
            if(h_Emulate.LabelFile)                
                truthLbl = h_Emulate.TruthLabel(truthFrame);
                truthInd = find([h_Emulate.LabelSystem.Index] == truthLbl,1);
                obj.keepUniqueEmTruth(truthInd);
            end
            obj.keepUniqueEmEstimate(estimateInd);
        end
        function AblateLoaded(obj,src,edata)
            obj.turnOffAbArray();
            obj.turnOnAbArray();
            h_Ablate = edata.AffectedObject.Ablate;
            addlistener(h_Ablate,'currFrame','PostSet',@obj.AblateUpdated);
        end
        function AblateUpdated(obj,src,edata)
            h_Ablate = edata.AffectedObject;
            displayFrame = h_Ablate.currFrame-1;
            estimateLbl = h_Ablate.Label(displayFrame);
            estimateInd = find([h_Ablate.LabelSystem.Index] == estimateLbl,1);
            obj.keepUniqueAbEstimate(estimateInd);
        end
    end
    methods
        function obj = RELegendArray(Parent,Position)
            obj.loadEmLabelSystem(Parent.EmLabelSystemName);
            obj.loadAbLabelSystem(Parent.AbLabelSystemName);
            obj.loadClLabelSystem(Parent.ClLabelSystemName);
            addlistener(Parent,'EmLabelSystemName','PostSet',@obj.updateEmLabelSystem);
            addlistener(Parent,'AbLabelSystemName','PostSet',@obj.updateAbLabelSystem);
            addlistener(Parent,'ClLabelSystemName','PostSet',@obj.updateClLabelSystem);
            
            obj.Parent = Parent;
            obj.Position = Position;
            
            obj.createEmArray();
            obj.createAbArray();
            obj.createClArray();
            
            obj.turnOnEmArray();
            addlistener(Parent,'Mode','PostSet',@obj.modeDisplayUpdate);
            addlistener(Parent,'Emulate','PostSet',@obj.EmulateLoaded);
            addlistener(Parent,'Ablate','PostSet',@obj.AblateLoaded);
        end
    end
end