classdef Ref_UnitLabeller < handle
    %% Handles
    properties (Access = public)
        h_labelText
        h_labelButton
    end
    %% Contents
    properties (Access = public)
        Parent
        Position
        LabelName
        LabelColor
        LabelIndex
    end
    %% Constructor and Destructor
    methods (Access = public)
        function obj = Ref_UnitLabeller(Parent, Position, Name, Color, Index)
            obj.Parent = Parent;
            obj.Position = Position;
            obj.LabelName = Name;
            obj.LabelColor = Color;
            obj.LabelIndex = Index;
            
            obj.init();
        end
        
        function init(obj)
            
            %             labelPos = obj.Position;
            %             buttonPos = [labelPos(1)+labelPos(3) labelPos(2) labelPos(3) labelPos(4)];
            
            buttonPos = obj.Position;
            labelPos = [buttonPos(1)+buttonPos(3) buttonPos(2) buttonPos(3)*8 buttonPos(4)];
            
            ColorMatrix = zeros(25,25,3);
            ColorMatrix(:,:,1) = obj.LabelColor(1);
            ColorMatrix(:,:,2) = obj.LabelColor(2);
            ColorMatrix(:,:,3) = obj.LabelColor(3);
            
            obj.h_labelText = uicontrol(obj.Parent.h_figure,'Style','text','HorizontalAlignment','left',...
                'String',obj.LabelName,'Position',labelPos,...
                'FontSize',15,'FontWeight','bold');
            
            obj.h_labelButton = uicontrol(obj.Parent.h_figure,'Style','pushbutton',...
                'CData',ColorMatrix,'Position',buttonPos,...
                'Callback',@obj.pushLabelButton);
            
            %             obj.h_labelButton = uicontrol(obj.Parent.h_figure,'Style','pushbutton',...
            %                 'ForegroundColor',obj.LabelColor,'Position',buttonPos);
            
            
        end
        
        function delete(obj)
            delete(obj);
        end
    end
    
    methods (Access = public)
        function pushLabelButton(obj,hObject,eventData)
            app = obj.Parent;

            app.Label(app.LabelActive) = obj.LabelIndex;
            set(app.h_im_establishedLabel,'CData',app.Label);
            set(app.h_currLbl_Text,'String',obj.LabelName);
            
            set(app.h_startSelect_Box,'String','');
            set(app.h_endSelect_Box,'String','');
            app.LabelActive(:) = false;
            delete(app.h_im_activeLabel);
            drawnow;
        end
    end
end