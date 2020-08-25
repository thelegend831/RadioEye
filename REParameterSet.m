classdef REParameterSet < handle
    properties
        Parent
        ParentInterface
        Position
        labelText
        buttonText
    end
    properties (SetObservable,AbortSet)
        Visible
    end
    properties
        txLabel
        bxValue
        pbSet
    end
    methods
        function switchDisplay(obj,src,edata)
            switch edata.AffectedObject.Visible
                case 'on'
                    obj.txLabel.Visible = 'on';
                    obj.bxValue.Visible = 'on';
                    obj.pbSet.Visible = 'on';
                case 'off'
                    obj.txLabel.Visible = 'off';
                    obj.bxValue.Visible = 'off';
                    obj.pbSet.Visible = 'off';
                case 1
                    obj.txLabel.Visible = 'on';
                    obj.bxValue.Visible = 'on';
                    obj.pbSet.Visible = 'on';
                case 0
                    obj.txLabel.Visible = 'off';
                    obj.bxValue.Visible = 'off';
                    obj.pbSet.Visible = 'off';
            end
        end
    end
    methods
        function obj = REParameterSet(Parent,ParentInterface,Position,labelText,buttonText)
            obj.Parent = Parent;
            obj.ParentInterface = ParentInterface;
            obj.Position = Position;
            obj.labelText = labelText;
            obj.buttonText = buttonText;
            
            x = Position(1); y = Position(2); W = Position(3); H = Position(4);
            unitW = W*100/300;
            pos_lbl = [x y unitW H];
            pos_box = [x+unitW y unitW H];
            pos_set = [x+2*unitW y unitW H];
            
            obj.txLabel = uicontrol(ParentInterface,'Style','text','HorizontalAlignment','right',...
                'String',labelText,'Position',pos_lbl,'Visible','off');
            obj.bxValue = uicontrol(ParentInterface,'Style','edit',...
                'Position',pos_box,'String','','Visible','off');
            obj.pbSet = uicontrol(ParentInterface,'Style','pushbutton',...
                'String',buttonText,'Position',pos_set,'Visible','off');
            
            addlistener(obj,'Visible','PostSet',@obj.switchDisplay);
        end
    end
end