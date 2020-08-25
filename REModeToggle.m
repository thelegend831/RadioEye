classdef REModeToggle < handle
    %% Parameters
    properties
        Parent
        Position
    end
    %% UIControls
    properties
        tbEm % toggle button emulate
        tbAb % toggle button ablate
        tbCl % toggle button calibrate
    end
    %% Callback methods
    methods
        function push_tbEm(obj,src,edata)
            obj.tbEm.Value = 1;
            obj.tbEm.Enable = 'inactive';
            obj.tbAb.Value = 0;
            obj.tbAb.Enable = 'on';
            obj.tbCl.Value = 0;
            obj.tbCl.Enable = 'on';
            obj.Parent.Mode = 'Emulate';
        end
        function push_tbAb(obj,src,edata)
            obj.tbEm.Value = 0;
            obj.tbEm.Enable = 'on';
            obj.tbAb.Value = 1;
            obj.tbAb.Enable = 'inactive';
            obj.tbCl.Value = 0;
            obj.tbCl.Enable = 'on';
            obj.Parent.Mode = 'Ablate';
        end
        function push_tbCl(obj,src,edata)
            obj.tbEm.Value = 0;
            obj.tbEm.Enable = 'on';
            obj.tbAb.Value = 0;
            obj.tbAb.Enable = 'on';
            obj.tbCl.Value = 1;
            obj.tbCl.Enable = 'inactive';
            obj.Parent.Mode = 'Calibrate';
            Ref_SpectraLabeller;
        end
    end
    %% Obj methods
    methods
        function obj = REModeToggle(Parent,Position,Mode)
            obj.Parent = Parent;
            obj.Position = Position;
            x = Position(1); y = Position(2); W = Position(3); H = Position(4);
            unitH = H/3; gapH = 0;
            pos_tb3 = [x y W unitH];
            pos_tb2 = [x y+unitH+gapH W unitH];
            pos_tb1 = [x y+2*(unitH+gapH) W unitH];
            
            obj.tbEm = uicontrol(Parent.Interface,'Style','togglebutton',...
                'String','Emulate','Position',pos_tb1,...
                'Value',0,'Min',0,'Max',1,...
                'Callback',@obj.push_tbEm);
            
            obj.tbAb = uicontrol(Parent.Interface,'Style','togglebutton',...
                'String','Ablate','Position',pos_tb2,...
                'Value',0,'Min',0,'Max',1,...
                'Callback',@obj.push_tbAb);
            
            obj.tbCl = uicontrol(Parent.Interface,'Style','togglebutton',...
                'String','Calibrate','Position',pos_tb3,...
                'Value',0,'Min',0,'Max',1,...
                'Callback',@obj.push_tbCl);
            
            switch Mode
                case 'Emulate'
                    obj.tbEm.Value = 1;
                    obj.tbEm.Enable = 'inactive';
                case 'Ablate'
                    obj.tbAb.Value = 1;
                    obj.tbAb.Enable = 'inactive';
                case 'Calibrate'
                    obj.tbCl.Value = 1;
                    obj.tbCl.Enable = 'inactive';
            end
        end
    end
end