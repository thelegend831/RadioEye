classdef RELegend < handle
    properties
        Parent
        ParentInterface
        Position
        LabelName
        LabelColor
        LabelIndex
        EstimateIconFile = 'icon25.png';
        %         TruthIconFile = 'rightMark25.png';
        TruthIconFile = 'Perry25.png';
    end
    properties
        pbEstimateMark
        pbTruthMark
        pbLabelButton
        txLabelText
    end
    methods
        function turnOnLegend(obj)
            obj.pbLabelButton.Visible = 'on';
            obj.txLabelText.Visible = 'on';
        end
        function turnOffLegend(obj)
            obj.pbLabelButton.Visible = 'off';
            obj.txLabelText.Visible = 'off';
        end
        function turnOnEstimate(obj)
            obj.pbEstimateMark.Visible = 'on';
        end
        function turnOffEstimate(obj)
            obj.pbEstimateMark.Visible = 'off';
        end
        function turnOnTruth(obj)
            obj.pbTruthMark.Visible = 'on';
        end
        function turnOffTruth(obj)
            obj.pbTruthMark.Visible = 'off';
        end
        function enableButton(obj)
            obj.pbLabelButton.Enable = 'on';
        end
        function inactivateButton(obj)
            obj.pbLabelButton.Enable = 'inactivate';
        end
    end
    methods
        function obj = RELegend(Parent,ParentInterface,Position,Name,Color,Index)
            % ParentInterface: the root figure where the legend is drawn.
            obj.Parent = Parent;
            obj.Parent = ParentInterface;
            obj.Position = Position;
            obj.LabelName = Name;
            obj.LabelColor = Color;
            obj.LabelIndex = Index;
            
            x = Position(1); y = Position(2); W = Position(3); H = Position(4);
            unitW1 = W*25/260; unitW2 = unitW1*8; gapW = W*5/260;
            pos_mark1 = [x y unitW1 H];
            pos_mark2 = [x+unitW1+gapW y unitW1 H];
            pos_button = [x+2*(unitW1+gapW) y unitW1 H];
            pos_text = [x+3*unitW1+2*gapW y unitW2 H];
            
            %             EstimateMatrix = zeros(25,25,3);
            %             EstimateMatrix(:,:,3) = 1;
            EstimateMatrix = imread(obj.EstimateIconFile);
             
            %             TruthMatrix = zeros(25,25,3);
            %             TruthMatrix(:,:,2) = 1;
            TruthMatrix = imread(obj.TruthIconFile);
            
            ButtonMatrix = zeros(25,25,3);
            ButtonMatrix(:,:,1) = Color(1);
            ButtonMatrix(:,:,2) = Color(2);
            ButtonMatrix(:,:,3) = Color(3);
            
            obj.pbEstimateMark = uicontrol(ParentInterface,'Style','pushbutton',...
                'CData',EstimateMatrix,'Position',pos_mark1,...
                'Enable','inactive','Visible','off');
            obj.pbTruthMark = uicontrol(ParentInterface,'Style','pushbutton',...
                'CData',TruthMatrix,'Position',pos_mark2,...
                'Enable','inactive','Visible','off');
            obj.pbLabelButton = uicontrol(ParentInterface,'Style','pushbutton',...
                'CData',ButtonMatrix,'Position',pos_button,...
                'Enable','inactive','Visible','off');
            obj.txLabelText = uicontrol(ParentInterface,'Style','text','HorizontalAlignment','left',...
                'String',Name,'Position',pos_text,...
                'FontSize',15,'FontWeight','bold');
        end
        function delete(obj)
            obj.pbEstimateMark.delete();
            obj.pbTruthMark.delete();
            obj.pbLabelButton.delete();
            obj.txLabelText.delete();
        end
    end
end